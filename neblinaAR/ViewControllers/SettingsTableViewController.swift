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

enum switchTag : Int{
    case breakout = 0
    case flappybird = 1
}

enum settingsSection : Int, CaseIterable{
    case breakout = 0
    case flappyBird = 1
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
        return settingsSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == settingsSection.breakout.rawValue{
            return 4
        }
        if section == settingsSection.flappyBird.rawValue{
            return 3
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == settingsSection.breakout.rawValue{
            return "Breakout"
        }
        if section == settingsSection.flappyBird.rawValue{
            return "Flappy Bird"
        }
        else{
            return ""
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCellWithSwitch.identifier, for: indexPath) as! SettingsTableViewCellWithSwitch
            cell.textLabel!.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.textLabel!.font = UIFont(name: "ARCADECLASSIC", size: 20)
//            let horizontalConstraint = NSLayoutConstraint(item: cell.textLabel!, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cell.switch, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
//            cell.textLabel?.addConstraint(horizontalConstraint)
//            cell.textLabel?.textAlignment = .center
            if indexPath.section == settingsSection.breakout.rawValue{
                if indexPath.row == 0{
                    cell.textLabel?.text = "Audio feedback"
                    cell.switch.tag = switchTag.breakout.rawValue
                    cell.switch.setOn(BreakoutSettings.get().isAudioOn, animated: false)
                }
            }
            else if indexPath.section == settingsSection.flappyBird.rawValue{
                if indexPath.row == 0{
                    cell.textLabel?.text = "Audio feedback"
                    cell.switch.tag = switchTag.flappybird.rawValue
                    cell.switch.setOn(FlappyBirdSettings.get().isAudioOn, animated: false)
                }
            }
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as! SettingsTableViewCell
            cell.textLabel!.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.textLabel!.font = UIFont(name: "ARCADECLASSIC", size: 20)
            
            if indexPath.section == settingsSection.breakout.rawValue{
                if indexPath.row == 1{
                    cell.textLabel?.text = "Speed"
                    cell.slider.tag = sliderType.breakoutSpeed.rawValue
                    cell.slider.setValue(Float(BreakoutSettings.get().speed), animated: false)
                }
                else if indexPath.row == 2{
                    cell.textLabel?.text = "Paddle  width"
                    cell.slider.tag = sliderType.paddleWidth.rawValue
                    cell.slider.setValue(Float(BreakoutSettings.get().paddleWidth), animated: false)
                }
                else if indexPath.row == 3{
                    cell.textLabel?.text = "Sensitivity"
                    cell.slider.tag = sliderType.breakoutSensitivity.rawValue
                    cell.slider.setValue(Float(BreakoutSettings.get().sensitivity), animated: false)
                }
                    
            }
            if indexPath.section == settingsSection.flappyBird.rawValue{
                if indexPath.row == 1{
                    cell.textLabel?.text = "Speed"
                    cell.slider.tag = sliderType.flappybirdSpeed.rawValue
                    cell.slider.setValue(Float(FlappyBirdSettings.get().speed), animated: false)
                }
                else if indexPath.row == 2{
                    cell.textLabel?.text = "Sensitivity"
                    cell.slider.tag = sliderType.flappybirdSensitivity.rawValue
                    cell.slider.setValue(Float(FlappyBirdSettings.get().sensitivity), animated: false)
                }
            }
            return cell
        }
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        switch sender.tag {
        case switchTag.breakout.rawValue:
            BreakoutSettings.get().setAudioFeedback(newValue: sender.isOn)
            break
            
        case switchTag.flappybird.rawValue:
            FlappyBirdSettings.get().setAudioFeedback(newValue: sender.isOn)
            break
            
        default:
            break
        }
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        switch sender.tag {
        case sliderType.breakoutSpeed.rawValue:
            BreakoutSettings.get().setSpeed(newSpeed: Double(sender.value))
            break
            
        case sliderType.paddleWidth.rawValue:
            BreakoutSettings.get().setPaddleWidth(newWidth: Double(sender.value))
            break
            
        case sliderType.breakoutSensitivity.rawValue:
            BreakoutSettings.get().setSensitivity(newSensitivity: Double(sender.value))
            break
            
        case sliderType.flappybirdSpeed.rawValue:
            FlappyBirdSettings.get().setSpeed(newSpeed: Double(sender.value))
            break
         
        case sliderType.flappybirdSensitivity.rawValue:
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
