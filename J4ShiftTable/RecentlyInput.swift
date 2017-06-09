//
//  RecentlyInput.swift
//  J4ShiftTable
//
//  Created by JHLin on 2017/6/8.
//  Copyright © 2017年 JHL. All rights reserved.
//

import Foundation


struct RecentlyInput {
    private static let defaults = UserDefaults.standard
    
    static var employees: [String] {
        return defaults.array(forKey: "RecentlyInputForEmployees") as? [String] ?? []
    }
    
    static func addEmployee(_ key:String) {
        var employeesArray = employees
        if !employeesArray.contains(key) {
            employeesArray.append(key)
        }
        defaults.set(employeesArray, forKey: "RecentlyInputForEmployees")
    }
    
    static func removeEmployee(at index:Int) {
        var employeesArray = employees
        if index < employeesArray.count {
            employeesArray.remove(at: index)
        }
        defaults.set(employeesArray, forKey: "RecentlyInputForEmployees")
    }
    
    static var assignment: [String] {
        return defaults.array(forKey: "RecentlyInputForAssignment") as? [String] ?? []
    }
    
    static func addAssignment(_ key:String) {
        var assignmentArray = assignment
        if !assignmentArray.contains(key) {
            assignmentArray.append(key)
        }
        defaults.set(assignmentArray, forKey: "RecentlyInputForAssignment")
    }
    
    static func removeAssignment(at index:Int) {
        var assignmentArray = assignment
        if index < assignmentArray.count {
            assignmentArray.remove(at: index)
        }
        defaults.set(assignmentArray, forKey: "RecentlyInputForAssignment")
    }
    
    static var assignDescription: [String : String] {
        return defaults.dictionary(forKey: "RecentlyInputForAssignDescription") as? [String : String] ?? [:]
    }
    
    static func addAssignDescription(_ key:String, value: String) {
        var assignDescriptionDictionary = assignDescription
        assignDescriptionDictionary[key] = value
        defaults.set(assignDescriptionDictionary, forKey: "RecentlyInputForAssignDescription")
    }
    
    static func removeAssignDescription(forKey: String) {
        var assignDescriptionDictionary = assignDescription
        assignDescriptionDictionary.removeValue(forKey: forKey)
        defaults.set(assignDescriptionDictionary, forKey: "RecentlyInputForAssignDescription")
    }
    
    
}
