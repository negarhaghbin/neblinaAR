//
//  ViewController.swift
//  neblinaAR
//
//  Created by Negar on 2019-10-13.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController{
    
    var nebdev : Neblina? {
        didSet {
            nebdev!.delegate = self
        }
    }
    
    @IBOutlet weak var scoreLabel: UILabel!

    var scene = SKScene()
    let max_count = Int16(15)
    var prevTimeStamp = UInt32(0)
    var cnt = Int16(15)
    var xf = Int16(0)
    var yf = Int16(0)
    var zf = Int16(0)
    var heading = Bool(false)
    var flashEraseProgress = Bool(false)
    var PaketCnt = UInt32(0)
    var dropCnt = UInt32(0)
    var curSessionId = UInt16(0)
    var curSessionOffset = UInt32(0)
    var sessionCount = UInt8(0)
    var startDownload = Bool(false)
    var filepath = String()
    var file : FileHandle?
    var downloadRecovering = Bool(false)
    var playback = Bool(false)
    var badTimestampCnt = Int(0)
    var dubTimestampCnt = Int(0)
    var prevPacket = NeblinaFusionPacket_t();
    var x_array = Array(repeating: 0, count: 20)
    var x_average = 0
    var x_array_iterator = 0
    
    var timer = Timer()
    var sensorData = (Float(0.0),Float(0.0),Float(0.0),Float(0.0))
    
//    @IBOutlet weak var messageView: UITextView!
    @IBOutlet weak var mainButton: UIButtonX!
    @IBOutlet weak var cancelButton: UIButtonX2!
    @IBOutlet weak var soundButton: UIButtonX2!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scene = GameScene(fileNamed:currentLevel)!
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        scene.size = view.bounds.size
        
        // MARK: Message
//        messageView.text="Ready, Set, Go!"
//        messageView.layer.cornerRadius = 15.0
//        let deadSpace = messageView.bounds.size.height - messageView.contentSize.height
//        let inset = max(0, deadSpace/2.0)
//        messageView.contentInset = UIEdgeInsets(top: inset, left: messageView.contentInset.left, bottom: inset, right: messageView.contentInset.right)
        
        // MARK: code e jadid
        //for external force uncomment it
//        nebdev!.streamMotionState(false)
//        nebdev!.streamExternalForce(true)
//        nebdev!.streamEulerAngle(false)
//        heading = false
//        prevTimeStamp = 0
//        nebdev!.streamQuaternion(false)
        
        //for Quaternion uncomment it
        /*
        nebdev!.streamEulerAngle(false)
        heading = false
        prevTimeStamp = 0
        nebdev!.streamQuaternion(true)*/
        
        //for Acc uncomment it
//        nebdev!.sensorStreamAccelData(true)
        
        //for yaw uncomment it
        nebdev!.streamQuaternion(false)
        nebdev!.streamEulerAngle(true)
        
        
        
        skView.presentScene(scene)
    }
    
    @IBAction func quit(_ sender: Any) {
        let alert = UIAlertController(title: "Do you want to quit?", message: "It will exit this session and your progress will be lost.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {
            action in
             //UIApplication.shared.isIdleTimerDisabled = false
            self.dismiss(animated: true, completion: nil)
            _ = self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {
            action in
        }))
        self.present(alert, animated: true)
    }
    
//    func showMessage(_ messageView:UITextView){
//        self.messageView.isHidden=false
//        DispatchQueue.main.asyncAfter(deadline: .now() + 30.0) {
//            self.messageView.isHidden=true
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        showMessage(messageView)
        
        self.mainButton.imageView?.contentMode = .center
        self.mainButton.imageView?.clipsToBounds = false
        
        
        //self.fourthButton.center = self.soundButton.center
        self.soundButton.center = self.cancelButton.center
        self.cancelButton.center = self.mainButton.center
        
        self.soundButton.alpha = 0
        self.cancelButton.alpha = 0
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        //self.fourthButton.alpha = 0
    }
    
    /**
     Action for Main Button
     */
    @IBAction func mainButtonAction(_ sender: Any) {
        
        if mainButton.imageView?.transform != .identity {
            //self.secondButton.alpha = 1
            animate(true)
        } else {
            animate(false)
        }
    }
    /**
     Animate Sub-buttons
     */
    func animate(_ isStart: Bool) {
        
        if isStart {
            UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut, animations: {
                    UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseInOut, animations: {
                        self.cancelButton.transform = CGAffineTransform(translationX: 0, y: 0)
                        self.cancelButton.alpha = 1
                        
                        UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseInOut, animations: {
                            self.soundButton.transform = CGAffineTransform(translationX: 0, y: 0)
                            self.soundButton.alpha = 1
                            
                        })
                    })
            }).startAnimation()
        } else {
            
            UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut, animations: {
                
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                     
                    UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseInOut, animations: {
                        
                        self.soundButton.transform = .identity
                        self.soundButton.alpha = 0
                        
                        UIView.animate(withDuration: 0.3, delay: 0.3 , options: .curveEaseInOut, animations: {
                            
                            self.cancelButton.transform = .identity
                            self.cancelButton.alpha = 0
                            
                        })
                        
                    })
                })
            }).startAnimation()
            
        }
    }
}


