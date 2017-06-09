//
//  AddDatePeriodTableViewController.swift
//  J4ShiftTable
//
//  Created by JHLin on 2017/6/4.
//  Copyright © 2017年 JHL. All rights reserved.
//

import UIKit

class AddDatePeriodTableViewController: UITableViewController {
    
    var startDate: Date?
    var endDate: Date?
    
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    
    @IBAction func startDatePicker(_ sender: UITextField) {
        createDatePickerView(myTextFiled: sender, mySelector: #selector(startDatePickerValueChanged(_:)))
    }

    @IBAction func endDatePicker(_ sender: UITextField) {
        createDatePickerView(myTextFiled: sender, mySelector: #selector(endDatePickerValueChanged(_:)))
    }
    
    private func createDatePickerView(myTextFiled: UITextField ,mySelector: Selector) {
        
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        myTextFiled.inputView = datePickerView
        datePickerView.addTarget(self, action: mySelector, for: .valueChanged)
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(dismissPicker(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        myTextFiled.inputAccessoryView = toolBar
    }
    
    @objc private func startDatePickerValueChanged(_ sender:UIDatePicker) {
        let date = dateString(from:sender)
        startDateTextField.text = date.year+" "+date.month+"/"+date.day
        startDate = sender.date
    }
    
    @objc private func endDatePickerValueChanged(_ sender:UIDatePicker) {
        let date = dateString(from:sender)
        endDateTextField.text = date.year+" "+date.month+"/"+date.day
        endDate = sender.date
    }
    
    @objc func dismissPicker(_ sender: UIBarButtonItem) { view.endEditing(true) }
    
    
    private func dateString(from datePicker:UIDatePicker) -> (year: String, month:String, day:String) {
        let componenets = Calendar.current.dateComponents([.year, .month, .day], from: datePicker.date)
        let year = componenets.year
        let day = componenets.day
        let month = componenets.month
        
        return (String(year!), String(month!), String(day!))
    }

}
