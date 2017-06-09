//
//  AddEmployeeTableViewController.swift
//  J4ShiftTable
//
//  Created by JHLin on 2017/6/4.
//  Copyright © 2017年 JHL. All rights reserved.
//

import UIKit

class AddEmployeeTableViewController: UITableViewController, UITextFieldDelegate {

    var employees = RecentlyInput.employees
    {
        didSet {
            print(employees)
        }
    }
    
    private var selectedIndexPath = IndexPath()

    // MARK: - Table view data source
    
    
    @IBAction func addEmployee(_ sender: UIBarButtonItem) {
        employees.append("")
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return employees.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Employee Cell", for: indexPath)
        
        // Configure the cell...
        let cellFrame = tableView.rectForRow(at: indexPath)

        cell.addSubview(createTextField(indexPath:indexPath, width: cellFrame.size.width, height: cellFrame.size.height))

        return cell
    }
    
    private func createTextField(indexPath: IndexPath, width: CGFloat, height: CGFloat) -> UITextField {
        let employeeTextField = UITextField(frame: CGRect(x: 10, y: 0, width: width-10, height: height))
        if employees[indexPath.row] != "" {
            employeeTextField.text = employees[indexPath.row]
        } else {
            employeeTextField.placeholder = "Enter employee name"
        }
        employeeTextField.font = UIFont.systemFont(ofSize: 17)
        employeeTextField.borderStyle = .none
        employeeTextField.autocorrectionType = UITextAutocorrectionType.no
        employeeTextField.keyboardType = UIKeyboardType.default
        employeeTextField.returnKeyType = UIReturnKeyType.done
        employeeTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        employeeTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        employeeTextField.delegate = self
        return employeeTextField
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let pointInTable = textField.convert(textField.bounds.origin, to: tableView)
        if let indexPath =  tableView.indexPathForRow(at: pointInTable) {
            selectedIndexPath = indexPath
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("TextField did end editing method called")
        if textField.text != "" {
            employees[(selectedIndexPath.row)] = textField.text!
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("TextField should return method called")
        if textField.text != "" {
            employees[(selectedIndexPath.row)] = textField.text!
        }        
        textField.resignFirstResponder()
        return true
    }
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if employees[indexPath.row] != "" {
                RecentlyInput.removeEmployee(at: indexPath.row)
            }
            employees.remove(at: indexPath.row)
            
            if let cell = tableView.cellForRow(at: indexPath) {
                for subview in cell.subviews {
                    if subview is UITextField {
                        subview.removeFromSuperview()
                    }
                }
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

}
