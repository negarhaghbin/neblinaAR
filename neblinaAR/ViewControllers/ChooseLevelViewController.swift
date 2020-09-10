//
//  ChooseLevelViewController.swift
//  neblinaAR
//
//  Created by Negar on 2020-09-10.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit

class ChooseLevelViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! SensorsTableViewController
        if segue.identifier == "showStart" {
            controller.prepareStart = true
        }
    }
    

}
