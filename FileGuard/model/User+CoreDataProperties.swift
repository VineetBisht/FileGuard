//
//  User+CoreDataProperties.swift
//  
//
//  Created by Vineet Singh on 2020-08-12.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var image: NSData?

}
