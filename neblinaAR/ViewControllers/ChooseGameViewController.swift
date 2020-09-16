//
//  ChooseGameViewController.swift
//  neblinaAR
//
//  Created by Negar on 2020-09-10.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit

enum Game{
    case flappyBird
    case breakOut
}

var currentGame = Game.breakOut
class ChooseGameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "breakOut":
            currentGame = Game.breakOut
        case "flappyBird":
            currentGame = Game.flappyBird
            let controller = segue.destination as! SensorsTableViewController
            controller.prepareStart = true
        default:
            print("unknown game")
            break
        }
    }

}
