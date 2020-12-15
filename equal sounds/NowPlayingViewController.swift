//
//  NowPlayingViewController.swift
//  equal sounds
//
//  Created by Brandon Clark on 12/12/20.
//

import UIKit

class NowPlayingViewController: UIViewController {
    
    
    let audioController = AudioController()
    @IBOutlet var songNameLabel: UILabel!
    @IBOutlet var artistLabel: UILabel!
    @IBOutlet var albumLabel: UILabel!
    var songOptional: Song? = nil
    
    
    override func viewDidLoad()
    {
		try? self.audioController.startPlayer() //demo and testing only
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func playpause(_ sender: UIButton)
    {
        // playpause
        async
        {
            self.audioController.playPausePlayer()
        }
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
