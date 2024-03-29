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

    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        _ = self.navigationController?.popViewController(animated: true)
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
