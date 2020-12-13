//
//  nowPlayingViewController.swift
//  equal sounds
//
//  Created by Brandon Clark on 12/12/20.
//

import UIKit

class nowPlayingViewController: UIViewController {
    
    
    let equalizerController = EqualizerController()
    @IBOutlet var songNameLabel: UILabel!
    @IBOutlet var artistLabel: UILabel!
    @IBOutlet var albumLabel: UILabel!
    var songOptional: Song? = nil
    
    
    override func viewDidLoad()
    {
        
        if let eq = self.equalizerController
        {
            try? eq.startPlayer()
        }
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func playpause(_ sender: UIButton)
    {
        // play
        if let eq = self.equalizerController
        {
            try? eq.startPlayer()
        }
        // pause
        async
        {
            self.equalizerController?.stopPlayer()
        }
    }
    
    @IBAction func fastForwardButton(_ sender: Any)
    {
    }
    @IBAction func rewindButton(_ sender: Any)
    {
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
