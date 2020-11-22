//
//  Configuration+CoreDataProperties.swift
//  equal sounds
//
//  Created by Brandon Clark on 11/21/20.
//
//

import Foundation
import CoreData


extension Configuration {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Configuration> {
        return NSFetchRequest<Configuration>(entityName: "Configuration")
    }

    @NSManaged public var name: String?

}

extension Configuration : Identifiable {

}
