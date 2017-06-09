//
//  AddTableViewController.swift
//  J4ShiftTable
//
//  Created by JHLin on 2017/6/5.
//  Copyright © 2017年 JHL. All rights reserved.
//

import UIKit

class AddShiftsTableViewController: UITableViewController {

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true)
    }


    
    // MARK: - Navigation

    private var adptvc: AddDatePeriodTableViewController?
    private var aetvc: AddEmployeeTableViewController?
    private var aatvc: AddAssignmentTableViewController?
    
    private var manager = ShiftTableManager()
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let identifier = segue.identifier {
            switch identifier {
            case "add date period":
                adptvc = segue.destination as? AddDatePeriodTableViewController
            case "add employee":
                let navcom = segue.destination as? UINavigationController
                aetvc = navcom?.visibleViewController as? AddEmployeeTableViewController
            case "add assignment":
                let navcom = segue.destination as? UINavigationController
                aatvc = navcom?.visibleViewController as? AddAssignmentTableViewController
            case "add shift assignment":
                saveRecentlyInput()
                gatherManagerContent()

                if let asacvc = segue.destination as? AddShiftAssignmentsCollectionViewController {
                    asacvc.manager = manager
                }
                
            default:
                break
            }
        }
    }
    
    private func saveRecentlyInput() {
        if let employees = aetvc?.employees {
            for name in employees {
                RecentlyInput.addEmployee(name)
            }
        }
        
        if let assignments = aatvc?.assignment {
            for assign in assignments {
                RecentlyInput.addAssignment(assign)
            }
        }
        
        if let assignDescription = aatvc?.assignDescription {
            for assign in assignDescription.keys {
                RecentlyInput.addAssignDescription(assign, value: assignDescription[assign] ?? "")
            }
        }
    }
    
    private func gatherManagerContent() {
        
        if let date = adptvc?.startDate {
            manager.startDate = date
        }
        
        if let date = adptvc?.endDate {
            manager.endDate = date
        }
        
        
        if let assignments = aatvc?.assignment, let assignDescription = aatvc?.assignDescription {
            for assign in assignments {
                manager.shifts[assign] = ""
                if assignDescription.keys.contains(assign) {
                    manager.shifts[assign] = assignDescription[assign]
                }
            }
        }
        
        var idIndex = 0
        if let employees = aetvc?.employees {
            for name in employees {
                var shiftAssignment = ShiftTableManager.ShiftAssignment()
                shiftAssignment.employeeName = name
                shiftAssignment.employeeID = idIndex
                manager.shiftAssignment.append(shiftAssignment)
                idIndex += 1
            }
        }

        
        for i in 0..<manager.shiftAssignment.count {
            for date in manager.getDays() {
                manager.shiftAssignment[i].assignment[date] = ""
            }
        }
    }
    

}
