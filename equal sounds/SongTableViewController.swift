//
//  SongTableViewController.swift
//  equal sounds
//
//  Created by Brandon Clark on 12/12/20.
//

import UIKit

class SongTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var songs = [Song]()
	let audioController = (UIApplication.shared.delegate as! AppDelegate).audioController
	let songFileManager = SongFileManager()
	@IBOutlet var tableView: UITableView!
	var currentlyPlayingCell: SongTableViewCell?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		if let loadedSongs = songFileManager.loadSongFiles(in: songFileManager.urls(for: .documentDirectory, in: .userDomainMask).first!)
		{
			songs = loadedSongs
			
		}
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
	
	override func viewDidAppear(_ animated: Bool) 
	{
		if currentlyPlayingCell?.currentlyPlayingButton.isHidden ?? false
		{
			currentlyPlayingCell?.currentlyPlayingButton.isHidden = false
		}
	}

    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return songs.count
		}
		return 0
	}

   

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
		let songSelected = songs[indexPath.row]
		print("song table is trying to start player using \(songSelected.name)")
		if let songFile = songFileManager.openFile(at: songSelected.url)
		{
			if audioController.isPlaying
			{
				audioController.stopPlayer()
			}
			do
			{
				try audioController.startPlayer(using: songFile)
				currentlyPlayingCell?.currentlyPlayingButton.isHidden = true
				if let cell = tableView.cellForRow(at: indexPath) as? SongTableViewCell
				{
					cell.currentlyPlayingButton.isHidden = false
					tableView.reloadData()
					currentlyPlayingCell = cell
				}
			} catch {
				print("song table couldnt start player\n\(error)")
			}
			
		}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let song = songs[row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongTableViewCell
        cell.update(with: song)
        // Configure the cell...

        return cell
	}
	
	@IBAction func openExternalFileSelectorButtonPressed(_ sender: UIBarButtonItem) 
	{
		let documentPicker = try? songFileManager.requestDocumentPicker()
		present(documentPicker!, animated: true) 
		{ 
			guard let songFile = self.songFileManager.loadSelectedFile() else {return}
			self.audioController.stopPlayer()
			try? self.audioController.startPlayer(using: songFile)
		}
	}
	// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier
        {
            if identifier == "NowPlayingSegue"{
                if let nowPlayingVC = segue.destination as? nowPlayingViewController{
                    if let indexPath = tableView.indexPathForSelectedRow{
                        let song = songs[indexPath.row]
                        nowPlayingVC.songOptional = song
                    }
                }
                
            }
        }
    }
 */
    

}
