//
//  EqualizerBand.swift
//  equal sounds
//
//  Created by Gray, John Walker on 12/2/20.
//

import Foundation

enum EqualizerBand: Float, CaseIterable
{
    case thirtyOneHz = 31
    case sixtyTwoHz = 62
    case oneTwentyFiveHz = 125
    case twoFiftyHz = 250
    case fiveHundredHz = 500
    case oneKHz = 1000
    case twoKHz = 2000
    case fourKHz = 4000
    case eightKHz = 8000
    case sixteenKHz = 16000
}

extension EqualizerBand
{
	static let baseBand: Float = EqualizerBand.allCases.first?.rawValue ?? 0
}

