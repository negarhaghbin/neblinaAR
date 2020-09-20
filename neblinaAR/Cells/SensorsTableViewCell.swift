//
//  SensorsTableViewCell.swift
//  neblinaAR
//
//  Created by Negar on 2020-04-07.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit

class SensorsTableViewCell: UITableViewCell {

    @IBOutlet weak var selectSwitch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
