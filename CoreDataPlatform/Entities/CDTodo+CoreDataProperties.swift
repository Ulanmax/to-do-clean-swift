//
//  CDPost+CoreDataProperties.swift
//  
//
//  Created by Andrey Yastrebov on 04.04.17.
//
//

import Foundation
import CoreData


extension CDTodo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDTodo> {
        return NSFetchRequest<CDTodo>(entityName: "CDTodo")
    }

    @NSManaged public var body: String?
    @NSManaged public var title: String?
    @NSManaged public var uid: String?
    @NSManaged public var userId: String?
    @NSManaged public var createdAt: String?
    @NSManaged public var completed: Bool
}
