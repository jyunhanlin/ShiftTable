//
//  ShiftTableManager.swift
//  J4ShiftTable
//
//  Created by JHLin on 2017/5/26.
//  Copyright © 2017年 JHL. All rights reserved.
//

import Foundation
import UIKit
import CoreData


struct ShiftTableManager
{
    var created: Int64 = 0
    var startDate = Date()
    var endDate = Date()
    var shifts = [String: String]()
    var shiftAssignment = [ShiftAssignment]()
    
    
    struct ShiftAssignment {
        var employeeName = ""
        var employeeID = -1
        var assignment = [String: String]()
    }
    
    func numberOfEmployees() -> Int{
        if shiftAssignment.isEmpty {
            return 0
        } else {
            return shiftAssignment.count
        }
    }
    
    func numberOfDays() -> Int {
        if shiftAssignment.isEmpty {
            return 0
        } else {
            let days = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day
            return days! + 1
        }
    }
    
    func getDays() -> [String] {
        var days = [String]()
        
        var date = startDate
        let end = endDate
        
        let fmt = DateFormatter()
        fmt.dateFormat = "MM/dd"
        
        while date <= end {
            days.append(fmt.string(from: date))
            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        }
        
        return days
    }
    
    private var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    func loadLatestShiftTable() -> ShiftTableManager {
        let allShiftTable = loadAllShiftTable()
        if allShiftTable.isEmpty {
            return ShiftTableManager()
        } else {
            return allShiftTable[0]
        }
    }
    
    func loadShiftTable(by created:Int) -> ShiftTableManager {
        let allShiftTable = loadAllShiftTable()
        if let i = allShiftTable.index(where: { Int($0.created) == created }) {
            return allShiftTable[i]
        } else {
            return ShiftTableManager()
        }
    }
    
    func loadAllShiftTable() -> [ShiftTableManager]{
        var allManager = [ShiftTableManager]()
        var shiftTables: [ShiftTable]?
        
        if let context = container?.viewContext {
            let shiftTableRequest: NSFetchRequest<ShiftTable> = ShiftTable.fetchRequest()
            shiftTableRequest.sortDescriptors = [NSSortDescriptor(
                key: "created",
                ascending: false
                )]
            shiftTables = try? context.fetch(shiftTableRequest)
            
            for aShift in shiftTables! {
                var manager = ShiftTableManager()
                manager.created = aShift.created
                manager.startDate = aShift.startDate! as Date
                manager.endDate = aShift.endDate! as Date
                
                let employees = (aShift.employees?.allObjects as? [Employee])?.sorted(by: {$0.id < $1.id})
                
                for index in 0..<(employees?.count)! {
                    var assign = ShiftTableManager.ShiftAssignment()
                    
                    assign.employeeName = (employees?[index].name)!
                    assign.employeeID = Int((employees?[index].id)!)
                    
                    for shift in (employees?[index].shifts?.allObjects as? [Shift])!.sorted(by: { $0.date! < $1.date! }) {
                        //manager.shiftAssignment[index].assignment[shift.date!] = shift.assignment
                        assign.assignment[shift.date!] = shift.assignment
                    }
                    manager.shiftAssignment.append(assign)
                }
                
                allManager.append(manager)
            }
        }
        

        
        return allManager
    }
    
    func saveShiftTable(from manager: ShiftTableManager) {
        print("starting database load")
        
        //container?.performBackgroundTask { context in
        if let context = container?.viewContext {
            //context.perform {
                _ = try? ShiftTable.createShiftTable(from: manager, in: context)
                
                try? context.save()
                print("done loading database")
                self.printDatabaseStatistics()
            //}
        }
        
    }
    
    func deleteShiftTable(by created: Int64) {
        if let context = container?.viewContext {
            try? ShiftTable.deleteShiftTable(by: created, in: context)
            try? context.save()
            print("done delete database")
            self.printDatabaseStatistics()
        }
    }
    
    private func printDatabaseStatistics() {
        if let context = container?.viewContext {
            context.perform {
                if Thread.isMainThread {
                    print("on main thread")
                } else {
                    print("off main thread")
                }
                
                // good way to count
                if let shiftTableCount = try? context.count(for: ShiftTable.fetchRequest()) {
                    print("\(shiftTableCount) shift table")
                }
                
                // good way to count
                if let employeeCount = try? context.count(for: Employee.fetchRequest()) {
                    print("\(employeeCount) employee")
                }
                
                // good way to count
                if let shiftCount = try? context.count(for: Shift.fetchRequest()) {
                    print("\(shiftCount) shift")
                }
            }
        }
    }
}
