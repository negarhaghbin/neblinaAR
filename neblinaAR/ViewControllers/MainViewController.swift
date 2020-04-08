//
//  MainViewController.swift
//  neblinaAR
//
//  Created by Negar on 2020-03-14.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
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
