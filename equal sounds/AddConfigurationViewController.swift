//
//  AddConfigurationViewController.swift
//  equal sounds
//
//  Created by Brandon Clark on 12/14/20.
//

import UIKit
import CoreData

class AddConfigurationViewController: UIViewController {
	let audioController = (UIApplication.shared.delegate as! AppDelegate).audioController
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var context: NSManagedObjectContext { AddConfigurationViewController.context }
    @IBOutlet var addConfigurationNameTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func saveEqConfiguration(as name: String)
    {
        print("save eq")
        let (savedConfiguration, settings) = audioController.exportEqualizerConfiguration(as: name)
        context.insert(savedConfiguration)
        savedConfiguration.addToFrequencySettings(NSSet(array: settings))
        saveConfigurations()
    }
    
    func saveConfigurations()
    {
        do
        {
            try context.save()
        } catch {
            print("Failed to save configurations: \(error)")
        }
    }
    
    @IBAction func saveConfigurationButton(_ sender: UIButton)
    {
        print("Should perform")
        if addConfigurationNameTextField.text != nil && addConfigurationNameTextField.text != ""{
            saveEqConfiguration(as: addConfigurationNameTextField.text!)
			dismiss(animated: true, completion: nil)
        }
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
