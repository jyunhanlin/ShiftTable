//
//  ShiftTableCollectionViewController.swift
//  J4ShiftTable
//
//  Created by JHLin on 2017/5/16.
//  Copyright © 2017年 JHL. All rights reserved.
//
//  TODO: UICollectionView + CoreData, reolad data after database update
//

import UIKit

class ShiftTableCollectionViewController: UICollectionViewController
{
    
    var createdNum: Int64 = 0 {
        didSet {
            updateUI()
        }
    }
    
    private var manager = ShiftTableManager()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (collectionView?.collectionViewLayout as? ShiftTableCollectionViewLayout)?.dataSourceDidUpdate = true
        (collectionView?.collectionViewLayout as? ShiftTableCollectionViewLayout)?.cellAttrsDictionary.removeAll()
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollToToday()
    }
    
    private func updateUI() {
        
        if createdNum == 0 {
            manager = manager.loadLatestShiftTable()
        } else {
            manager = manager.loadShiftTable(by: Int(createdNum))
        }
        collectionView?.reloadData()
    }
    
    private var todayIndexPath: IndexPath?
    private var todayString: String {
        get {
            let today = Date()
            let fmt = DateFormatter()
            fmt.dateFormat = "MM/dd"
            return fmt.string(from: today)
        }
    }

    private func scrollToToday() {
        if manager.numberOfEmployees() > 0 {

            let dates = manager.getDays()
            
            if let sections = collectionView?.numberOfSections {
                for count in 1..<sections {
                    if todayString == dates[count-1] {
                        let cellIndexPath = IndexPath(item: 0, section: count)
                        collectionView?.scrollToItem(at: cellIndexPath, at: .centeredVertically, animated: true)
                        todayIndexPath = cellIndexPath
                        print("scroll to \(cellIndexPath)")
                    }
                }
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return manager.numberOfDays() + 1
        
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if manager.numberOfEmployees() == 0 {
            return 0
        } else {
            return manager.numberOfEmployees() + 1
        }
    }
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shift cell", for: indexPath)
        
        // Configure the cell
        if manager.numberOfEmployees() > 0 {
            if let stcvc = cell as? ShiftTableCollectionViewCell {
                if indexPath.section == 0 && indexPath.item == 0 {
                    stcvc.label.text = "Date/Name"
                } else {
                    if indexPath.section == 0 {
                        stcvc.label.text = manager.shiftAssignment[indexPath.item-1].employeeName
                    } else if indexPath.item == 0 {
                        let days = manager.getDays()
                        stcvc.label.text = days[indexPath.section-1]
                        
                        if todayString == stcvc.label.text {
                            todayIndexPath = indexPath
                        }
                    } else if indexPath.section != 0 {
                        let date = manager.getDays()[indexPath.section-1]
                        stcvc.label.text = manager.shiftAssignment[indexPath.item-1].assignment[date]
                    }
                }
                
                if indexPath.section == 0 {
                    stcvc.label.textColor = UIColor.white
                    stcvc.backgroundColor = UIColor(red: 0x88/255, green: 0xAF/255, blue: 0x4B/255, alpha: 1)
                } else {
                    stcvc.label.textColor = UIColor.black
                    if indexPath.section % 2 == 0 {
                        stcvc.backgroundColor = UIColor(white: 242/255.0, alpha: 1)
                    } else {
                        stcvc.backgroundColor = UIColor.white
                    }
                    
                    if indexPath.section == todayIndexPath?.section {
                        stcvc.backgroundColor = UIColor(red: 0xCC/255, green: 0xF8/255, blue: 0xFF/255,alpha: 1)
                    }
                }
                
            }
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("item:\(indexPath.item) section:\(indexPath.section)")
        if indexPath.section == 0 || indexPath.row == 0 {
            return
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as? ShiftTableCollectionViewCell
            print(cell?.label.text ?? "GG")
            if let labelText = cell?.label.text, labelText != "" {
                let alert = UIAlertController(title: cell?.label.text, message: RecentlyInput.assignDescription[(cell?.label.text)!], preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Enter", style: .default, handler: nil))
                
                present(alert, animated: true, completion: nil)
            }
        }
    }


    @IBAction func refresh(_ sender: UIBarButtonItem) {
        print("refresh")
        (collectionView?.collectionViewLayout as? ShiftTableCollectionViewLayout)?.dataSourceDidUpdate = true
        (collectionView?.collectionViewLayout as? ShiftTableCollectionViewLayout)?.cellAttrsDictionary.removeAll()
        updateUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "create shift table" {
                createdNum = 0
            }
        }
    }

}
