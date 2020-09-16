//
//  ControllerNeblinaExtension.swift
//  neblinaAR
//
//  Created by Negar on 2020-04-01.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit
import CoreBluetooth
import QuartzCore
import GLKit
import SceneKit
import SpriteKit

let MotionDataStream = Int32(1)
let Heading = Int32(2)
let LuggageDataLog = Int32(3)

let NebCmdList = [NebCmdItem] (arrayLiteral:
    NebCmdItem(SubSysId: NEBLINA_SUBSYSTEM_GENERAL, CmdId: NEBLINA_COMMAND_GENERAL_INTERFACE_STATE, ActiveStatus: UInt32(NEBLINA_INTERFACE_STATUS_BLE.rawValue),
               Name: "BLE Data Port", Actuator : ACTUATOR_TYPE_SWITCH, Text: ""),
    NebCmdItem(SubSysId: NEBLINA_SUBSYSTEM_GENERAL, CmdId: NEBLINA_COMMAND_GENERAL_INTERFACE_STATE, ActiveStatus: UInt32(NEBLINA_INTERFACE_STATUS_UART.rawValue),
               Name: "UART Data Port", Actuator : ACTUATOR_TYPE_SWITCH, Text: ""),
    NebCmdItem(SubSysId: NEBLINA_SUBSYSTEM_FUSION, CmdId: NEBLINA_COMMAND_FUSION_CALIBRATE_FORWARD_POSITION, ActiveStatus: 0,
               Name: "Calibrate Forward Pos", Actuator : ACTUATOR_TYPE_BUTTON, Text: "Calib Fwrd"),
    NebCmdItem(SubSysId: NEBLINA_SUBSYSTEM_FUSION, CmdId: NEBLINA_COMMAND_FUSION_CALIBRATE_DOWN_POSITION, ActiveStatus: 0,
               Name: "Calibrate Down Pos", Actuator : ACTUATOR_TYPE_BUTTON, Text: "Calib Dwn"),
    NebCmdItem(SubSysId: NEBLINA_SUBSYSTEM_GENERAL, CmdId: NEBLINA_COMMAND_GENERAL_RESET_TIMESTAMP, ActiveStatus: 0,
               Name: "Reset timestamp", Actuator : ACTUATOR_TYPE_BUTTON, Text: "Reset"),
    NebCmdItem(SubSysId: NEBLINA_SUBSYSTEM_FUSION, CmdId: NEBLINA_COMMAND_FUSION_FUSION_TYPE, ActiveStatus: 0,
               Name: "Fusion 9 axis", Actuator : ACTUATOR_TYPE_SWITCH, Text:""),
    NebCmdItem(SubSysId: NEBLINA_SUBSYSTEM_FUSION, CmdId: NEBLINA_COMMAND_FUSION_QUATERNION_STREAM, ActiveStatus: UInt32(NEBLINA_FUSION_STATUS_QUATERNION.rawValue),
               Name: "Quaternion Stream", Actuator : ACTUATOR_TYPE_SWITCH, Text: ""),
    NebCmdItem(SubSysId: NEBLINA_SUBSYSTEM_FUSION, CmdId: NEBLINA_COMMAND_FUSION_PEDOMETER_STREAM, ActiveStatus: UInt32(NEBLINA_FUSION_STATUS_PEDOMETER.rawValue),
               Name: "Pedometer Stream", Actuator : ACTUATOR_TYPE_SWITCH, Text: ""),
    NebCmdItem(SubSysId: NEBLINA_SUBSYSTEM_FUSION, CmdId: NEBLINA_COMMAND_FUSION_ROTATION_INFO_STREAM, ActiveStatus: UInt32(NEBLINA_FUSION_STATUS_ROTATION_INFO.rawValue),
               Name: "Rotation info Stream", Actuator : ACTUATOR_TYPE_TEXT_FIELD_SWITCH, Text: ""),
    NebCmdItem(SubSysId: NEBLINA_SUBSYSTEM_SENSOR, CmdId: NEBLINA_COMMAND_SENSOR_ACCELEROMETER_STREAM, ActiveStatus: UInt32(NEBLINA_SENSOR_STATUS_ACCELEROMETER.rawValue),
               Name: "Accelerometer Sensor Stream", Actuator : ACTUATOR_TYPE_SWITCH, Text: ""),
    NebCmdItem(SubSysId: NEBLINA_SUBSYSTEM_SENSOR, CmdId: NEBLINA_COMMAND_SENSOR_GYROSCOPE_STREAM, ActiveStatus: UInt32(NEBLINA_SENSOR_STATUS_GYROSCOPE.rawValue),
               Name: "Gyroscope Sensor Stream", Actuator : ACTUATOR_TYPE_SWITCH, Text: ""),
    NebCmdItem(SubSysId: NEBLINA_SUBSYSTEM_SENSOR, CmdId: NEBLINA_COMMAND_SENSOR_MAGNETOMETER_STREAM, ActiveStatus: UInt32(NEBLINA_SENSOR_STATUS_MAGNETOMETER.rawValue),
               Name: "Magnetometer Sensor Stream", Actuator : ACTUATOR_TYPE_SWITCH, Text: ""),
    NebCmdItem(SubSysId: NEBLINA_SUBSYSTEM_SENSOR, CmdId: NEBLINA_COMMAND_SENSOR_ACCELEROMETER_GYROSCOPE_STREAM, ActiveStatus: UInt32(NEBLINA_SENSOR_STATUS_ACCELEROMETER_GYROSCOPE.rawValue),
               Name: "Accel & Gyro Stream", Actuator : ACTUATOR_TYPE_SWITCH, Text:""),
    NebCmdItem(SubSysId: NEBLINA_SUBSYSTEM_SENSOR, CmdId: NEBLINA_COMMAND_SENSOR_HUMIDITY_STREAM, ActiveStatus: UInt32(NEBLINA_SENSOR_STATUS_HUMIDITY.rawValue),
               Name: "Humidity Sensor Stream", Actuator : ACTUATOR_TYPE_SWITCH, Text: ""),
    NebCmdItem(SubSysId: NEBLINA_SUBSYSTEM_SENSOR, CmdId: NEBLINA_COMMAND_SENSOR_TEMPERATURE_STREAM, ActiveStatus: UInt32(NEBLINA_SENSOR_STATUS_TEMPERATURE.rawValue),
               Name: "Temperature Sensor Stream", Actuator : ACTUATOR_TYPE_SWITCH, Text: ""),
    NebCmdItem(SubSysId: NEBLINA_SUBSYSTEM_FUSION, CmdId: NEBLINA_COMMAND_FUSION_LOCK_HEADING_REFERENCE, ActiveStatus: 0,
               Name: "Lock Heading Ref.", Actuator : ACTUATOR_TYPE_SWITCH, Text: ""),
    NebCmdItem(SubSysId: NEBLINA_SUBSYSTEM_RECORDER, CmdId: NEBLINA_COMMAND_RECORDER_RECORD, ActiveStatus: UInt32(NEBLINA_RECORDER_STATUS_RECORD.rawValue),
               Name: "Flash Record", Actuator : ACTUATOR_TYPE_BUTTON, Text: "Start"),
    NebCmdItem(SubSysId: NEBLINA_SUBSYSTEM_RECORDER, CmdId: NEBLINA_COMMAND_RECORDER_RECORD, ActiveStatus: 0,
               Name: "Flash Record", Actuator : ACTUATOR_TYPE_BUTTON, Text: "Stop"),
    NebCmdItem(SubSysId: NEBLINA_SUBSYSTEM_EEPROM, CmdId: NEBLINA_COMMAND_EEPROM_READ, ActiveStatus: 0,
               Name: "EEPROM Read", Actuator : ACTUATOR_TYPE_BUTTON, Text: "Read"),
    NebCmdItem(SubSysId: 0xf, CmdId: MotionDataStream, ActiveStatus: 0,
               Name: "Motion data stream", Actuator : ACTUATOR_TYPE_SWITCH, Text: ""),
    NebCmdItem(SubSysId: NEBLINA_SUBSYSTEM_RECORDER, CmdId: NEBLINA_COMMAND_RECORDER_ERASE_ALL, ActiveStatus: 0,
               Name: "Flash Erase All", Actuator : ACTUATOR_TYPE_BUTTON, Text: "Erase"),
    NebCmdItem(SubSysId: NEBLINA_SUBSYSTEM_GENERAL, CmdId: NEBLINA_COMMAND_GENERAL_FIRMWARE_UPDATE, ActiveStatus: 0,
               Name: "Firmware Update", Actuator : ACTUATOR_TYPE_BUTTON, Text: "DFU"),
    NebCmdItem(SubSysId: NEBLINA_SUBSYSTEM_GENERAL, CmdId: NEBLINA_COMMAND_GENERAL_DEVICE_SHUTDOWN, ActiveStatus: 0,
               Name: "Shutdown", Actuator : ACTUATOR_TYPE_BUTTON, Text: "Shutdown")
)

extension ViewController: NeblinaDelegate{
    
    // MARK: Neblina
    func didConnectNeblina(sender : Neblina) {
            // Switch to BLE interface
            prevTimeStamp = 0;
            nebdev!.getSystemStatus()
            nebdev!.getFirmwareVersion()
        }
        
        func didReceiveResponsePacket(sender : Neblina, subsystem : Int32, cmdRspId : Int32, data : UnsafePointer<UInt8>, dataLen : Int)
        {
            print("didReceiveResponsePacket : \(subsystem) \(cmdRspId)")
            switch subsystem {
                case NEBLINA_SUBSYSTEM_GENERAL:
                    switch (cmdRspId) {
                        case NEBLINA_COMMAND_GENERAL_SYSTEM_STATUS:
                            let d = UnsafeMutableRawPointer(mutating: data).load(as: NeblinaSystemStatus_t.self)// UnsafeBufferPointer<NeblinaSystemStatus_t>(data))
                            print(" \(d)")
                            //updateUI(status: d)
                            break
                        case NEBLINA_COMMAND_GENERAL_FIRMWARE_VERSION:
                            let vers = UnsafeMutableRawPointer(mutating: data).load(as: NeblinaFirmwareVersion_t.self)
                            _ = (UInt32(vers.firmware_build.0) & 0xFF) | ((UInt32(vers.firmware_build.1) & 0xFF) << 8) | ((UInt32(vers.firmware_build.2) & 0xFF) << 16)
                            print("\(vers) ")
                            break
                        default:
                            break
                    }
                    break
                
                case NEBLINA_SUBSYSTEM_FUSION:
                    switch cmdRspId {
                        case NEBLINA_COMMAND_FUSION_QUATERNION_STREAM:
                            break
                        default:
                            break
                    }
                    break
                case NEBLINA_SUBSYSTEM_RECORDER:
                    switch (cmdRspId) {
                        case NEBLINA_COMMAND_RECORDER_ERASE_ALL:
                            flashEraseProgress = false
                            break
                        case NEBLINA_COMMAND_RECORDER_RECORD:
                            _ = Int16(data[1]) | (Int16(data[2]) << 8)
                            break
                        case NEBLINA_COMMAND_RECORDER_PLAYBACK:
                            _ = Int16(data[1]) | (Int16(data[2]) << 8)
                            if (data[0] != 0) {
                            }
                            else {
                            
                                playback = false
//                                let i = getCmdIdx(NEBLINA_SUBSYSTEM_RECORDER,  cmdId: NEBLINA_COMMAND_RECORDER_PLAYBACK)
//                                let cell = tableView.cellForRow( at: IndexPath(row: i, section: 0))
//                                if (cell != nil) {
//                                    let sw = cell!.viewWithTag(2) as! UIButton
//                                    sw.setTitle("Play", for: .normal)
//                                }
                            }
                            break
                        default:
                            break
                    }
                    break
                case NEBLINA_SUBSYSTEM_SENSOR:
                    //nebdev?.getFirmwareVersion()
                    break
                default:
                    break
            }
        }
        
        func didReceiveRSSI(sender : Neblina, rssi : NSNumber) {
            
        }

        //
        // General data
        //
        func didReceiveGeneralData(sender : Neblina, respType: Int32, cmdRspId : Int32, data : UnsafeRawPointer, dataLen : Int, errFlag : Bool) {
            switch (cmdRspId) {
            default:
                break
            }
        }
        
        func didReceiveFusionData(sender : Neblina, respType : Int32, cmdRspId : Int32, data : NeblinaFusionPacket_t, errFlag : Bool) {

            //let errflag = Bool(type.rawValue & 0x80 == 0x80)

            //let id = FusionId(rawValue: type.rawValue & 0x7F)! as FusionId
            //dumpLabel.text = String(format: "Total packet %u @ %0.2f pps, drop \(dropCnt)", nebdev!.getPacketCount(), nebdev!.getDataRate())
        
            switch (cmdRspId) {
                
            case NEBLINA_COMMAND_FUSION_MOTION_STATE_STREAM:
                break
            case NEBLINA_COMMAND_FUSION_EULER_ANGLE_STREAM:
                //
                // Process Euler Angle
                //
                let x = (Int16(data.data.0) & 0xff) | (Int16(data.data.1) << 8)
                let xrot = Float(x) / 10.0
                let y = (Int16(data.data.2) & 0xff) | (Int16(data.data.3) << 8)
                let yrot = Float(y) / 10.0
                let z = (Int16(data.data.4) & 0xff) | (Int16(data.data.5) << 8)
                let zrot = Float(z) / 10.0
                if (heading) {
                    print("headingggg")
                    player.zRotation = CGFloat(GLKMathDegreesToRadians(180) - GLKMathDegreesToRadians(xrot))
                }
                else {
                    let skView = self.view as! SKView
                    if (!skView.isPaused){
                        if currentGame == .breakOut{
                            let new_pos = CGFloat(xrot)*11
                            if ( new_pos + player.size.width/2 < UIScreen.main.bounds.size.width/2 && new_pos - player.size.width/2 > -UIScreen.main.bounds.size.width/2){
                                player.position.x = new_pos
                            }
                        }
                        else{
                            let new_pos = CGFloat(zrot)*11
                            if ( new_pos + bird.size.height/2 < UIScreen.main.bounds.size.height/2 && new_pos - bird.size.height/2 > -UIScreen.main.bounds.size.height/2){
                                bird.position.y = -new_pos
                            }
                        }
                    }
                    
                }
            
                break
            case NEBLINA_COMMAND_FUSION_QUATERNION_STREAM:
            
                //
                // Process Quaternion
                //
                let x = (Int16(data.data.0) & 0xff) | (Int16(data.data.1) << 8)//w
                let xq = Float(x) / 32768.0
                let y = (Int16(data.data.2) & 0xff) | (Int16(data.data.3) << 8)//x
                let yq = Float(y) / 32768.0
                let z = (Int16(data.data.4) & 0xff) | (Int16(data.data.5) << 8)//y
                let zq = Float(z) / 32768.0
                let w = (Int16(data.data.6) & 0xff) | (Int16(data.data.7) << 8)//z
                let wq = Float(w) / 32768.0
//                player.zRotation = CGFloat(-zq)
//                print("#####Q######")
                sensorData = (xq, yq, zq, wq)
                if (prevTimeStamp == data.timestamp)
                {
                    var diff = Bool(false)
                    if prevPacket.data.0 != data.data.0 {
                        diff = true
                    }
                    else if prevPacket.data.1 != data.data.1 {
                        diff = true
                    }
                    else if prevPacket.data.2 != data.data.2 {
                        diff = true
                    }
                    else if prevPacket.data.3 != data.data.3 {
                        diff = true
                    }
                    else if prevPacket.data.4 != data.data.4 {
                        diff = true
                    }
                    else if prevPacket.data.5 != data.data.5 {
                        diff = true
                    }
                    else if prevPacket.data.6 != data.data.6 {
                        diff = true
                    }
                    else if prevPacket.data.7 != data.data.7 {
                        diff = true
                    }
                    else if prevPacket.data.8 != data.data.8 {
                        diff = true
                    }
                    else if prevPacket.data.9 != data.data.9 {
                        diff = true
                    }
                    else if prevPacket.data.10 != data.data.10 {
                        diff = true
                    }
                    else if prevPacket.data.11 != data.data.11 {
                        diff = true
                    }
                    if diff == true {
                        badTimestampCnt += 1
                    }
                    else {
                        dubTimestampCnt += 1
                    }
                    
                }
                if (prevTimeStamp == 0 || data.timestamp <= prevTimeStamp)
                {
                    prevTimeStamp = data.timestamp;
                    prevPacket = data;
                }
                else
                {
                    let tdiff = data.timestamp - prevTimeStamp;
                    if (tdiff > 49000)
                    {
                        dropCnt += 1
                    }
                    prevTimeStamp = data.timestamp
                    prevPacket = data
                }
                
                break
            case NEBLINA_COMMAND_FUSION_EXTERNAL_FORCE_STREAM:
                let x = (Int16(data.data.0) & 0xff) | (Int16(data.data.1) << 8)
                let xq = x / 1600
                let y = (Int16(data.data.2) & 0xff) | (Int16(data.data.3) << 8)
                let yq = y / 1600
                let z = (Int16(data.data.4) & 0xff) | (Int16(data.data.5) << 8)
                let zq = z / 1600

                cnt -= 1
                if (cnt <= 0) {
                    cnt = max_count
                    
                    xf = xq
                    yf = yq
                    zf = zq
                }
                else {
                        xf += xq
                        yf += yq
                        zf += zq
                }
//                print("#####external force######\(x)")
                
//                if x > 15 || x < -15{
//                    x_average = ((x_average * x_array.count) - x_array[x_array_iterator] + Int(x))/x_array.count
//                    x_array[x_array_iterator] = Int(x)
//                    x_array_iterator += 1
//                    if (x_array_iterator == x_array.count){
//                        x_array_iterator = 0
//                    }
//                print(x_array_iterator)
//                    print("\(x_average)")
//                    let new_pos = player.position.x + CGFloat(Double(x_average)/10.0)
//                    let right_side_of_screen = UIScreen.main.bounds.size.width
//                    if (new_pos<right_side_of_screen && new_pos>player.size.width/2){
                        //player.position.x = new_pos
//                }
//            }

                
//                player.physicsBody?.applyForce(CGVector(dx: CGFloat(xf), dy: CGFloat(0.0)))
                break
            case NEBLINA_COMMAND_FUSION_PEDOMETER_STREAM:
                _ = data.data.9;
                _ = UInt16(data.data.10) + (UInt16(data.data.11) << 8)
                break
            case NEBLINA_COMMAND_FUSION_SHOCK_SEGMENT_STREAM:
                _ = (Int16(data.data.0) & 0xff) | (Int16(data.data.1) << 8)
                _ = (Int16(data.data.2) & 0xff) | (Int16(data.data.3) << 8)
                _ = (Int16(data.data.4) & 0xff) | (Int16(data.data.5) << 8)

                _ = (Int16(data.data.6) & 0xff) | (Int16(data.data.7) << 8)
                _ = (Int16(data.data.8) & 0xff) | (Int16(data.data.9) << 8)
                _ = (Int16(data.data.10) & 0xff) | (Int16(data.data.11) << 8)
                break
            default:
                break
            }
            
            
        }
        
        func didReceivePmgntData(sender : Neblina, respType : Int32, cmdRspId : Int32, data : UnsafePointer<UInt8>, dataLen: Int, errFlag : Bool) {
        }
        
        func didReceiveLedData(sender : Neblina, respType : Int32, cmdRspId : Int32, data : UnsafePointer<UInt8>, dataLen: Int, errFlag : Bool) {
        }
        
        //
        // Debug
        //
        func didReceiveDebugData(sender : Neblina, respType : Int32, cmdRspId : Int32, data : UnsafePointer<UInt8>, dataLen : Int, errFlag : Bool)
        {
        }
            
        func didReceiveRecorderData(sender : Neblina, respType : Int32, cmdRspId : Int32, data : UnsafePointer<UInt8>, dataLen: Int, errFlag : Bool) {
            switch (cmdRspId) {
                case NEBLINA_COMMAND_RECORDER_ERASE_ALL:
                    flashEraseProgress = false
                    break
                case NEBLINA_COMMAND_RECORDER_RECORD:
                    _ = Int16(data[1]) | (Int16(data[2]) << 8)
                    break
                case NEBLINA_COMMAND_RECORDER_PLAYBACK:
                    _ = Int16(data[1]) | (Int16(data[2]) << 8)
                    if (data[0] != 0) {
                    }
                    else {
                        playback = false
//                        let i = getCmdIdx(NEBLINA_SUBSYSTEM_RECORDER,  cmdId: NEBLINA_COMMAND_RECORDER_PLAYBACK)
//                        let cell = tableView.cellForRow( at: IndexPath(row: i, section: 0))
//                        if (cell != nil) {
//                            let sw = cell!.viewWithTag(2) as! UIButton
//                            sw.setTitle("Play", for: .normal)
//                        }
                    }
                    break
                case NEBLINA_COMMAND_RECORDER_SESSION_DOWNLOAD:
                    if (errFlag == false && dataLen > 0) {
                        
                        if dataLen < 4 {
                            break
                        }
                        
                        let offset = UInt32(UInt32(data[0]) | (UInt32(data[1]) << 8) | (UInt32(data[2]) << 16) | (UInt32(data[3]) << 24))
                        if curSessionOffset != offset {
                            // packet loss
                            print("SessionDownload \(curSessionOffset), \(offset), \(data) \(dataLen)")
                            if downloadRecovering == false {
                                nebdev?.sessionDownload(false, SessionId: curSessionId, Len: 12, Offset: curSessionOffset)
                                downloadRecovering = true
                            }
                        }
                        else {
                            downloadRecovering = false
                            let d = NSData(bytes: data + 4, length: dataLen - 4)
                            //writing
                            if file != nil {
                                
                                file?.write(d as Data)
                            }
                            curSessionOffset += UInt32(dataLen-4)
                        }
                        //print("\(curSessionOffset), \(data)")
                    }
                    else {
                        print("End session \(filepath)")
                        print(" Download End session errflag")
                        
                        if (dataLen > 0) {
                            let d = NSData(bytes: data, length: dataLen)
                            //writing
                            if file != nil {
                                file?.write(d as Data)
                            }
                        }
                        file?.closeFile()
//                        let i = getCmdIdx(NEBLINA_SUBSYSTEM_RECORDER,  cmdId: NEBLINA_COMMAND_RECORDER_SESSION_DOWNLOAD)
//                        if i < 0 {
//                            break
//                        }
    //                    let cell = tableView.view(atColumn: 0, row: i, makeIfNecessary: false)! as NSView // cellForRowAtIndexPath( NSIndexPath(forRow: i, inSection: 0))
    //                    let sw = cell.viewWithTag(2) as! NSButton
                        
    //                    sw.isEnabled = true
                    }
                    break
                default:
                    break
            }
        }
        
        func didReceiveEepromData(sender : Neblina, respType : Int32, cmdRspId : Int32, data : UnsafePointer<UInt8>, dataLen: Int, errFlag : Bool) {
            switch (cmdRspId) {
                case NEBLINA_COMMAND_EEPROM_READ:
                    _ = UInt16(data[0]) | (UInt16(data[1]) << 8)
                    break
                case NEBLINA_COMMAND_EEPROM_WRITE:
                    break;
                default:
                    break
            }
        }
        
        //
        // Sensor data
        //
        func didReceiveSensorData(sender : Neblina, respType : Int32, cmdRspId : Int32, data : UnsafePointer<UInt8>, dataLen : Int, errFlag : Bool) {
            switch (cmdRspId) {
            case NEBLINA_COMMAND_SENSOR_ACCELEROMETER_STREAM:
                let x = (Int16(data[4]) & 0xff) | (Int16(data[5]) << 8)
                let xq = x
                let y = (Int16(data[6]) & 0xff) | (Int16(data[7]) << 8)
                let yq = y
                let z = (Int16(data[8]) & 0xff) | (Int16(data[9]) << 8)
                let zq = z
                
//                if xq != 0 {
//                    print("Accel - x:\(yq)")
//                }
//                if (yq > 50 || yq < -50){
//                    player.position.x = player.position.x + CGFloat(Double(zq)/10.0)
//                }
                
                
                break
            case NEBLINA_COMMAND_SENSOR_GYROSCOPE_STREAM:
                let x = (Int16(data[4]) & 0xff) | (Int16(data[5]) << 8)
                _ = x
                let y = (Int16(data[6]) & 0xff) | (Int16(data[7]) << 8)
                _ = y
                let z = (Int16(data[8]) & 0xff) | (Int16(data[9]) << 8)
                _ = z
                break
            case NEBLINA_COMMAND_SENSOR_HUMIDITY_STREAM:
                let x = (Int32(data[4]) & 0xff) | (Int32(data[5]) << 8) | (Int32(data[6]) << 16) | (Int32(data[7]) << 24)
                _ = Float(x) / 100.0;
                break
            case NEBLINA_COMMAND_SENSOR_MAGNETOMETER_STREAM:
                _ = (Int16(data[4]) & 0xff) | (Int16(data[5]) << 8)
                _ = (Int16(data[6]) & 0xff) | (Int16(data[7]) << 8)
                _ = (Int16(data[8]) & 0xff) | (Int16(data[9]) << 8)
                break
            case NEBLINA_COMMAND_SENSOR_PRESSURE_STREAM:
                break
            case NEBLINA_COMMAND_SENSOR_TEMPERATURE_STREAM:
                let x = (Int32(data[4]) & 0xff) | (Int32(data[5]) << 8) | (Int32(data[6]) << 16) | (Int32(data[7]) << 24)
                _ = Float(x) / 100.0;
                break
            case NEBLINA_COMMAND_SENSOR_ACCELEROMETER_GYROSCOPE_STREAM:
                _ = (Int16(data[4]) & 0xff) | (Int16(data[5]) << 8)
                _ = (Int16(data[6]) & 0xff) | (Int16(data[7]) << 8)
                _ = (Int16(data[8]) & 0xff) | (Int16(data[9]) << 8)
                _ = (Int16(data[10]) & 0xff) | (Int16(data[11]) << 8)
                _ = (Int16(data[12]) & 0xff) | (Int16(data[13]) << 8)
                _ = (Int16(data[14]) & 0xff) | (Int16(data[15]) << 8)
                break
            case NEBLINA_COMMAND_SENSOR_ACCELEROMETER_MAGNETOMETER_STREAM:
                _ = (Int16(data[4]) & 0xff) | (Int16(data[5]) << 8)
                _ = (Int16(data[6]) & 0xff) | (Int16(data[7]) << 8)
                _ = (Int16(data[8]) & 0xff) | (Int16(data[9]) << 8)
                _ = (Int16(data[10]) & 0xff) | (Int16(data[11]) << 8)
                _ = (Int16(data[12]) & 0xff) | (Int16(data[13]) << 8)
                _ = (Int16(data[14]) & 0xff) | (Int16(data[15]) << 8)
                break
            default:
                break
            }
            //tableView.setNeedsDisplay()
        }
        
        func didReceiveBatteryLevel(sender: Neblina, level: UInt8) {
            print("Batt level \(level)")
        }
    
}
