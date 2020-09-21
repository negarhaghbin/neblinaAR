//
//  SettingsTableViewCellWithSwitch.swift
//  neblinaAR
//
//  Created by Negar on 2020-09-21.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit

class SettingsTableViewCellWithSwitch: UITableViewCell {
    static let identifier = "settingsCellWithSwitch"
    @IBOutlet weak var `switch`: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
