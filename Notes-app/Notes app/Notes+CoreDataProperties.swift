//
//  Notes+CoreDataProperties.swift
//  Notes app
//
//  Created by Mac on 21/04/2023.
//
//

import Foundation
import CoreData


extension Notes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Notes> {
        return NSFetchRequest<Notes>(entityName: "Notes")
    }

    @NSManaged public var desc: String?
    @NSManaged public var date: Date?

}

extension Notes : Identifiable {

}
