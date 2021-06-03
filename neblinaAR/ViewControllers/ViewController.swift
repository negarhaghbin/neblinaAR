//
//  ViewController.swift
//  neblinaAR
//
//  Created by Negar on 2019-10-13.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class ViewController: UIViewController{
    
    // MARK: - IBOutlet
    @IBOutlet weak var pauseLabel: UILabel!
    
    @IBOutlet weak var mainButton: UIButtonX!
    @IBOutlet weak var cancelButton: UIButtonX2!
    @IBOutlet weak var soundButton: UIButtonX2!
    @IBOutlet weak var pauseButton: UIButtonX2!
    @IBOutlet weak var visualFeedbackButton: UIButtonX2!
    
    // MARK: - Variables
    var nebdev : Neblina? {
        didSet {
            nebdev!.delegate = self
        }
    }

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
    
    let BOSettings = BreakoutSettings.get()
    let FBSettings = FlappyBirdSettings.get()
    
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true
        switch currentGame {
        case .breakOut:
            scene = GameScene(fileNamed:currentLevel)!
            
            let audioFeedback = BOSettings.isAudioOn
            let visualFeedback = BOSettings.isVisualOn
            
            audioFeedback ?
                soundButton.setImage(UIImage(systemName: "speaker.slash"), for: .normal) :
                soundButton.setImage(UIImage(systemName: "speaker.2"), for: .normal)
            
            visualFeedback ?
                visualFeedbackButton.setImage(UIImage(systemName: "eye.slash"), for: .normal) :
                visualFeedbackButton.setImage(UIImage(systemName: "eye"), for: .normal)
            
        case .flappyBird:
            scene = FlappyBird(fileNamed: "FlappyBird")!
            
            let audioFeedback = FBSettings.isAudioOn
            let visualFeedback = FBSettings.isVisualOn
            
            audioFeedback ?
                soundButton.setImage(UIImage(systemName: "speaker.slash"), for: .normal) :
                soundButton.setImage(UIImage(systemName: "speaker.2"), for: .normal)
            
            visualFeedback ?
                visualFeedbackButton.setImage(UIImage(systemName: "eye.slash"), for: .normal) :
                visualFeedbackButton.setImage(UIImage(systemName: "eye"), for: .normal)
            
        }
        
        let skView = self.view as! SKView
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        scene.size = view.bounds.size
        nebdev!.streamQuaternion(false)
        nebdev!.streamEulerAngle(true)
        
        skView.presentScene(scene)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.mainButton.imageView?.contentMode = .center
        self.mainButton.imageView?.clipsToBounds = false
        
        
        self.pauseButton.center = self.visualFeedbackButton.center
        self.visualFeedbackButton.center = self.soundButton.center
        self.soundButton.center = self.cancelButton.center
        self.cancelButton.center = self.mainButton.center
        
        self.pauseButton.alpha = 0
        self.visualFeedbackButton.alpha = 0
        self.soundButton.alpha = 0
        self.cancelButton.alpha = 0
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Actions
    @IBAction func quit(_ sender: Any) {
        let alert = UIAlertController(title: "Do you want to quit?", message: "It will exit this session and your progress will be lost.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {
            action in
            self.dismiss(animated: true, completion: nil)
            _ = self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {
            action in
        }))
        self.present(alert, animated: true)
    }
    
    @IBAction func pause(_ sender: Any) {
        let skView = self.view as! SKView
        if skView.isPaused{
            pauseLabel.isHidden = true
            skView.scene?.isPaused = false
            skView.isPaused = false
            pauseButton.setImage(UIImage(systemName: "pause"), for: .normal)
        }
        else{
            pauseLabel.isHidden = false
            skView.scene?.isPaused = true
            skView.isPaused = true
            pauseButton.setImage(UIImage(systemName: "play"), for: .normal)
        }
        
    }
    

    // MARK: Menu
    @IBAction func enableDisableVisual(_ sender: Any) {
        switch currentGame {
        case .breakOut:
            let newValue = !BreakoutSettings.get().isVisualOn
            BreakoutSettings.get().setVisualFeedback(newValue: newValue)
            
            newValue ?
                visualFeedbackButton.setImage(UIImage(systemName: "eye.slash"), for: .normal) :
                visualFeedbackButton.setImage(UIImage(systemName: "eye"), for: .normal)
        case .flappyBird:
            let newValue = !FlappyBirdSettings.get().isVisualOn
            FlappyBirdSettings.get().setVisualFeedback(newValue: newValue)
            newValue ?
                visualFeedbackButton.setImage(UIImage(systemName: "eye.slash"), for: .normal) :
                visualFeedbackButton.setImage(UIImage(systemName: "eye"), for: .normal)
        }
    }
    
    
    @IBAction func muteUnmute(_ sender: Any) {
        
        switch currentGame {
        case .breakOut:
            let newValue = !BreakoutSettings.get().isAudioOn
            BreakoutSettings.get().setAudioFeedback(newValue: newValue)
            
            newValue ?
                soundButton.setImage(UIImage(systemName: "speaker.slash"), for: .normal) :
                soundButton.setImage(UIImage(systemName: "speaker.2"), for: .normal)
        case .flappyBird:
            let newValue = !FlappyBirdSettings.get().isAudioOn
            FlappyBirdSettings.get().setAudioFeedback(newValue: newValue)
            newValue ?
                soundButton.setImage(UIImage(systemName: "speaker.slash"), for: .normal) :
                soundButton.setImage(UIImage(systemName: "speaker.2"), for: .normal)
        }
    }
    
    @IBAction func mainButtonAction(_ sender: Any) {
        
        if mainButton.imageView?.transform != .identity {
            animate(true)
        } else {
            animate(false)
        }
    }

    func animate(_ isStart: Bool) {
        
        if isStart {
            UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut, animations: {
                    UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseInOut, animations: {
                        self.cancelButton.transform = CGAffineTransform(translationX: 0, y: 0)
                        self.cancelButton.alpha = 1
                        
                        UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseInOut, animations: {
                            self.soundButton.transform = CGAffineTransform(translationX: 0, y: 0)
                            self.soundButton.alpha = 1
                            
                        UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseInOut, animations: {
                            self.visualFeedbackButton.transform = CGAffineTransform(translationX: 0, y: 0)
                            self.visualFeedbackButton.alpha = 1
                            
                        
                        UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseInOut, animations: {
                            self.pauseButton.transform = CGAffineTransform(translationX: 0, y: 0)
                            self.pauseButton.alpha = 1
                        })
                            })
                            
                        })
                    })
            }).startAnimation()
        } else {
            
            UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut, animations: {
                
                UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseInOut, animations: {
                    
                    UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseInOut, animations: {
                        
                        self.pauseButton.transform = .identity
                        self.pauseButton.alpha = 0
                        
                        UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseInOut, animations: {
                        
                            self.visualFeedbackButton.transform = .identity
                            self.visualFeedbackButton.alpha = 0
                     
                        UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseInOut, animations: {
                        
                            self.soundButton.transform = .identity
                            self.soundButton.alpha = 0
                        
                            UIView.animate(withDuration: 0.2, delay: 0.2 , options: .curveEaseInOut, animations: {
                            
                                self.cancelButton.transform = .identity
                                self.cancelButton.alpha = 0
                            })
                            })
                        
                        })
                    })
                })
            }).startAnimation()
            
        }
    }
}


