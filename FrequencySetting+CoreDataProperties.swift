//
//  FrequencySetting+CoreDataProperties.swift
//  equal sounds
//
//  Created by Gray, John Walker on 12/13/20.
//
//

import Foundation
import CoreData


extension FrequencySetting {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FrequencySetting> {
        return NSFetchRequest<FrequencySetting>(entityName: "FrequencySetting")
    }

    @NSManaged public var gain: Float
    @NSManaged public var frequency: Float
    @NSManaged public var configuration: EqualizerSavedConfiguration?

}

extension FrequencySetting : Identifiable {

}
