//
//  ChooseLevelViewController.swift
//  neblinaAR
//
//  Created by Negar on 2020-09-10.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit

enum LevelSceneNames : String{
    case level1 = "BOLevel1"
    case level2 = "BOLevel2"
    case level3 = "BOLevel3"
    case level4 = "BOLevel4"
    case level5 = "BOLevel5"
    case level6 = "BOLevel6"
}

class ChooseLevelViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "level1":
            let controller = segue.destination as! SensorsTableViewController
            controller.prepareStart = true
            currentLevel = LevelSceneNames.level1.rawValue
        case "level2":
            let controller = segue.destination as! SensorsTableViewController
            controller.prepareStart = true
            currentLevel = LevelSceneNames.level2.rawValue
        case "level3":
            let controller = segue.destination as! SensorsTableViewController
            controller.prepareStart = true
            currentLevel = LevelSceneNames.level3.rawValue
        case "level4":
            let controller = segue.destination as! SensorsTableViewController
            controller.prepareStart = true
            currentLevel = LevelSceneNames.level4.rawValue
        case "level5":
            let controller = segue.destination as! SensorsTableViewController
            controller.prepareStart = true
            currentLevel = LevelSceneNames.level5.rawValue
        case "level6":
            let controller = segue.destination as! SensorsTableViewController
            controller.prepareStart = true
            currentLevel = LevelSceneNames.level6.rawValue
        default:
            break
        }
    }
    

}
