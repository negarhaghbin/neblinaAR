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
   // @IBOutlet weak var tableView: UITableView!
   
        func getCmdIdx(_ subsysId : Int32, cmdId : Int32) -> Int {
            for (idx, item) in NebCmdList.enumerated() {
                if (item.SubSysId == subsysId && item.CmdId == cmdId) {
                    return idx
                }
            }
            
            return -1
        }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
        
        override func viewDidLoad() {
            super.viewDidLoad()
//            cnt = max_count
//            scene = sceneShip
//
//            let cameraNode = SCNNode()
//            cameraNode.camera = SCNCamera()
//
//            let cameraNode1 = SCNNode()
//            sceneShip.rootNode.addChildNode(cameraNode1)
//
//            // place the camera
//            cameraNode.position = SCNVector3(x: 0, y: 0, z:20)
//            cameraNode1.position = SCNVector3(x: 0, y: 0, z:20)
//            let lightNode = SCNNode()
//            lightNode.light = SCNLight()
//            lightNode.light!.type = SCNLight.LightType.omni
//            lightNode.position = SCNVector3(x: 0, y: 10, z: 50)
//
//            let lightNode1 = SCNNode()
//            lightNode1.light = SCNLight()
//            lightNode1.light!.type = SCNLight.LightType.omni
//            lightNode1.position = SCNVector3(x: 0, y: 10, z: 50)
//            sceneShip.rootNode.addChildNode(lightNode1)
//
//            // create and add an ambient light to the scene
//            let ambientLightNode = SCNNode()
//            ambientLightNode.light = SCNLight()
//            ambientLightNode.light!.type = SCNLight.LightType.ambient
//            ambientLightNode.light!.color = UIColor.darkGray
//
//            let ambientLightNode1 = SCNNode()
//            ambientLightNode1.light = SCNLight()
//            ambientLightNode1.light!.type = SCNLight.LightType.ambient
//            ambientLightNode1.light!.color = UIColor.darkGray
//            sceneShip.rootNode.addChildNode(ambientLightNode1)
//
//
//            ship = scene?.rootNode.childNode(withName: "ship", recursively: true)!
//
//            ship.eulerAngles = SCNVector3Make(GLKMathDegreesToRadians(90), 0, GLKMathDegreesToRadians(180))
//
//            let scnView = self.view.subviews[0] as! SCNView
//
//            // set the scene to the view
//            scnView.scene = scene
//
//            // allows the user to manipulate the camera
//            scnView.allowsCameraControl = true
//
//            // show statistics such as fps and timing information
//            scnView.showsStatistics = true
//
//            //scnView.preferredFramesPerSecond = 60
            
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
        
        @IBAction func buttonAction(_ sender:UIButton)
        {
//            let idx = tableView.indexPath(for: sender.superview!.superview as! UITableViewCell)
//            let row = (idx?.row)! as Int
//
//            if (nebdev == nil) {
//                return
//            }
//
//            if (row < NebCmdList.count) {
//                switch (NebCmdList[row].SubSysId)
//                {
//                    case NEBLINA_SUBSYSTEM_GENERAL:
//                        switch (NebCmdList[row].CmdId)
//                        {
//                            case NEBLINA_COMMAND_GENERAL_FIRMWARE_UPDATE:
//                                nebdev!.firmwareUpdate()
//                                print("DFU Command")
//                                break
//                            case NEBLINA_COMMAND_GENERAL_RESET_TIMESTAMP:
//                                nebdev!.resetTimeStamp(Delayed: true)
//                                print("Reset timestamp")
//                                break
//                            case NEBLINA_COMMAND_GENERAL_DEVICE_SHUTDOWN:
//                                nebdev!.shutdown()
//
//                                break
//                            default:
//                                break
//                        }
//                        break
//                    case NEBLINA_SUBSYSTEM_EEPROM:
//                        switch (NebCmdList[row].CmdId)
//                        {
//                            case NEBLINA_COMMAND_EEPROM_READ:
//                                nebdev!.eepromRead(0)
//                                break
//                            case NEBLINA_COMMAND_EEPROM_WRITE:
//                                    //UInt8_t eepdata[8]
//                                    //nebdev.SendCmdEepromWrite(0, eepdata)
//                                break
//                            default:
//                                break
//                        }
//                        break
//                    case NEBLINA_SUBSYSTEM_FUSION:
//                        switch (NebCmdList[row].CmdId) {
//                            case NEBLINA_COMMAND_FUSION_CALIBRATE_FORWARD_POSITION:
//                            nebdev!.calibrateForwardPosition()
//                            break
//                        case NEBLINA_COMMAND_FUSION_CALIBRATE_DOWN_POSITION:
//                            nebdev!.calibrateDownPosition()
//                            break
//                        default:
//                            break
//                        }
//                        break
//                    case NEBLINA_SUBSYSTEM_RECORDER:
//                        switch (NebCmdList[row].CmdId) {
//                            case NEBLINA_COMMAND_RECORDER_ERASE_ALL:
//                                if flashEraseProgress == false {
//                                    //print("Send Command erase")
//                                    flashEraseProgress = true;
//                                    nebdev!.eraseStorage(false)
//                                }
//                            case NEBLINA_COMMAND_RECORDER_RECORD:
//
//                                if NebCmdList[row].ActiveStatus == 0 {
//                                    nebdev?.sessionRecord(false, info: "")
//                                }
//                                else {
//                                    nebdev!.sessionRecord(true, info: "")
//                                }
//                                break
//                            case NEBLINA_COMMAND_RECORDER_SESSION_DOWNLOAD:
//                                let cell = tableView.cellForRow( at: IndexPath(row: row, section: 0))
//
//                                if (cell != nil) {
//                                    curSessionId = 0
//                                    startDownload = true
//                                    curSessionOffset = 0
//                                    let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory,                                      .userDomainMask, true)
//                                    if dirPaths != [] {
//                                        filepath = dirPaths[0]// as! String
//                                        filepath.append(String(format:"/%@/", (nebdev?.device.name!)!))
//                                        do {
//                                            try FileManager.default.createDirectory(atPath: filepath, withIntermediateDirectories: false, attributes: nil)
//
//                                        } catch let error as NSError {
//                                            print(error.localizedDescription);
//                                        }
//                                        filepath.append(String(format:"%@_%d.dat", (nebdev?.device.name!)!, curSessionId))
//                                        FileManager.default.createFile(atPath: filepath, contents: nil, attributes: nil)
//                                        do {
//                                            try file = FileHandle(forWritingAtPath: filepath)
//                                        } catch { print("file failed \(filepath)")}
//                                        nebdev?.sessionDownload(true, SessionId : curSessionId, Len: 16, Offset: 0)
//                                    }
//                                }
//                                break
//                            case NEBLINA_COMMAND_RECORDER_PLAYBACK:
//                                let cell = tableView.cellForRow( at: IndexPath(row: row, section: 0))
//                                if cell != nil {
//                                    let tf = cell?.viewWithTag(4) as! UITextField
//                                    let bt = cell?.viewWithTag(2) as! UIButton
//                                    if playback == true {
//                                        bt.setTitle("Play", for: .normal)
//                                        playback = false
//                                    }
//                                    else {
//                                        bt.setTitle("Stop", for: .normal)
//                                        var n = UInt16(0)
//
//                                        if !(tf.text!.isEmpty) {
//                                            n = (UInt16((tf.text!)))!
//
//                                        }
//
//                                        nebdev?.sessionPlayback(true, sessionId : n)
//                                        PaketCnt = 0
//                                        playback = true
//                                    }
//                                }
//                                break
//                            default:
//                                break
//                        }
//                    default:
//                        break
//                }
//            }
        }
        
        @IBAction func switchAction(_ sender:UISegmentedControl)
        {
//            //let tableView = sender.superview?.superview?.superview?.superview as! UITableView
//            let idx = tableView.indexPath(for: sender.superview!.superview as! UITableViewCell)
//            let row = ((idx as NSIndexPath?)?.row)! as Int
//
//            if (nebdev == nil) {
//                return
//            }
//
//            if (row < NebCmdList.count) {
//                switch (NebCmdList[row].SubSysId)
//                {
//                    case NEBLINA_SUBSYSTEM_GENERAL:
//                        switch (NebCmdList[row].CmdId)
//                        {
//                            case NEBLINA_COMMAND_GENERAL_INTERFACE_STATUS:
//                                //nebdev!.setInterface(sender.selectedSegmentIndex)
//                                break
//                            case NEBLINA_COMMAND_GENERAL_INTERFACE_STATE:
//                                nebdev!.setDataPort(row, Ctrl:UInt8(sender.selectedSegmentIndex))
//                                break;
//                            default:
//                                break
//                        }
//                        break
//
//                    case NEBLINA_SUBSYSTEM_FUSION:
//                        switch (NebCmdList[row].CmdId)
//                        {
//                            case NEBLINA_COMMAND_FUSION_MOTION_STATE_STREAM:
//                                nebdev!.streamMotionState(sender.selectedSegmentIndex == 1)
//                                break
//                            case NEBLINA_COMMAND_FUSION_FUSION_TYPE:
//                                nebdev!.setFusionType(UInt8(sender.selectedSegmentIndex))
//                                break
//                            //case IMU_Data:
//                            //    nebdev!.streamIMU(sender.selectedSegmentIndex == 1)
//                        //        break
//                            case NEBLINA_COMMAND_FUSION_QUATERNION_STREAM:
//                                nebdev!.streamEulerAngle(false)
//                                heading = false
//                                prevTimeStamp = 0
//                                nebdev!.streamQuaternion(sender.selectedSegmentIndex == 1)
//                                let i = getCmdIdx(0xf,  cmdId: 1)
//                                let cell = tableView.cellForRow( at: IndexPath(row: i, section: 0))
//                                if (cell != nil) {
//                                    let sw = cell!.viewWithTag(1) as! UISegmentedControl
//                                    sw.selectedSegmentIndex = 0
//                                }
//                                break
//                            case NEBLINA_COMMAND_FUSION_PEDOMETER_STREAM:
//                                nebdev!.streamPedometer(sender.selectedSegmentIndex == 1)
//                                break
//                            case NEBLINA_COMMAND_FUSION_ROTATION_INFO_STREAM:
//                                let cell = tableView.cellForRow( at: IndexPath(row: row, section: 0))
//                                var type = UInt8(0)
//                                if cell != nil {
//                                    let tf = cell?.viewWithTag(4) as! UITextField
//
//                                    if !(tf.text!.isEmpty) {
//                                        type = (UInt8((tf.text!)))!
//
//                                    }
//
//                                }
//                                nebdev!.streamRotationInfo(sender.selectedSegmentIndex == 1, Type:type)
//                                break
//                            case NEBLINA_COMMAND_FUSION_EULER_ANGLE_STREAM:
//                                nebdev!.streamQuaternion(false)
//                                nebdev!.streamEulerAngle(sender.selectedSegmentIndex == 1)
//                                break
//                            case NEBLINA_COMMAND_FUSION_EXTERNAL_FORCE_STREAM:
//                                nebdev!.streamExternalForce(sender.selectedSegmentIndex == 1)
//                                break
//                            case NEBLINA_COMMAND_FUSION_TRAJECTORY_RECORD:
//                                nebdev!.recordTrajectory(sender.selectedSegmentIndex == 1)
//                                break;
//                            case NEBLINA_COMMAND_FUSION_TRAJECTORY_INFO_STREAM:
//                                nebdev!.streamTrajectoryInfo(sender.selectedSegmentIndex == 1)
//                                break;
//    //                        case NEBLINA_COMMAND_FUSION_MAG_STATE:
//    //                            nebdev!.streamMAG(sender.selectedSegmentIndex == 1)
//    //                            break;
//                            case NEBLINA_COMMAND_FUSION_LOCK_HEADING_REFERENCE:
//                                nebdev!.lockHeadingReference()
//                                let cell = tableView.cellForRow( at: IndexPath(row: row, section: 0))
//                                if (cell != nil) {
//                                    let sw = cell!.viewWithTag(1) as! UISegmentedControl
//                                    sw.selectedSegmentIndex = 0
//                                }
//                                break
//                            default:
//                                break
//                        }
//                    case NEBLINA_SUBSYSTEM_RECORDER:
//                        switch (NebCmdList[row].CmdId)
//                        {
//
//                            case NEBLINA_COMMAND_RECORDER_ERASE_ALL:
//                                if (sender.selectedSegmentIndex == 1) {
//                                    flashEraseProgress = true;
//                                }
//                                nebdev!.eraseStorage(sender.selectedSegmentIndex == 1)
//                                break
//                            case NEBLINA_COMMAND_RECORDER_RECORD:
//                                nebdev!.sessionRecord(sender.selectedSegmentIndex == 1, info: "")
//                                break
//                            case NEBLINA_COMMAND_RECORDER_PLAYBACK:
//                                nebdev!.sessionPlayback(sender.selectedSegmentIndex == 1, sessionId : 0xffff)
//                                if (sender.selectedSegmentIndex == 1) {
//                                    PaketCnt = 0
//                                }
//                                break
//                            case NEBLINA_COMMAND_RECORDER_SESSION_READ:
//    //                            curDownloadSession = 0xFFFF
//    //                            curDownloadOffset = 0
//    //                            nebdev!.sessionRead(curDownloadSession, Len: 32, Offset: curDownloadOffset)
//                                break
//                            default:
//                                break
//                        }
//                        break
//                    case NEBLINA_SUBSYSTEM_EEPROM:
//                        switch (NebCmdList[row].CmdId)
//                        {
//                            case NEBLINA_COMMAND_EEPROM_READ:
//                                nebdev!.eepromRead(0)
//                                break
//                            case NEBLINA_COMMAND_EEPROM_WRITE:
//                                //UInt8_t eepdata[8]
//                                //nebdev.SendCmdEepromWrite(0, eepdata)
//                                break
//                            default:
//                                break
//                        }
//                        break
//                    case NEBLINA_SUBSYSTEM_SENSOR:
//                        switch (NebCmdList[row].CmdId)
//                        {
//                        case NEBLINA_COMMAND_SENSOR_ACCELEROMETER_STREAM:
//                            nebdev!.sensorStreamAccelData(sender.selectedSegmentIndex == 1)
//                            break
//                        case NEBLINA_COMMAND_SENSOR_GYROSCOPE_STREAM:
//                            nebdev?.sensorStreamGyroData(sender.selectedSegmentIndex == 1)
//                            break
//                        case NEBLINA_COMMAND_SENSOR_HUMIDITY_STREAM:
//                            nebdev?.sensorStreamHumidityData(sender.selectedSegmentIndex == 1)
//                            break
//                        case NEBLINA_COMMAND_SENSOR_MAGNETOMETER_STREAM:
//                            nebdev?.sensorStreamMagData(sender.selectedSegmentIndex == 1)
//
//                            break
//                        case NEBLINA_COMMAND_SENSOR_PRESSURE_STREAM:
//                            nebdev?.sensorStreamPressureData(sender.selectedSegmentIndex == 1)
//                            break
//                        case NEBLINA_COMMAND_SENSOR_TEMPERATURE_STREAM:
//                            nebdev?.sensorStreamTemperatureData(sender.selectedSegmentIndex == 1)
//                            break
//                        case NEBLINA_COMMAND_SENSOR_ACCELEROMETER_GYROSCOPE_STREAM:
//                            nebdev?.sensorStreamAccelGyroData(sender.selectedSegmentIndex == 1)
//                            break
//                        case NEBLINA_COMMAND_SENSOR_ACCELEROMETER_MAGNETOMETER_STREAM:
//                            nebdev?.sensorStreamAccelMagData(sender.selectedSegmentIndex == 1)
//                            break
//                        default:
//                            break
//                        }
//                        break
//
//                    case 0xf:
//                        switch (NebCmdList[row].CmdId) {
//                            case MotionDataStream:
//                                if sender.selectedSegmentIndex == 0 {
//                                    nebdev?.disableStreaming()
//                                    break
//                                }
//
//                                nebdev!.streamQuaternion(sender.selectedSegmentIndex == 1)
//                                var i = getCmdIdx(NEBLINA_SUBSYSTEM_FUSION,  cmdId: NEBLINA_COMMAND_FUSION_QUATERNION_STREAM)
//                                var cell = tableView.cellForRow( at: IndexPath(row: i, section: 0))
//                                if (cell != nil) {
//                                    let control = cell!.viewWithTag(1) as! UISegmentedControl
//                                    control.selectedSegmentIndex = sender.selectedSegmentIndex
//                                }
//    //                            nebdev!.streamIMU(sender.selectedSegmentIndex == 1)
//    //                            i = getCmdIdx(NEBLINA_SUBSYSTEM_FUSION,  cmdId: NEBLINA_COMMAND_FUSION_IMU_STATE)
//    //                            cell = tableView.cellForRow( at: IndexPath(row: i, section: 0))
//    //                            if (cell != nil) {
//    //                                let control = cell!.viewWithTag(1) as! UISegmentedControl
//    //                                control.selectedSegmentIndex = sender.selectedSegmentIndex
//    //                            }
//                                nebdev!.sensorStreamMagData(sender.selectedSegmentIndex == 1)
//                                i = getCmdIdx(NEBLINA_SUBSYSTEM_FUSION,  cmdId: NEBLINA_COMMAND_SENSOR_MAGNETOMETER_STREAM)
//                                cell = tableView.cellForRow( at: IndexPath(row: i, section: 0))
//                                if (cell != nil) {
//                                    let control = cell!.viewWithTag(1) as! UISegmentedControl
//                                    control.selectedSegmentIndex = sender.selectedSegmentIndex
//                                }
//                                nebdev!.streamExternalForce(sender.selectedSegmentIndex == 1)
//                                i = getCmdIdx(NEBLINA_SUBSYSTEM_FUSION,  cmdId: NEBLINA_COMMAND_FUSION_EXTERNAL_FORCE_STREAM)
//                                cell = tableView.cellForRow( at: IndexPath(row: i, section: 0))
//                                if (cell != nil) {
//                                    let control = cell!.viewWithTag(1) as! UISegmentedControl
//                                    control.selectedSegmentIndex = sender.selectedSegmentIndex
//                                }
//                                nebdev!.streamPedometer(sender.selectedSegmentIndex == 1)
//                                i = getCmdIdx(NEBLINA_SUBSYSTEM_FUSION,  cmdId: NEBLINA_COMMAND_FUSION_PEDOMETER_STREAM)
//                                cell = tableView.cellForRow( at: IndexPath(row: i, section: 0))
//                                if (cell != nil) {
//                                    let control = cell!.viewWithTag(1) as! UISegmentedControl
//                                    control.selectedSegmentIndex = sender.selectedSegmentIndex
//                                }
//                                nebdev!.streamRotationInfo(sender.selectedSegmentIndex == 1, Type : 1)
//                                i = getCmdIdx(NEBLINA_SUBSYSTEM_FUSION,  cmdId: NEBLINA_COMMAND_FUSION_ROTATION_INFO_STREAM)
//                                cell = tableView.cellForRow( at: IndexPath(row: i, section: 0))
//                                if (cell != nil) {
//                                    let control = cell!.viewWithTag(1) as! UISegmentedControl
//                                    control.selectedSegmentIndex = sender.selectedSegmentIndex
//                                }
//                                i = getCmdIdx(0xF,  cmdId: Heading)
//                                cell = tableView.cellForRow( at: IndexPath(row: i, section: 0))
//                                if (cell != nil) {
//                                    let control = cell!.viewWithTag(1) as! UISegmentedControl
//                                    control.selectedSegmentIndex = 0
//                                }
//                                i = getCmdIdx(0xF,  cmdId: LuggageDataLog)
//                                cell = tableView.cellForRow( at: IndexPath(row: i, section: 0))
//                                if (cell != nil) {
//                                    let control = cell!.viewWithTag(1) as! UISegmentedControl
//                                    control.selectedSegmentIndex = 0
//                                }
//                                break
//                            case LuggageDataLog:
//                                if sender.selectedSegmentIndex == 0 {
//                                    nebdev!.disableStreaming()
//                                    nebdev!.sessionRecord(false, info: "")
//                                    break
//                                }
//                                else {
//                                    nebdev!.sensorStreamAccelGyroData(true)
//                                    nebdev!.sensorStreamMagData(true)
//                                    nebdev!.sensorStreamPressureData(true)
//                                    nebdev!.sensorStreamTemperatureData(true)
//                                    nebdev!.sessionRecord(true, info: "")
//
//                                }
//
//
//                                var i = getCmdIdx(NEBLINA_SUBSYSTEM_FUSION,  cmdId: NEBLINA_COMMAND_FUSION_QUATERNION_STREAM)
//                                var cell = tableView.cellForRow( at: IndexPath(row: i, section: 0))
//
//
//                                i = getCmdIdx(0xF,  cmdId: Heading)
//                                cell = tableView.cellForRow( at: IndexPath(row: i, section: 0))
//                                if (cell != nil) {
//                                    let control = cell!.viewWithTag(1) as! UISegmentedControl
//                                    control.selectedSegmentIndex = 0
//                                }
//                                i = getCmdIdx(0xF,  cmdId: MotionDataStream)
//                                cell = tableView.cellForRow( at: IndexPath(row: i, section: 0))
//                                if (cell != nil) {
//                                    let control = cell!.viewWithTag(1) as! UISegmentedControl
//                                    control.selectedSegmentIndex = 0
//                                }
//                                break
//                            default:
//                                break
//                        }
//                        break
//                    default:
//                        break
//                }
//
//            }
        }
        
        func updateUI(status : NeblinaSystemStatus_t) {
            for idx in 0...NebCmdList.count - 1 {
                switch (NebCmdList[idx].SubSysId) {
                case NEBLINA_SUBSYSTEM_GENERAL:
                    switch (NebCmdList[idx].CmdId) {
                    case NEBLINA_COMMAND_GENERAL_INTERFACE_STATE:
                        //let cell = tableView.view(atColumn: 0, row: idx, makeIfNecessary: false)! as NSView
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
                    //let cell = tableView.view(atColumn: 0, row: idx, makeIfNecessary: false)! as NSView
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
                    //print("\(NebCmdList[idx])")
                    let cell = tableView.cellForRow( at: IndexPath(row: idx, section: 0))
                    if cell != nil {
                        //let cell = tableView.view(atColumn: 0, row: idx, makeIfNecessary: false)! as NSView
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

        // MARK : UITableView
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return NebCmdList.count
        }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        {
            let cellView = tableView.dequeueReusableCell(withIdentifier: "CellCommand", for: indexPath)
            let labelView = cellView.viewWithTag(255) as! UILabel
            if ((indexPath as NSIndexPath).row < NebCmdList.count) {
                
                labelView.text = NebCmdList[(indexPath as NSIndexPath).row].Name
                switch (NebCmdList[(indexPath as NSIndexPath).row].Actuator)
                {
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
                        if !NebCmdList[(indexPath as NSIndexPath).row].Text.isEmpty
                        {
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
                        if !NebCmdList[(indexPath as NSIndexPath).row].Text.isEmpty
                        {
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
                        if !NebCmdList[(indexPath as NSIndexPath).row].Text.isEmpty
                        {
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

        func tableView(_ tableView: UITableView, canEditRowAtIndexPath indexPath: IndexPath?) -> Bool
        {
            return false
        }
    override func scrollViewDidScroll(_ scrollView: UIScrollView)
        {
//            if (nebdev == nil) {
//                return
//            }
//            
//            nebdev!.getSystemStatus()
        }
}

