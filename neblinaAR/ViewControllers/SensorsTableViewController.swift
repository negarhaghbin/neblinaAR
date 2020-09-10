//
//  SettingsViewController.swift
//  neblinaAR
//
//  Created by Negar on 2020-03-30.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit
import CoreBluetooth

var bleCentralManager : CBCentralManager!

class SensorsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CBCentralManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var detailViewController: UIViewController? = nil
    var objects = [Neblina]()
    var selectedSensors = [Neblina]()
    var prepareStart = false

    @IBOutlet weak var startButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bleCentralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        if(prepareStart){
            startButton.isHidden = false;
        }
    }

    @IBAction func insertRefreshScan(_ sender: Any) {
        bleCentralManager.stopScan()
        objects.removeAll()
        bleCentralManager.scanForPeripherals(withServices: [NEB_SERVICE_UUID], options: nil)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAR" {
            if (selectedSensors[0].name != ""){
                let object = selectedSensors[0]
                let controller = segue.destination as! ViewController
                if (controller.nebdev != nil) {
                    bleCentralManager.cancelPeripheralConnection(controller.nebdev!.device)
                }
                controller.nebdev = object
                bleCentralManager.connect(object.device, options: nil)
            }
        }
    }

        // MARK: - Table View

        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return objects.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SensorsTableViewCell
            
            if(prepareStart){
                cell.selectSwitch.isHidden = false
                cell.selectionStyle = .none
            }
            let object = objects[indexPath.row]
            cell.textLabel!.text = object.device.name
            cell.textLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.textLabel?.font = UIFont(name: "ARCADECLASSIC", size: 20)
            print("\(cell.textLabel!.text ?? "no text label")")
            cell.textLabel!.text = object.device.name! + String(format: "_%lX", object.id)
            print("Cell Name : \(cell.textLabel!.text ?? "no cell name")")
            
            cell.selectSwitch.tag = indexPath.row
            cell.selectSwitch.addTarget(self, action: #selector(self.addRemoveSensor(_:)), for: .valueChanged)
            
            return cell
        }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if(!prepareStart){
                if let vc = navigationController {
                    let storyBoard = UIStoryboard(name: "Main", bundle:nil)
                    let detailsViewController = storyBoard.instantiateViewController(withIdentifier: "SensorDetailViewController") as! SensorDetailViewController

                    vc.pushViewController(detailsViewController, animated: true)
                }
            }
        }
    @IBAction func addRemoveSensor(_ sender: UISwitch!) {
        if(sender.isOn){
            selectedSensors[sender.tag] = objects[sender.tag]
        }
        else{
            selectedSensors[sender.tag] = Neblina(devName: "", devid: 0, peripheral: nil)
        }
    }

        // MARK: - Bluetooth
        func centralManager(_ central: CBCentralManager,
            didDiscover peripheral: CBPeripheral,
            advertisementData : [String : Any],
            rssi RSSI: NSNumber) {
                print("PERIPHERAL NAME: \(peripheral)\n AdvertisementData: \(advertisementData)\n RSSI: \(RSSI)\n")
                
                print("UUID DESCRIPTION: \(peripheral.identifier.uuidString)\n")
                
                print("IDENTIFIER: \(peripheral.identifier)\n")
            
                if advertisementData[CBAdvertisementDataManufacturerDataKey] == nil {
                    return
                }
            
                var id : UInt64 = 0
            
            let mdata =  advertisementData[CBAdvertisementDataManufacturerDataKey] as! NSData
            
                if mdata.length < 8 {
                    return
                }
            
                (advertisementData[CBAdvertisementDataManufacturerDataKey] as! NSData).getBytes(&id, range: NSMakeRange(2, 8))
                if (id == 0) {
                    return
                }
                
                let name : String = advertisementData[CBAdvertisementDataLocalNameKey] as! String
                let device = Neblina(devName: name, devid: id, peripheral: peripheral)

                for dev in objects
                {
                    if (dev.id == id)
                    {
                        return;
                    }
                }
                
                objects.insert(device, at: 0)
                selectedSensors.insert(device, at: 0)
                
                tableView.reloadData();
        }
        
        func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {

            central.stopScan()
            peripheral.discoverServices(nil)
            print("Connected to peripheral")
        }
        
        func centralManager(_ central: CBCentralManager,
                              didDisconnectPeripheral peripheral: CBPeripheral,
                                                      error: Error?) {
            print("disconnected from peripheral \(String(describing: error))")
        }

        func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        }
        
        func scanPeripheral(_ sender: CBCentralManager)
        {
            print("Scan for peripherals")
            bleCentralManager.scanForPeripherals(withServices: nil, options: nil)
        }
        
        @objc func centralManagerDidUpdateState(_ central: CBCentralManager) {
            
            switch central.state {
                
            case .poweredOff:
                print("CoreBluetooth BLE hardware is powered off")
                //self.sensorData.text = "CoreBluetooth BLE hardware is powered off\n"
                break
            case .poweredOn:
                print("CoreBluetooth BLE hardware is powered on and ready")
                //self.sensorData.text = "CoreBluetooth BLE hardware is powered on and ready\n"
                // We can now call scanForBeacons
                let lastPeripherals = central.retrieveConnectedPeripherals(withServices: [NEB_SERVICE_UUID])
                
                if lastPeripherals.count > 0 {
                    // let device = lastPeripherals.last as CBPeripheral;
                    //connectingPeripheral = device;
                    //centralManager.connectPeripheral(connectingPeripheral, options: nil)
                }
                //scanPeripheral(central)
                bleCentralManager.scanForPeripherals(withServices: [NEB_SERVICE_UUID], options: nil)
                break
            case .resetting:
                print("CoreBluetooth BLE hardware is resetting")
                //self.sensorData.text = "CoreBluetooth BLE hardware is resetting\n"
                break
            case .unauthorized:
                print("CoreBluetooth BLE state is unauthorized")
                //self.sensorData.text = "CoreBluetooth BLE state is unauthorized\n"
                
                break
            case .unknown:
                print("CoreBluetooth BLE state is unknown")
                //self.sensorData.text = "CoreBluetooth BLE state is unknown\n"
                break
            case .unsupported:
                print("CoreBluetooth BLE hardware is unsupported on this platform")
                //self.sensorData.text = "CoreBluetooth BLE hardware is unsupported on this platform\n"
                break
                
            default:
                break
            }
        }

}
