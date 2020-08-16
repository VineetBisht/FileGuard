//
//  Backup+CoreDataProperties.swift
//  
//
//  Created by Vineet Singh on 2020-08-12.
//
//

import Foundation
import CoreData


extension Backup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Backup> {
        return NSFetchRequest<Backup>(entityName: "Backup")
    }

    @NSManaged public var image: NSData?

}
