//
//  ShiftTableListTableViewController.swift
//  J4ShiftTable
//
//  Created by JHLin on 2017/6/1.
//  Copyright © 2017年 JHL. All rights reserved.
//

import UIKit

class ShiftTableListTableViewController: UITableViewController {
    
    var allManager = [ShiftTableManager]()
    var createdOfShift = [Int64]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    private func updateUI() {
        allManager = ShiftTableManager().loadAllShiftTable()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allManager.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shift table", for: indexPath)

        // Configure the cell...
        let fmt = DateFormatter()
        fmt.dateFormat = "MM/dd"
        
        cell.textLabel?.text = fmt.string(from: allManager[indexPath.row].startDate)+" - "+fmt.string(from: allManager[indexPath.row].endDate)
        
        var detailText = "Employees:"
        for i in 0..<allManager[indexPath.row].shiftAssignment.count {
            detailText += allManager[indexPath.row].shiftAssignment[i].employeeName
            
            if i != allManager[indexPath.row].shiftAssignment.count - 1{
                detailText += ","
            }
        }
        
        cell.detailTextLabel?.text = detailText
        
        createdOfShift.insert(allManager[indexPath.row].created, at: indexPath.row)

        return cell
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            allManager[indexPath.row].deleteShiftTable(by: createdOfShift[indexPath.row])
            //allManager = ShiftTableManager().loadAllShiftTable()
            
            updateUI()
            
            //tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let stcvc = segue.destination as? ShiftTableCollectionViewController {
            let row = tableView.indexPathForSelectedRow?.row
             print("---> segue \(createdOfShift[row!])")
            stcvc.createdNum = createdOfShift[row!]

        }
        
    }
    

}
