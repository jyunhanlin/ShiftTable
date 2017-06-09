//
//  ShiftTable.swift
//  J4ShiftTable
//
//  Created by JHLin on 2017/5/31.
//  Copyright © 2017年 JHL. All rights reserved.
//

import UIKit
import CoreData

class ShiftTable: NSManagedObject {
    
    
    static func createShiftTable(from manager: ShiftTableManager, in context: NSManagedObjectContext) throws -> ShiftTable
    {
//        let request: NSFetchRequest<ShiftTable> = ShiftTable.fetchRequest()
//        request.predicate = NSPredicate(format: "startDate = %@ && endDate = %@", manager.startDate as NSDate , manager.endDate as NSDate)
//        do {
//            let matches = try context.fetch(request)
//            if matches.count > 0 {
//                assert(matches.count == 1, "ShiftTable.findOrCreateShiftTable -- database inconsistency!")
//                return matches[0]
//            }
//        } catch {
//            throw error
//        }
        
        let shiftTable = ShiftTable(context: context)
        let now = Date()
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        shiftTable.created = Int64(timeInterval)
        shiftTable.startDate = manager.startDate as NSDate
        shiftTable.endDate = manager.endDate as NSDate
        addEmployees(from: manager, shiftTable: shiftTable, inManagedObjectContext: context)
        return shiftTable
    }
    
    static func addEmployees(from manager: ShiftTableManager, shiftTable: ShiftTable, inManagedObjectContext context: NSManagedObjectContext){
        for shiftAssignment in manager.shiftAssignment{
            if let employee = try? Employee.createEmployee(for: shiftAssignment.employeeName, and: shiftAssignment.employeeID, assignment: shiftAssignment.assignment, in: context) {
                //let employees = shiftTable.mutableSetValue(forKey: "employees")
                //employees.add(employee)
                shiftTable.addToEmployees(employee)
            }
        }
    }
    
    static func deleteShiftTable(by created:Int64, in context: NSManagedObjectContext) throws {
        let request: NSFetchRequest<ShiftTable> = ShiftTable.fetchRequest()
        request.predicate = NSPredicate(format: "created = %lld", created)
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, " -- database inconsistency!")
                if let employees = matches[0].employees?.allObjects as? [Employee] {
                    for employee in employees {
                        Employee.remove(employee: employee, in: context)
                    }
                }
                context.delete(matches[0])
            }
        } catch {
            throw error
        }
    }

}
