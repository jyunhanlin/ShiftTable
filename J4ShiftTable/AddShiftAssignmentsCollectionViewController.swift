//
//  AddShiftAssignmentsCollectionViewController.swift
//  J4ShiftTable
//
//  Created by JHLin on 2017/5/22.
//  Copyright © 2017年 JHL. All rights reserved.
//

import UIKit


class AddShiftAssignmentsCollectionViewController: UICollectionViewController
{
    
    var manager = ShiftTableManager()
    
    private var selectAssignment = ""
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (collectionView?.collectionViewLayout as? ShiftTableCollectionViewLayout)?.dataSourceDidUpdate = true
        collectionView?.reloadData()
    }


    @IBAction func done(_ sender: UIBarButtonItem) {
        manager.saveShiftTable(from: manager)
        presentingViewController?.dismiss(animated: true)
    }

    @IBAction func cancel(_ sender: UIBarButtonItem) { presentingViewController?.dismiss(animated: true) }
    
    @IBAction func selectAssignment(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Select Assignment", message: "", preferredStyle: .actionSheet)
        
        for assign in manager.shifts.keys {
            alert.addAction(UIAlertAction(title: assign, style: .default, handler: { [weak self](action: UIAlertAction) -> Void in
                self?.selectAssignment = assign
            }))
        }
        
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        collectionView?.reloadData()
    }
    // MARK: UICollectionViewDataSource
    


    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return manager.numberOfDays()+1
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "assignment cell", for: indexPath)
    
        // Configure the cell
        if let stcvc = cell as? AddShiftAssignmentsCollectionViewCell {
            if indexPath.section == 0 && indexPath.item == 0 {
                stcvc.label.text = "Date/Name"
            } else {
                if indexPath.section == 0 {
                    stcvc.label.text = manager.shiftAssignment[indexPath.item-1].employeeName
                } else if indexPath.item == 0 {
                    let days = manager.getDays()
                    stcvc.label.text = days[indexPath.section-1]
                } else if indexPath.section != 0 {
                    let date = manager.getDays()[indexPath.section-1]
                    stcvc.label.text = manager.shiftAssignment[indexPath.item-1].assignment[date]
                }
            }
        }
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 || indexPath.row == 0 {
            return
        } else {
            let nameIndexPath = IndexPath(item: indexPath.item, section: 0)
            let name = (collectionView.cellForItem(at: nameIndexPath) as? AddShiftAssignmentsCollectionViewCell)?.label.text
            let dateIndexPath = IndexPath(item: 0, section: indexPath.section)
            let date = (collectionView.cellForItem(at: dateIndexPath) as? AddShiftAssignmentsCollectionViewCell)?.label.text
            
            print("-----> \(name!) is assigned \(selectAssignment) on \(date!)")
            (collectionView.cellForItem(at: indexPath) as? AddShiftAssignmentsCollectionViewCell)?.label.text = selectAssignment
            
            if let i = manager.shiftAssignment.index(where: { $0.employeeName == name }) {
                manager.shiftAssignment[i].assignment[date!] = selectAssignment
            }
        }
    }
    



}
