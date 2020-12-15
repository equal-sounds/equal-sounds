//
//  SongTableViewController.swift
//  equal sounds
//
//  Created by Brandon Clark on 12/12/20.
//

import UIKit

class SongTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var songs = [Song]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if section == 0 {
                return songs.count
            }
            return 0
        }

   

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let song = songs[row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongTableViewCell
        cell.update(with: song)
        // Configure the cell...

        return cell
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
