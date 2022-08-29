//
//  Employee+CoreDataProperties.swift
//  useCoreDataDemo
//
//  Created by iMac on 27/08/22.
//
//

import Foundation
import CoreData


extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }

    @NSManaged public var name: String?
    @NSManaged public var designation: String?

}

extension Employee : Identifiable {
    
}
