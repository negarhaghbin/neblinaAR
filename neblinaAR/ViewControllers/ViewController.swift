//
//  ViewController.swift
//  neblinaAR
//
//  Created by Negar on 2019-10-13.
//  Copyright © 2019 Negar. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    var nebdev : Neblina? {
               didSet {
                   nebdev!.delegate = self
               }
           }

           let sceneShip = SCNScene(named: "art.scnassets/ship.scn")!
           var scene : SCNScene?
           var ship : SCNNode!
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
       
    
    
    var timer = Timer()
    
    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet weak var messageView: UITextView!
    
    @IBOutlet weak var mainButton: UIButtonX!
    @IBOutlet weak var cancelButton: UIButtonX2!
    @IBOutlet weak var soundButton: UIButtonX2!
    //@IBOutlet weak var fourthButton: UIButtonX2!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        //let sceneShip = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        //sceneView.scene = sceneShip
        messageView.text="Ready, Set, Go!"
        messageView.layer.cornerRadius = 15.0
        let deadSpace = messageView.bounds.size.height - messageView.contentSize.height
        let inset = max(0, deadSpace/2.0)
        messageView.contentInset = UIEdgeInsets(top: inset, left: messageView.contentInset.left, bottom: inset, right: messageView.contentInset.right)
        // MARK: code e jadid
        nebdev!.streamEulerAngle(false)
        heading = false
        prevTimeStamp = 0
        nebdev!.streamQuaternion(true)
        
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
            let message = Message(message: "you have a new message!")
            let postRequest = APIRequest(endpoint: "messages")
            postRequest.save(message, completion: {
                result in
                switch result{
                case .success(let message):
                    print("the following message has been sent: \(message.message)")
                
                case .failure(let error):
                    print("An error occured: \(error)")
                }
            })
        }
        
        
    }
    
    @IBAction func quit(_ sender: Any) {
        let alert = UIAlertController(title: "Do you want to finish workout?", message: "It will exit this session and your progress will be lost.", preferredStyle: .alert)

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
    
    func showMessage(_ messageView:UITextView){
        self.messageView.isHidden=false
        DispatchQueue.main.asyncAfter(deadline: .now() + 30.0) {
            self.messageView.isHidden=true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
        showMessage(messageView)
        
        self.mainButton.imageView?.contentMode = .center
        self.mainButton.imageView?.clipsToBounds = false
        
        
        //self.fourthButton.center = self.soundButton.center
        self.soundButton.center = self.cancelButton.center
        self.cancelButton.center = self.mainButton.center
        
        self.soundButton.alpha = 0
        self.cancelButton.alpha = 0
        print("here")
        navigationController?.setNavigationBarHidden(true, animated: false)
        //self.fourthButton.alpha = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func viewDidLayoutSubviews() {
        
        
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


    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
