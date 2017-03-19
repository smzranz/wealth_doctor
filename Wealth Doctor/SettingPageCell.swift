//
//  SettingPageCell.swift
//  Wealth Doctor
//
//  Created by Shamshir Anees on 26/02/17.
//  Copyright © 2017 indianmoney.com. All rights reserved.
//

import UIKit

class SettingPageCell: UITableViewCell {
    
    
    @IBOutlet var settingsSwich: UISwitch!
    @IBOutlet var settingsIcon: UIImageView!
    
    @IBOutlet var settingsLabel: UILabel!
    
    @IBOutlet var languageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
