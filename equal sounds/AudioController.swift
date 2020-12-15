//
//  AudioController.swift
//  equal sounds
//
//  Created by Gray, John Walker on 12/1/20.
//

import Foundation
import AVFoundation //uncertain if both are needed or just AVFoundation works -- leaning towards both but still interested in actual answer


class AudioController
{
    let engine = AVAudioEngine()
	let player: Player
    let equalizer: Equalizer
	var headphonesConnected: Bool = false
	var isPrepared: Bool = false
	
	var isPlaying: Bool { player.isPlaying }
	var currentPlayTime: TimeInterval { player.currentPlayTime }
    
    init()
    {
        print("help")
        player = Player()
        equalizer = Equalizer()
		engine.attach(player)
        engine.attach(equalizer)
        engine.connect(player, to: equalizer, format: player.format)
		engine.connect(equalizer, to: engine.outputNode, format: nil)
		headphonesConnected = hasHeadphones(in: AVAudioSession.sharedInstance().currentRoute)
		setupNotifications()
    }
	
	func subscribeToTimer(closure: @escaping ()->())
	{
		player.subscribeToTimer(closure: closure)
	}
	
	func unsubscribeFromTimer()
	{
		player.unsubscribeFromTimer()
	}
	
	//MARK:- Player Management
	
	func playPausePlayer()
	{
		if player.isPlaying
		{
			pausePlayer()
		} else {
			if player.isPlayable
			{
				do
				{
					if isPrepared
					{
						try resumePlayer()
					} else {
						try startPlayer()
					}
				} catch {
					print("failed in attempt to start or resume player")
				}
			} else {
				print("player is not playable (no audio file is nil)")
			}
		}
	}
    
    //call in background
    func startPlayer() throws
    {
		self.engine.prepare()
		self.isPrepared = true
		try self.engine.start()
		self.player.play()
		if self.player.isPlaying
		{
			print("started player")
		} else {
			self.stopPlayer()
		}
    }
	
	//call in background
	func startPlayer(using file: AVAudioFile) throws
	{
		self.engine.prepare()
		self.isPrepared = true
		try self.engine.start()
		self.player.play(file: file)
		if self.player.isPlaying
		{
			print("started player")
		} else {
			print("failed to start player")
			self.stopPlayer()
		}
	}
	
	//call in background
	func preparePlayer(for fileUrl: URL)
	{
		self.player.openFile(at: fileUrl)
	}
    
    //call in background
    func pausePlayer()
    {
        self.player.pause()
        self.engine.pause()
    }
    
    //call in background
    func resumePlayer() throws
    {
        try self.engine.start()
        self.player.resume()
    }
    
    //call in background
    func stopPlayer()
    {
        self.player.stop()
        self.engine.stop()
		isPrepared = false
        print("stopped player")
    }
	
	// call in background
	func fastForwardPlayer()
	{
		player.fastForward()
	}
	
	// call in background
	func rewindPlayer()
	{
		player.rewind()
	}
    
	//MARK: -Equalizer Management
	
    // call in background
    func adjustEqualizer(atFrequency band: EqualizerBand, to gain: Float)
    {
		self.equalizer.adjust(atFrequency: band, to: gain)
    }
	
	//should be able to call in background
	func toggleEqualizer(enable: Bool)
	{
		if enable //switch toggle on/off state
		{
			engine.connect(player, to: equalizer, format: player.format)
			engine.connect(equalizer, to: engine.outputNode, format: nil)
			engine.disconnectNodeInput(engine.mainMixerNode) //may need to disconnect first
			engine.disconnectNodeOutput(engine.mainMixerNode)
		} else {
			engine.connect(player, to: engine.mainMixerNode, format: player.format)
			engine.connect(engine.mainMixerNode, to: engine.outputNode, format: nil)
			engine.disconnectNodeInput(equalizer) //may need to disconnect first
			engine.disconnectNodeOutput(equalizer)
		}
	}
	
    // call in background
    func adjustEqualizer(at index: Int, to gain: Float)
    {
		self.equalizer.adjust(at: index, to: gain)
    }
	
	func changeEqualizerConfiguration(to configuration: EqualizerConfiguration)
	{
		print("Hi! I am a stub and need to be completed [changeEqualizerConfiguration(to:)]")
	}
	
	//MARK:- Metadata Operations
	
	func exportEqualizerConfiguration(as name: String) -> (EqualizerSavedConfiguration, [FrequencySetting])
	{
		self.equalizer.exportCurrentConfiguration(as: name)
	}
	
	func getNowPlayingMetadata() -> Song?
	{
		guard let nowPlaying = player.nowPlaying else {return nil}
		return SongFileManager().fetchSongMetadata(for: nowPlaying.url)
	}
	
	//MARK:- System Event Handling
	func setupNotifications()
	{
		let notificationCenter = NotificationCenter.default
		// may need to use a different interuption name depending on what type of sounds this causes interuptions for
		notificationCenter.addObserver(self, selector: #selector(handleInteruption), name: AVAudioSession.interruptionNotification, object: nil)
		notificationCenter.addObserver(self, selector: #selector(handleRouteChange), name: AVAudioSession.routeChangeNotification, object: nil)
	}
	
	@objc func handleInteruption(notification: Notification)
	{
		guard let userInfo = notification.userInfo, let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt, let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {return}
		switch type
		{
			case .began:
				pausePlayer()
			case .ended:
				guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else {return}
				let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
				if options.contains(.shouldResume)
				{
					try? resumePlayer()
				}
			default: () //do nothing
		}
	}
	
	@objc func handleRouteChange(notification: Notification)
	{
		let previousVolume = player.volume
		player.volume = 0
		guard let userInfo = notification.userInfo, let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt, let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else {return}
		switch reason
		{
			case .newDeviceAvailable:
				headphonesConnected = hasHeadphones(in: AVAudioSession.sharedInstance().currentRoute)
			case .oldDeviceUnavailable:
				if let previousRoute = userInfo[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription
				{
					headphonesConnected = hasHeadphones(in: AVAudioSession.sharedInstance().currentRoute)
					if !headphonesConnected && hasHeadphones(in: previousRoute)
					{
						pausePlayer()
					}
				}
			default: () //do nothing
		}
		player.volume = previousVolume
	}
	
	func hasHeadphones(in routeDescription: AVAudioSessionRouteDescription) -> Bool
	{
		return !routeDescription.outputs.filter({$0.portType == .headphones}).isEmpty
	}
}
