//
//  AddAssignmentTableViewController.swift
//  J4ShiftTable
//
//  Created by JHLin on 2017/6/5.
//  Copyright © 2017年 JHL. All rights reserved.
//

import UIKit

class AddAssignmentTableViewController: UITableViewController, UITextFieldDelegate {

    var assignment = RecentlyInput.assignment
    var assignDescription = RecentlyInput.assignDescription {
        didSet {
            print(assignDescription)
        }
    }
    
    private var selectedIndexPath = IndexPath()

    @IBAction func addAssignment(_ sender: UIBarButtonItem) {
        assignment.append("")
        tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return assignment.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Assignment Cell", for: indexPath)

        // Configure the cell...
        let cellFrame = tableView.rectForRow(at: indexPath)
        
        cell.accessoryType = .detailButton
        
        cell.addSubview(createTextField(indexPath:indexPath, width: cellFrame.size.width*5/6, height: cellFrame.size.height))
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print("accessory button push \(indexPath)")
        
        let alert = UIAlertController(title: "Assignment Description", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(
            title: "Enter",
            style: .default)
            { [weak self] (action: UIAlertAction) -> Void in
                if let tf = alert.textFields?.first{
                    self?.assignDescription[(self?.assignment[indexPath.row])!] = tf.text
                }
            }
        )

        alert.addTextField(configurationHandler: { [weak self] textField in
                if let key = self?.assignment[indexPath.row] {
                    textField.text = self?.assignDescription[key]
                } else {
                    textField.placeholder = "Please enter the description"
                }
            })
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    private func createTextField(indexPath: IndexPath, width: CGFloat, height: CGFloat) -> UITextField {
        let assignTextField = UITextField(frame: CGRect(x: 10, y: 0, width: width, height: height))
        if assignment[indexPath.row] != "" {
            assignTextField.text = assignment[indexPath.row]
        } else {
            assignTextField.placeholder = "Enter assign"
        }
        assignTextField.font = UIFont.systemFont(ofSize: 17)
        assignTextField.borderStyle = .none
        assignTextField.autocorrectionType = UITextAutocorrectionType.no
        assignTextField.keyboardType = UIKeyboardType.default
        assignTextField.returnKeyType = UIReturnKeyType.done
        assignTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        assignTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        assignTextField.delegate = self
        return assignTextField
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let pointInTable = textField.convert(textField.bounds.origin, to: tableView)
        selectedIndexPath = tableView.indexPathForRow(at: pointInTable)!
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("TextField did end editing method called")
        if textField.text != "" {
            assignment[selectedIndexPath.row] = textField.text!
        }
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("TextField should return method called")
        if textField.text != "" {
            assignment[selectedIndexPath.row] = textField.text!
        }
        textField.resignFirstResponder()
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if assignment[indexPath.row] != "" {
                RecentlyInput.removeAssignDescription(forKey: assignment[indexPath.row])
                RecentlyInput.removeAssignment(at: indexPath.row)
            }
            assignDescription.removeValue(forKey: assignment[indexPath.row])
            assignment.remove(at: indexPath.row)

            
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
