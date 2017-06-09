//
//  Shift.swift
//  J4ShiftTable
//
//  Created by JHLin on 2017/5/18.
//  Copyright © 2017年 JHL. All rights reserved.
//

import UIKit
import CoreData

class Shift: NSManagedObject
{
    static func createShift(for employeeName: String, date: String, assign: String ,in context: NSManagedObjectContext) throws -> Shift
    {
//        let request: NSFetchRequest<Shift> = Shift.fetchRequest()
//        request.predicate = NSPredicate(format: "employee.name = %@ && date = %@", employeeName, date)
//        do {
//            let matches = try context.fetch(request)
//            if matches.count > 0 {
//                assert(matches.count == 1, "Shift.findOrCreateShift -- database inconsistency!")
//                return matches[0]
//            }
//        } catch {
//            throw error
//        }

        let shift = Shift(context: context)
        shift.date = date
        shift.assignment = assign
        return shift
    }
    
    static func remove(shift: Shift, in context: NSManagedObjectContext) {
        context.delete(shift)
    }

}
