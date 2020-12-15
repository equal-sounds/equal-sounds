//
//  ConfigurationTableViewCell.swift
//  equal sounds
//
//  Created by Brandon Clark on 12/14/20.
//

import UIKit

class ConfigurationTableViewCell: UITableViewCell {

    @IBOutlet var configurationNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update(with configuration: EqualizerConfiguration)
    {
        configurationNameLabel.text = configuration.name
    }

}
