//
//  ViewController.swift
//  equal sounds
//
//  Created by Brandon Clark on 11/21/20.
//

import UIKit
import CoreData


class homeScreenViewController: UIViewController
{


    @IBOutlet var configurations: [UIButton]!
    
    @IBAction func selctConfiguration(_ sender: Any)
    {
        configurations.forEach({(configurations) in
            UIView.animate(withDuration: 0.3, animations:{
                configurations.isHidden = !configurations.isHidden
                self.view.layoutIfNeeded()
            })
        })
    }
    
    @IBAction func configurationSelected(_ sender: Any)
    {
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func showEQ(_ sender: Any)
    {
        performSegue(withIdentifier: "showEqualizer", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let identifier = segue.identifier
        {
            if identifier == "showEqualizer"{
                if let equalizerVC = segue.destination as? equalizerViewController{
                    
                }
                
            }
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }


}

