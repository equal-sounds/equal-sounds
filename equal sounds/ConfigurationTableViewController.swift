//
//  ConfigurationTableViewController.swift
//  equal sounds
//
//  Created by Brandon Clark on 12/14/20.
//

import UIKit
import CoreData

class ConfigurationTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var savedConfigurations = [EqualizerConfiguration]()
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var context: NSManagedObjectContext { ConfigurationTableViewController.context }
    let audioController = (UIApplication.shared.delegate as! AppDelegate).audioController
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        loadSavedConfigurations()
        tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
            if section == 0 {
                return savedConfigurations.count
            }
            return 0
    }

   

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let row = indexPath.row
        let configuration = savedConfigurations[row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConfigurationCell", for: indexPath) as! ConfigurationTableViewCell
        cell.update(with: configuration)
        // Configure the cell...

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        async {
            self.audioController.changeEqualizerConfiguration(to: self.savedConfigurations[indexPath.row])
        }
        dismiss(animated: true, completion: nil)
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
        tableView.reloadData()
    }
    
    func saveConfigurations()
    {
        do
        {
            try context.save()
        } catch {
            print("Failed to save configurations: \(error)")
        }
        tableView.reloadData()
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
        tableView.reloadData()
    }

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) 
	{
		if let eqvc = segue.destination as? EqualizerViewController
		{
			eqvc.updateSliders()
		}
	}
	
	override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
		if let eqvc = subsequentVC as? EqualizerViewController
		{
			eqvc.updateSliders()
		}
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    */

}
