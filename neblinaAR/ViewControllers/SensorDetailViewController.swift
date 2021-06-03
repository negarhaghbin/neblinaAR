//
//  SensoreDetailViewController.swift
//  neblinaAR
//
//  Created by Negar on 2020-04-03.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit
import CoreBluetooth
import QuartzCore
import SceneKit

class SensorDetailViewController: UITableViewController {
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - Helpers
    func getCmdIdx(_ subsysId : Int32, cmdId : Int32) -> Int {
        for (idx, item) in NebCmdList.enumerated() {
            if (item.SubSysId == subsysId && item.CmdId == cmdId) {
                return idx
            }
        }
        return -1
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
        
    override var prefersStatusBarHidden : Bool {
        return true
    }
        
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
        
    func updateUI(status : NeblinaSystemStatus_t) {
        for idx in 0...NebCmdList.count - 1 {
            switch (NebCmdList[idx].SubSysId) {
            case NEBLINA_SUBSYSTEM_GENERAL:
                switch (NebCmdList[idx].CmdId) {
                case NEBLINA_COMMAND_GENERAL_INTERFACE_STATE:
                    let cell = tableView.cellForRow( at: IndexPath(row: idx, section: 0))
                    if cell != nil {
                        let control = cell?.viewWithTag(1) as! UISegmentedControl

                        if NebCmdList[idx].ActiveStatus & UInt32(status.interface) == 0 {
                            control.selectedSegmentIndex = 0
                        }
                        else {
                            control.selectedSegmentIndex = 1
                        }
                    }
                default:
                    break
                }
                
            case NEBLINA_SUBSYSTEM_FUSION:
                let cell = tableView.cellForRow( at: IndexPath(row: idx, section: 0))
                if cell != nil {
                    let control = cell?.viewWithTag(1) as! UISegmentedControl
                    if NebCmdList[idx].ActiveStatus & status.fusion == 0 {
                        control.selectedSegmentIndex = 0
                    }
                    else {
                        control.selectedSegmentIndex = 1
                    }
                }
                
            case NEBLINA_SUBSYSTEM_SENSOR:
                let cell = tableView.cellForRow( at: IndexPath(row: idx, section: 0))
                if cell != nil {
                    let control = cell?.viewWithTag(1) as! UISegmentedControl
                    if NebCmdList[idx].CmdId == NEBLINA_COMMAND_SENSOR_ACCELEROMETER_GYROSCOPE_STREAM {
                        if NebCmdList[idx].ActiveStatus == UInt32(NEBLINA_SENSOR_STATUS_ACCELEROMETER_GYROSCOPE.rawValue) {
                                print("Accel_Gyro button \(status.sensor) ")
                            }
                        }
                        if (NebCmdList[idx].ActiveStatus & UInt32(status.sensor)) == 0 {
                            control.selectedSegmentIndex = 0
                        }
                        else {
                            control.selectedSegmentIndex = 1
                        }
                    }

            default:
                break
            }
        }
    }

    // MARK: - UITableView
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NebCmdList.count
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellView = tableView.dequeueReusableCell(withIdentifier: "CellCommand", for: indexPath)
        let labelView = cellView.viewWithTag(255) as! UILabel
        if ((indexPath as NSIndexPath).row < NebCmdList.count) {
            labelView.text = NebCmdList[(indexPath as NSIndexPath).row].Name
            switch (NebCmdList[(indexPath as NSIndexPath).row].Actuator){
                case ACTUATOR_TYPE_SWITCH:
                    let control = cellView.viewWithTag(NebCmdList[indexPath.row].Actuator) as! UISegmentedControl
                    control.isHidden = false
                    let b = cellView.viewWithTag(2) as! UIButton
                    b.isHidden = true
                    let t = cellView.viewWithTag(3) as! UITextField
                    t.isHidden = true
                    break
                    
                case ACTUATOR_TYPE_BUTTON:
                    let control = cellView.viewWithTag(NebCmdList[(indexPath as NSIndexPath).row].Actuator) as! UIButton
                    control.isHidden = false
                    if !NebCmdList[(indexPath as NSIndexPath).row].Text.isEmpty{
                        control.setTitle(NebCmdList[(indexPath as NSIndexPath).row].Text, for: UIControl.State())
                    }
                    let s = cellView.viewWithTag(1) as! UISegmentedControl
                    s.isHidden = true
                    let t = cellView.viewWithTag(3) as! UITextField
                    t.isHidden = true
                    break
                    
                case ACTUATOR_TYPE_TEXT_FIELD:
                    let control = cellView.viewWithTag(NebCmdList[(indexPath as NSIndexPath).row].Actuator) as! UITextField
                    control.isHidden = false
                    if !NebCmdList[(indexPath as NSIndexPath).row].Text.isEmpty{
                        control.text = NebCmdList[(indexPath as NSIndexPath).row].Text
                    }
                    let s = cellView.viewWithTag(1) as! UISegmentedControl
                    s.isHidden = true
                    let b = cellView.viewWithTag(2) as! UIButton
                    b.isHidden = true
                    break
                    
                case ACTUATOR_TYPE_TEXT_FIELD_BUTTON:
                    let tfcontrol = cellView.viewWithTag(4) as! UITextField
                    tfcontrol.isHidden = false
                    let bucontrol = cellView.viewWithTag(2) as! UIButton
                    bucontrol.isHidden = false
                    if !NebCmdList[(indexPath as NSIndexPath).row].Text.isEmpty{
                        bucontrol.setTitle(NebCmdList[(indexPath as NSIndexPath).row].Text, for: UIControl.State())
                    }
                    let s = cellView.viewWithTag(1) as! UISegmentedControl
                    s.isHidden = true
                    let t = cellView.viewWithTag(3) as! UITextField
                    t.isHidden = true
                    break
                    
                case ACTUATOR_TYPE_TEXT_FIELD_SWITCH:
                    let tfcontrol = cellView.viewWithTag(4) as! UITextField
                    tfcontrol.isHidden = false
                    let bucontrol = cellView.viewWithTag(1) as! UISegmentedControl
                    bucontrol.isHidden = false
                    let s = cellView.viewWithTag(2) as! UIButton
                    s.isHidden = true
                    let t = cellView.viewWithTag(3) as! UITextField
                    t.isHidden = true
                    break
                
                default:
                    break
            }
        }
        return cellView;
    }

    func tableView(_ tableView: UITableView, canEditRowAtIndexPath indexPath: IndexPath?) -> Bool{
        return false
    }
}
