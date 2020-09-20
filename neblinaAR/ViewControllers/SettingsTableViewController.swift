//
//  SettingsTableViewController.swift
//  neblinaAR
//
//  Created by Negar on 2020-09-17.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit


enum sliderType : Int{
    case breakoutSpeed = 0
    case paddleWidth = 1
    case breakoutSensitivity = 2
    case flappybirdSpeed = 3
    case flappybirdSensitivity = 4
}

class SettingsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        _ = self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView

        header.textLabel!.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        header.textLabel!.font = UIFont(name: "ARCADECLASSIC", size: 25)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 3
        }
        if section == 1{
            return 2
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Breakout"
        }
        if section == 1{
            return "Flappy Bird"
        }
        else{
            return ""
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsTableViewCell
        cell.textLabel!.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.textLabel!.font = UIFont(name: "ARCADECLASSIC", size: 20)
        
        if indexPath.section == 0{
            if indexPath.row == 0{
                cell.textLabel?.text = "Speed"
                cell.slider.tag = sliderType.breakoutSpeed.rawValue
                cell.slider.setValue(Float(BreakoutSettings.get().speed), animated: false)
            }
            else if indexPath.row == 1{
                cell.textLabel?.text = "Paddle  width"
                cell.slider.tag = sliderType.paddleWidth.rawValue
                cell.slider.setValue(Float(BreakoutSettings.get().paddleWidth), animated: false)
            }
            else if indexPath.row == 2{
                cell.textLabel?.text = "Sensitivity"
                cell.slider.tag = sliderType.breakoutSensitivity.rawValue
                cell.slider.setValue(Float(BreakoutSettings.get().sensitivity), animated: false)
            }
            
        }
        if indexPath.section == 1{
            if indexPath.row == 0{
                cell.textLabel?.text = "Speed"
                cell.slider.tag = sliderType.flappybirdSpeed.rawValue
                cell.slider.setValue(Float(FlappyBirdSettings.get().speed), animated: false)
            }
            else if indexPath.row == 1{
                cell.textLabel?.text = "Sensitivity"
                cell.slider.tag = sliderType.flappybirdSensitivity.rawValue
                cell.slider.setValue(Float(FlappyBirdSettings.get().sensitivity), animated: false)
            }
        }

        return cell
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        switch sender.tag {
        //breakout speed
        case 0:
            BreakoutSettings.get().setSpeed(newSpeed: Double(sender.value))
            break
            
        //breakout width
        case 1:
            BreakoutSettings.get().setPaddleWidth(newWidth: Double(sender.value))
            break
            
        //breakout sensitivity
        case 2:
            BreakoutSettings.get().setSensitivity(newSensitivity: Double(sender.value))
            break
            
        //flappy speed
        case 3:
            FlappyBirdSettings.get().setSpeed(newSpeed: Double(sender.value))
            break
         
        //flappy sensitivity
        case 4:
            FlappyBirdSettings.get().setSensitivity(newSensitivity: Double(sender.value))
            break
            
        default:
            print("slider not found")
            break
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
