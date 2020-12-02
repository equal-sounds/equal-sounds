//
//  EqualizerViewController.swift
//  equal sounds
//
//  Created by Brandon Clark on 12/1/20.
//

import UIKit

class EqualizerViewController: UIViewController
{

    @IBOutlet var thirtyOneHZSlider: UISlider!
    @IBOutlet var sixtyTwoHZSlider: UISlider!
    @IBOutlet var OneTwentyFiveHZSlider: UISlider!
    @IBOutlet var twoFiftyHZSlider: UISlider!
    @IBOutlet var fiveHundredHZSlider: UISlider!
    @IBOutlet var oneKHZSlider: UISlider!
    @IBOutlet var twoKHZSlider: UISlider!
    @IBOutlet var fourKHZSlider: UISlider!
    @IBOutlet var eightKHZSlider: UISlider!
    @IBOutlet var sixteenKHZSlider: UISlider!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //rotating all the sliders to be vertical
        thirtyOneHZSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        sixtyTwoHZSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        OneTwentyFiveHZSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        twoFiftyHZSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        fiveHundredHZSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        oneKHZSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        twoKHZSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        fourKHZSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        eightKHZSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        sixteenKHZSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    

}
