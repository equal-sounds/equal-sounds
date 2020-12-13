//
//  Player.swift
//  equal sounds
//
//  Created by Gray, John Walker on 12/12/20.
//

import Foundation
import AVFoundation

class Player: AVAudioPlayerNode
{
	private var timer: Timer?
	private var audioFile: AVAudioFile?
	{
		didSet
		{
			self.format = audioFile?.processingFormat
			self.duration = audioFile?.duration ?? 0
			self.isPlayable = audioFile != nil
		}
	}
	var format: AVAudioFormat?
	var duration: TimeInterval
	var currentPlayTime: TimeInterval
	var canBeResumed: Bool
	var isPlayable: Bool
	
	override init()
	{
		duration = 0
		currentPlayTime = 0
		timer = nil
		audioFile = nil
		canBeResumed = false
		isPlayable = false
		super.init()
	}
	
	private func startTimer()
	{
		if timer == nil
		{
			timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true)
			{ _ in
				self.currentPlayTime += 1.0
			}
		}
	}
	
	private func stopTimer()
	{
		if timer != nil
		{
			timer?.invalidate()
			timer = nil
		}
	}
	
	func openFile(at url: URL)// -> Bool
	{
		if url.path == ""
		{
			return //false
		}
		do
		{
			if let fileDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
			{
				let fileUrl = fileDirectory.appendingPathComponent(url.path)
				print(fileUrl.path)
				print("loading song")
				try audioFile = AVAudioFile(forReading: fileUrl)
				print("loaded song")
			} else {
				print("oof documents directory no find")
				return //false
			}
		} catch {
			print("an exception occured during audio file initialization")
			return //false
		}
		self.scheduleFile(audioFile!, at: nil, completionHandler: nil)
		//return true
	}
	
	override func play()
	{
	    play(at: nil)
	}
	
	override func play(at when: AVAudioTime?)
	{
		super.play(at: when)
		currentPlayTime = AVAudioTime.seconds(forHostTime: when?.hostTime ?? 0)
		startTimer()
		canBeResumed = true
	}
	
	func play(file url: URL)
	{
		play(file: url, at: nil)
	}
	
	func play(file url: URL, at when: AVAudioTime?)
	{
		stop()
		openFile(at: url)
		play(at: when)
	}
	
	func resume()
	{
		resume(at: nil)
	}
	
	func resume(at when: AVAudioTime?)
	{
		if canBeResumed
		{
			super.play(at: when)
			startTimer()
		}
	}
	
	override func pause()
	{
		super.pause()
		stopTimer()
	}
	
	override func stop()
	{
		super.stop()
		self.reset()
		stopTimer()
		currentPlayTime = 0.0
		canBeResumed = false
	}
	
	func fastForward()
	{
		if canBeResumed
		{
			pause()
			currentPlayTime = (currentPlayTime + 10 > duration) ? duration : (currentPlayTime + 10)
			resume(at: AVAudioTime(hostTime: AVAudioTime.hostTime(forSeconds: currentPlayTime)))
		} else if isPlayable {
			currentPlayTime = 10
			play(at: AVAudioTime(hostTime: AVAudioTime.hostTime(forSeconds: currentPlayTime)))
		}
	}
	
	func rewind()
	{
		if canBeResumed
		{
			pause()
			currentPlayTime = (currentPlayTime - 10 < 0) ? 0 : (currentPlayTime - 10)
			resume(at: AVAudioTime(hostTime: AVAudioTime.hostTime(forSeconds: currentPlayTime)))
		} else if isPlayable {
			play()
		}
	}
}

extension AVAudioFile
{
	var duration: TimeInterval
	{
		Double(Double(length) / processingFormat.sampleRate)
	}
}
