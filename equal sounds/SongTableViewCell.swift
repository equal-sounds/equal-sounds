//
//  SongTableViewCell.swift
//  equal sounds
//
//  Created by Brandon Clark on 12/12/20.
//

import UIKit

class SongTableViewCell: UITableViewCell {

    
    @IBOutlet var songNameLabel: UILabel!
    @IBOutlet var artistLabel: UILabel!
	@IBOutlet var currentlyPlayingButton: UIButton!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(with song: Song)
    {
        songNameLabel.text = song.name
        artistLabel.text = song.artist ?? " "
    }

}
