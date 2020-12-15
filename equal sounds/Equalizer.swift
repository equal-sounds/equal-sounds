//
//  Equalizer.swift
//  equal sounds
//
//  Created by Gray, John Walker on 12/12/20.
//

import Foundation
import AVFoundation

class Equalizer: AVAudioUnitEQ
{
	private var currentConfiguration: EqualizerConfiguration
	var isConfigurationSaved: Bool { currentConfiguration.isSaved }
	
	override init()
	{
		currentConfiguration = EqualizerConfiguration()
		// 10 band EQ - hardcoded
		super.init(numberOfBands: 10)
		let frequencies = EqualizerBand.allCases.map { $0.rawValue }
		for i in bands.indices
		{
			bands[i].bypass = false
			bands[i].frequency = Float(frequencies[i])
			bands[i].filterType = .parametric
		}
	}
	
	init(using configuration: EqualizerConfiguration)
	{
		currentConfiguration = configuration
		print("number of bands: \(configuration.numberOfBands)")
		super.init(numberOfBands: configuration.numberOfBands) //currently this should always be 10
		assert(configuration.numberOfBands == EqualizerBand.allCases.count) //verify band count - this line wouldn't be in a release bundle
		let frequencies = EqualizerBand.allCases.map { $0.rawValue }
		for i in EqualizerBand.allCases.indices
		{
			bands[i].bypass = false
			bands[i].frequency = Float(frequencies[i])
			bands[i].gain = configuration.gainArray[i]
			bands[i].filterType = .parametric
		}
	}
	
	// call in background
	func adjust(atFrequency band: EqualizerBand, to gain: Float)
	{
		self.adjust(at: Int(log(Double(band.rawValue / EqualizerBand.baseBand)) / log(2)), to: gain)
	}
	
	// call in background
	func adjust(at index: Int, to gain: Float)
	{
		let band = self.bands[index]
		band.gain = gain
		print("adjusted band \(band.frequency)Hz to gain \(band.gain)")
		if self.currentConfiguration.isSaved
		{
			print("creating new config object")
			self.currentConfiguration = EqualizerConfiguration(with: self.bands.map { $0.gain })
		}
	}
	
	func currentGain(for band: EqualizerBand) -> Float?
	{
		self.bands.first(where: { $0.frequency == Float(band.rawValue) })?.gain
	}
	
	func exportCurrentConfiguration(as name: String) -> (EqualizerSavedConfiguration, [FrequencySetting])
	{
		self.currentConfiguration = EqualizerConfiguration(named: name, with: self.bands.map { $0.gain })
		let exportedConfiguration = EqualizerConfiguration.exportForSave(using: self.currentConfiguration, as: name)
		return exportedConfiguration
	}
}

