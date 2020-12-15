//
//  NowPlayingViewController.swift
//  equal sounds
//
//  Created by Brandon Clark on 12/12/20.
//

import UIKit

class NowPlayingViewController: UIViewController {
    
    let audioController = (UIApplication.shared.delegate as! AppDelegate).audioController
    @IBOutlet var songNameLabel: UILabel!
    @IBOutlet var artistLabel: UILabel!
    @IBOutlet var albumLabel: UILabel!
	@IBOutlet var albumImageView: UIImageView!
	@IBOutlet var progressSlider: UISlider!
	@IBOutlet var currentTimeLabel: UILabel!
	@IBOutlet var trackDurationLabel: UILabel!
	var songOptional: Song? = nil
	var nowPlaying: Song?
    
    
    override func viewDidLoad()
    {
		//try? self.audioController.startPlayer() //demo and testing only
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		
    }
	 
	func formatTime(time: TimeInterval) -> String
	{
		let minutes: Int = Int(trunc(time / 60))
		let seconds: Int = Int(time.truncatingRemainder(dividingBy: 60))
		let paddedSeconds: String = seconds < 10 ? "0\(seconds)" : "\(seconds)"
		return "\(minutes):\(paddedSeconds)"
	}
	
	override func viewWillAppear(_ animated: Bool) 
	{
		guard let nowPlayingSong = audioController.getNowPlayingMetadata() else {return}
		nowPlaying = nowPlayingSong
		songNameLabel.text = nowPlayingSong.name
		artistLabel.text = nowPlayingSong.artist ?? "Unknown Artist"
		albumLabel.text = nowPlayingSong.albumName ?? "Unknown Album"
		albumImageView.image = nowPlayingSong.albumImage
		progressSlider.maximumValue = Float(nowPlayingSong.duration)
		progressSlider.value = Float(audioController.currentPlayTime)
		progressSlider.minimumValue = 0
		currentTimeLabel.text = formatTime(time: audioController.currentPlayTime)
		trackDurationLabel.text = formatTime(time: TimeInterval(nowPlayingSong.duration))
		audioController.subscribeToTimer 
		{
			self.progressSlider.value = Float(self.audioController.currentPlayTime)
			self.currentTimeLabel.text = self.formatTime(time: self.audioController.currentPlayTime)
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) 
	{
		audioController.unsubscribeFromTimer()
	}
    
    @IBAction func playpause(_ sender: UIButton)
    {
        // playpause
		self.audioController.playPausePlayer()
    }
    
    @IBAction func fastForwardButton(_ sender: Any)
    {
        audioController.fastForwardPlayer()
    }
	
    @IBAction func rewindButton(_ sender: Any)
    {
        audioController.rewindPlayer()
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
