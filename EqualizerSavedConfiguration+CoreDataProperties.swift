//
//  EqualizerSavedConfiguration+CoreDataProperties.swift
//  equal sounds
//
//  Created by Gray, John Walker on 12/13/20.
//
//

import Foundation
import CoreData


extension EqualizerSavedConfiguration {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EqualizerSavedConfiguration> {
        return NSFetchRequest<EqualizerSavedConfiguration>(entityName: "EqualizerSavedConfiguration")
    }

    @NSManaged public var name: String?
    @NSManaged public var frequencySettings: NSSet?

}

// MARK: Generated accessors for frequencySettings
extension EqualizerSavedConfiguration {

    @objc(addFrequencySettingsObject:)
    @NSManaged public func addToFrequencySettings(_ value: FrequencySetting)

    @objc(removeFrequencySettingsObject:)
    @NSManaged public func removeFromFrequencySettings(_ value: FrequencySetting)

    @objc(addFrequencySettings:)
    @NSManaged public func addToFrequencySettings(_ values: NSSet)

    @objc(removeFrequencySettings:)
    @NSManaged public func removeFromFrequencySettings(_ values: NSSet)

}

extension EqualizerSavedConfiguration : Identifiable {

}
