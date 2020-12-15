//
//  EqualizerConfiguration.swift
//  equal sounds
//
//  Created by Gray, John Walker on 12/12/20.
//

import UIKit
import CoreData

struct EqualizerConfiguration
{
	static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	var context: NSManagedObjectContext { EqualizerViewController.context }
	//immutable - when settings on saved config is modified, a new object is made immediatly to allow the UI to update to "Unsaved", but no new configuration objects are made after that until a request to save
	let name: String
	let frequencies: [EqualizerBand:Float]
	let gainArray: [Float]
	private var saved: Bool = false
	var isSaved: Bool { saved }
	var numberOfBands: Int { gainArray.count }
	/*
		Some ideas for expansion (probably not something for project submission) -
			active: Bool - mark the active saved configuration (if any) so that it can be loaded automatically on launch
			preset: Bool - mark a saved configuration as a preset, to make it un-deletable. If we were to launch app and wanted to include some EQ presets, we would want something like this
	*/
	
	//MARK:- Initialization Helpers
	
	static func gainArrayInitializer(using array: [Float]) -> [Float]
	{
		var gainValueArray = array
		if gainValueArray.count < EqualizerBand.allCases.count
		{
			let numMissing = EqualizerBand.allCases.count - array.count
			gainValueArray.append(contentsOf: Array.init(repeating: 0, count: numMissing))
		}
		return gainValueArray
	}
	
	static func gainArrayInitializer(using frequencyDict: [EqualizerBand:Float]) -> [Float]
	{
		return gainArrayInitializer(using: frequencyDict.map {$0.value})
	}
	
	static func frequencyDictionaryInitializer(using gainArray: [Float]) -> [EqualizerBand:Float]
	{
		var frequencyDictionary: [EqualizerBand:Float] = [:]
		for i in 0..<EqualizerBand.allCases.count
		{
			let frequency = EqualizerBand.allCases[i]
			let gain = gainArray[i]
			frequencyDictionary[frequency] = gain
		}
		return frequencyDictionary
	}
	
	static func frequencyDictionaryInitializer(using frequencyDict: [EqualizerBand:Float]) -> [EqualizerBand:Float]
	{
		var frequenciesToInit = frequencyDict
		if frequenciesToInit.count < EqualizerBand.allCases.count
		{
			for band in EqualizerBand.allCases
			{
				if frequenciesToInit[band] == nil
				{
					frequenciesToInit[band] = 0
				}
			}
		}
		return Dictionary(uniqueKeysWithValues: frequenciesToInit.sorted(by: {$0.value < $1.value}))
	}
	
	//MARK:- Initializers
	
	init()
	{
		self.name = "Flat"
		self.gainArray = EqualizerConfiguration.gainArrayInitializer(using: Array.init(repeating: 0, count: 10))
		self.frequencies = EqualizerConfiguration.frequencyDictionaryInitializer(using: gainArray)
		self.saved = true
	}
	
	init(with gainValuesOf: [Float])
	{
		self.name = "Unsaved"
		self.gainArray = EqualizerConfiguration.gainArrayInitializer(using: gainValuesOf)
		self.frequencies = EqualizerConfiguration.frequencyDictionaryInitializer(using: gainArray)
	}
	
	init(with frequenciesAt: [EqualizerBand:Float])
	{
		self.name = "Unsaved"
		self.frequencies = EqualizerConfiguration.frequencyDictionaryInitializer(using: frequenciesAt)
		self.gainArray = EqualizerConfiguration.gainArrayInitializer(using: frequencies.map{$0.value})
	}
	
	//I dont know what the point of this one is, to be honest
	init(from configuration: EqualizerConfiguration)
	{
		self.name = configuration.name
		self.frequencies = configuration.frequencies
		self.gainArray = configuration.gainArray
		self.saved = configuration.saved
	}
	
	init(named name: String, with gainValuesOf: [Float])
	{
		self.name = name
		self.gainArray = EqualizerConfiguration.gainArrayInitializer(using: gainValuesOf)
		self.frequencies = EqualizerConfiguration.frequencyDictionaryInitializer(using: gainArray)
		self.saved = true
	}
	
	init(named name: String, with frequenciesAt: [EqualizerBand:Float])
	{
		self.name = name
		self.frequencies = EqualizerConfiguration.frequencyDictionaryInitializer(using: frequenciesAt)
		self.gainArray = EqualizerConfiguration.gainArrayInitializer(using: frequencies)
		self.saved = true
	}
	
	init(from configuration: EqualizerConfiguration, as name: String)
	{
		self.name = name
		self.frequencies = configuration.frequencies
		self.gainArray = configuration.gainArray
		self.saved = true
	}
	
	//MARK:- Save Utilities
	
	static func exportForSave(using configuration: EqualizerConfiguration, as name: String) -> (EqualizerSavedConfiguration, [FrequencySetting])
	{
		var entity = NSEntityDescription.entity(forEntityName: "EqualizerSavedConfiguration", in: context)!
		let equalizerSavedConfiguration = EqualizerSavedConfiguration(entity: entity, insertInto: context)
		var frequencySettings: [FrequencySetting] = []
		equalizerSavedConfiguration.name = name
		for (band,gain) in configuration.frequencies
		{
			entity = NSEntityDescription.entity(forEntityName: "FrequencySetting", in: context)!
			let frequencySetting = FrequencySetting(entity: entity, insertInto: context)
			//frequencySetting.configuration = equalizerSavedConfiguration   //this seems like it wont be needed, will see when tested
			frequencySetting.frequency = band.rawValue
			frequencySetting.gain = gain
			frequencySettings.append(frequencySetting)
		}
		return (equalizerSavedConfiguration, frequencySettings)
	}
	
	static func importFromSave(using savedConfiguration: EqualizerSavedConfiguration) -> EqualizerConfiguration?
	{
		guard let name = savedConfiguration.name, let settings = savedConfiguration.frequencySettings?.allObjects as? [FrequencySetting] else {return nil}
		var frequencies: [EqualizerBand:Float] = [:]
		for i in settings.indices
		{
			guard let band = EqualizerBand.init(rawValue: settings[i].frequency) else {print(settings[i].frequency);return nil}
			frequencies[band] = settings[i].gain
		}
		return EqualizerConfiguration(named: name, with: frequencies)
	}
}
