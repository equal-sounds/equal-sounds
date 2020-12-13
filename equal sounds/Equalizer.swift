//
//  Equalizer.swift
//  equal sounds
//
//  Created by Gray, John Walker on 12/12/20.
//

import AVFoundation

class Equalizer: AVAudioUnitEQ
{
	override init()
	{
		// 10 band EQ - hardcoded
		super.init(numberOfBands: 10)
		let frequencies = EqualizerBand.allCases.map { $0.rawValue }
		for i in 0 ..< bands.count
		{
			bands[i].bypass = false
			bands[i].frequency = Float(frequencies[i])
			bands[i].filterType = .parametric
		}
	}
	
	// call in background
	func adjust(atFrequency band: EqualizerBand, to gain: Float)
	{
		adjust(at: Int(log(Double(band.rawValue / EqualizerBand.baseBand)) / log(2)), to: gain)
	}
	
	// call in background
	func adjust(at index: Int, to gain: Float)
	{
		let band = self.bands[index]
		band.gain = gain
		print("adjusted band \(band.frequency)Hz to gain \(band.gain)")
	}
}

