//
//  EqualizerController.swift
//  equal sounds
//
//  Created by Gray, John Walker on 12/1/20.
//

import Foundation
import AVFoundation


class EqualizerController
{
    let engine = AVAudioEngine()
    let playerNode = AVAudioPlayerNode()
    let equalizer: AVAudioUnitEQ!
    let audioFile: AVAudioFile!
    
    init?()
    {
        print("help")
        do
        {
            if let fileDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            {
                let filePath = fileDirectory.appendingPathComponent("song").appendingPathExtension("mp3").path
                let fileUrl = URL(fileURLWithPath: filePath)
                print(fileUrl.path)
                print("loading song")
                try audioFile = AVAudioFile(forReading: fileUrl)
                print("loaded song")
            } else {
                print("oof")
                return nil
            }
        } catch {
            print("an exception occured during eq initialization")
            return nil
        }
        equalizer = AVAudioUnitEQ(numberOfBands: 10)
        engine.attach(equalizer)
        engine.attach(playerNode)
        engine.connect(playerNode, to: equalizer, format: audioFile.processingFormat)
        engine.connect(equalizer, to: engine.outputNode, format: nil)
        let equalizerBands = equalizer.bands
        let frequencies = EqualizerBand.allCases.map { $0.rawValue }
        for i in 0 ..< equalizerBands.count
        {
            equalizerBands[i].bypass = false
            equalizerBands[i].frequency = Float(frequencies[i])
            equalizerBands[i].filterType = .parametric
        }
    }
    
    //call in background
    func startPlayer() throws
    {
        engine.prepare()
        try engine.start()
        playerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        playerNode.play()
        print("started player")
    }
    
    //call in background
    func pausePlayer()
    {
        self.playerNode.pause()
        self.engine.pause()
    }
    
    //call in background
    func resumePlayer() throws
    {
        try self.engine.start()
        self.playerNode.play()
    }
    
    //call in background
    func stopPlayer()
    {
        self.playerNode.stop()
        self.engine.stop()
        print("stopped player")
    }
    
    // call in background
    func adjustEqualizer(atFrequency band: EqualizerBand, to gain: Float)
    {
        adjustEqualizer(at: Int(log(Double(band.rawValue / EqualizerBand.baseBand)) / log(2)), to: gain)
    }
    
    // call in background
    func adjustEqualizer(at index: Int, to gain: Float)
    {
        let band = self.equalizer.bands[index]
        band.gain = gain
        print("adjusted band \(band.frequency)Hz to gain \(band.gain)")
    }
}
