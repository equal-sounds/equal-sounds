//
//  EqualizerViewController.swift
//  equal sounds
//
//  Created by Brandon Clark on 12/1/20.
//

import UIKit
import CoreData //? unsure if needed

class EqualizerViewController: UIViewController
{
	static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	var context: NSManagedObjectContext { EqualizerViewController.context }
	//display eq config name somewhere on screen
    // MARK: - Frequency Level Label Array
    @IBOutlet var frequencyLevelLabelArray: [UILabel]!
    
    // MARK: - Frequency labels
    @IBOutlet var thirtyOneHzLabel: UILabel!
    @IBOutlet var sixtyTwoHzLabel: UILabel!
    @IBOutlet var oneTwentyFiveHzLabel: UILabel!
    @IBOutlet var twoFifityHzLabel: UILabel!
    @IBOutlet var fiveHundredHzLabel: UILabel!
    @IBOutlet var oneKHzLabel: UILabel!
    @IBOutlet var twoKHzLabel: UILabel!
    @IBOutlet var fourKHzLabel: UILabel!
    @IBOutlet var eightKHzLabel: UILabel!
    @IBOutlet var sixteenKHzLabel: UILabel!
    // MARK: - Frequency level labels
    @IBOutlet var thirtyOneHzLevelLabel: UILabel!
    @IBOutlet var sixtyTwoHzLevelLabel: UILabel!
    @IBOutlet var oneTwentyFiveHzLevelLabel: UILabel!
    @IBOutlet var twoFiftyHzLevelLabel: UILabel!
    @IBOutlet var fiveHundredHzLevelLabel: UILabel!
    @IBOutlet var oneKHzLevelLabel: UILabel!
    @IBOutlet var twoKHzLevelLabel: UILabel!
    @IBOutlet var fourKHzLevelLabel: UILabel!
    @IBOutlet var eightKHzLevelLabel: UILabel!
    @IBOutlet var sixteenKHzLevelLabel: UILabel!
    // MARK: -Frequency Sliders
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
	var savedConfigurations: [EqualizerConfiguration]! //loaded using CoreData in load function
    let audioController = (UIApplication.shared.delegate as! AppDelegate).audioController // fetch singleton AudioController instance
	// The config selector should probably be on the same screen as the EQ sliders, so that you can see changes. I don't know if we will get to the visual rendering of the audio graph, we will need to look into how to do it. I know there are resources, stackoverflows, etc. out there on how to do that sort of thing but i dont know the time consumption of it
	
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //rotating all the sliders to be vertical
        thirtyOneHZSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        thirtyOneHZSlider.tintColor = UIColor.green
        sixtyTwoHZSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        sixtyTwoHZSlider.tintColor = UIColor.green
        OneTwentyFiveHZSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        OneTwentyFiveHZSlider.tintColor = UIColor.green
        twoFiftyHZSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        twoFiftyHZSlider.tintColor = UIColor.green
        fiveHundredHZSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        fiveHundredHZSlider.tintColor = UIColor.green
        oneKHZSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        oneKHZSlider.tintColor = UIColor.green
        twoKHZSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        twoKHZSlider.tintColor = UIColor.green
        fourKHZSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        fourKHZSlider.tintColor = UIColor.green
        eightKHZSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        eightKHZSlider.tintColor = UIColor.green
        sixteenKHZSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        sixteenKHZSlider.tintColor = UIColor.green
		savedConfigurations = []
        // Do any additional setup after loading the view.
		loadSavedConfigurations()
		/*async
        {
			// demo & testing only as far as i'm concerned - we dont need sound to start whenever the eq gets opened
			try? self.audioController.startPlayer(using: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("song").appendingPathExtension("mp3"))
        }*/
    }
	
	@IBAction func eqSliderValueChanged(_ sender: UISlider)
	{
		let tag = sender.tag
		let val = sender.value
        
        
		async
		{
			self.audioController.adjustEqualizer(at: tag, to: val)
		}
        frequencyLevelLabelArray[tag].text = "\(String(format: "%.1f",val))"
        
	}
	
	
	//MARK:- Persistant Data Management
	//if the configuration saving stuff needs to be moved to another VC thats fine by me, make sure the audio controller is passed to it so it can access and change configurations
	
	//probably will be an @IBAction, or will be called by one
	func saveEqConfiguration(as name: String)
	{
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
	
	func loadSavedConfigurations()
	{
		let request: NSFetchRequest<EqualizerSavedConfiguration> = EqualizerSavedConfiguration.fetchRequest()
		var fetchedConfigurations: [EqualizerSavedConfiguration] = []
		do {
			fetchedConfigurations = try context.fetch(request)
			for fetchedConfiguration in fetchedConfigurations
			{
				if let importedConfiguration = EqualizerConfiguration.importFromSave(using: fetchedConfiguration)
				{
					savedConfigurations.append(importedConfiguration)
				} else {
					print("eq configuration with name \"\(fetchedConfiguration.name != nil ? "\"\(fetchedConfiguration.name!)\"" : "NAME NOT FOUND")\" was successfully loaded from database but could not be imported")
				}
			}
		}
		catch {
			print("Error loading saved configurations: \(error)")
		}
	}
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    

}
