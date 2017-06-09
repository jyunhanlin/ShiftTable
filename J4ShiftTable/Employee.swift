//
//  Employee.swift
//  J4ShiftTable
//
//  Created by JHLin on 2017/5/18.
//  Copyright © 2017年 JHL. All rights reserved.
//

import UIKit
import CoreData

class Employee: NSManagedObject
{
    
    static func createEmployee(for employeeName: String, and id: Int, assignment: [String : String], in context: NSManagedObjectContext) throws -> Employee
    {
//        let request: NSFetchRequest<Employee> = Employee.fetchRequest()
//        request.predicate = NSPredicate(format: "shiftTable.created = %lld && name = %@", created, employeeName)
//        do {
//            let matches = try context.fetch(request)
//            if matches.count > 0 {
//                assert(matches.count == 1, "Employee.findOrCreateEmployee -- database inconsistency!")
//                return matches[0]
//            }
//        } catch {
//            throw error
//        }
        
        let employee = Employee(context: context)
        employee.id = Int64(id)
        employee.name = employeeName
        addShifts(for: employeeName, assignment: assignment, employee: employee, inManagedObjectContext: context)
        return employee
    }
    
    static func addShifts(for employeeName: String, assignment: [String : String], employee: Employee, inManagedObjectContext context: NSManagedObjectContext){
        for assign in assignment {
            if let shift = try? Shift.createShift(for: employeeName, date: assign.key, assign: assign.value, in: context) {
                //let shifts = employee.mutableSetValue(forKey: "shifts")
                //shifts.add(shift)
                employee.addToShifts(shift)
            }
        }
    }
    
    static func remove(employee: Employee, in context: NSManagedObjectContext) {
        if let shifts = employee.shifts?.allObjects as? [Shift] {
            for shift in shifts {
                Shift.remove(shift: shift, in: context)
            }
        }
        context.delete(employee)

    }
}
