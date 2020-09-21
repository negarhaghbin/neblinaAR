//
//  FlappyBird.swift
//  neblinaAR
//
//  Created by Negar on 2020-09-15.
//  Copyright © 2020 Negar. All rights reserved.
//

import Foundation
import SpriteKit

enum PhysicsCategory : UInt32 {
  case bird = 1
  case pipe = 2
}

var bird = SKSpriteNode()
var time = 0
var flappyBirdTimer = Timer()

class FlappyBird: SKScene, SKPhysicsContactDelegate {
    var resultsLbl = SKLabelNode()
    var scoreResultLbl = SKLabelNode()
    var scoreLbl = SKLabelNode()
    let tryAgainButton = SKButton()
    var pipes = [SKSpriteNode]()
    
    var said = false
    var isAudioFeedbackOn = FlappyBirdSettings.get().isAudioOn
    let upSound = SKAction.playSoundFileNamed("up.mp3", waitForCompletion: true)
    let downSound = SKAction.playSoundFileNamed("down.mp3", waitForCompletion: true)
    
    override func didMove(to view: SKView) {
        bird = self.childNode(withName: "bird") as! SKSpriteNode
        bird.position = CGPoint(x: 0, y: 0)
        
        createResultLabels()
        
        scoreLbl = self.childNode(withName: "scoreLabel") as! SKLabelNode
        scoreLbl.zPosition = 1
        
        createTryAgainButton()
      
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
      
        setTimer()
      
        run(SKAction.repeatForever(
          SKAction.sequence([
            SKAction.run(addPipe),
            SKAction.wait(forDuration: (2-FlappyBirdSettings.get().speed) * 1.0)
            ])
        ))
      
    }
    
    func createResultLabels(){
        resultsLbl = self.childNode(withName: "resultsLabel") as! SKLabelNode
        resultsLbl.position = CGPoint(x: 0, y: 100)
        resultsLbl.zPosition = 1
        resultsLbl.isHidden = true
        
        scoreResultLbl = self.childNode(withName: "scoreResult") as! SKLabelNode
        scoreResultLbl.position = CGPoint(x: 0, y: 0)
        scoreResultLbl.zPosition = 1
        scoreResultLbl.isHidden = true
    }
    
    func createTryAgainButton(){
        tryAgainButton.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(FlappyBird.tryAgain))
        tryAgainButton.setButtonLabel(title: "Try Again", font: "ARCADECLASSIC", fontSize: 30)
        tryAgainButton.color = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        tryAgainButton.position = CGPoint(x: scoreResultLbl.position.x,y: scoreResultLbl.position.y - 100)
        tryAgainButton.zPosition = 1
        tryAgainButton.name = "nextLevelButton"
        tryAgainButton.isHidden = true
        self.addChild(tryAgainButton)
    }
    
    func setTimer(){
        flappyBirdTimer.invalidate()
        time = 0
        flappyBirdTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
              if !self.view!.isPaused{
                  time += 1
                  self.scoreLbl.text = "\(time)"
              }
        }
    }
    
    @objc func tryAgain() {
        let scene = FlappyBird(fileNamed:"FlappyBird")!
        self.view?.presentScene(scene)
    }
    
    func random() -> CGFloat {
      return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
      return random() * (max - min) + min
    }
    
    
    func addPipe() {
        var pipe = SKSpriteNode(imageNamed: "pipe")
        let upOrDown = Int.random(in: 0...1)
        var actualY = CGFloat()
        if upOrDown == 0{
            pipe = SKSpriteNode(imageNamed: "downPipe")
            actualY = random(min: size.height/2 - pipe.size.height/2, max: size.height/2)
            pipe.position = CGPoint(x: size.width + pipe.size.width/2, y: actualY)
            pipe.name = "pipeFacingDown"
        }
        else{
            pipe.name = "pipeFacingUp"
            actualY = random(min: -size.height/2, max: -size.height/2 + pipe.size.height/2)
            pipe.position = CGPoint(x: size.width + pipe.size.width/2, y: actualY)
        }
        
        
        pipe.physicsBody = SKPhysicsBody(rectangleOf: pipe.size)
        pipe.physicsBody?.isDynamic = false
        pipe.physicsBody?.categoryBitMask = PhysicsCategory.pipe.rawValue
        pipe.physicsBody?.contactTestBitMask = PhysicsCategory.bird.rawValue
        pipe.physicsBody?.collisionBitMask = PhysicsCategory.bird.rawValue
        
        addChild(pipe)
        pipes.append(pipe)
      
        let actualDuration = CGFloat((2-FlappyBirdSettings.get().speed) * 4.0)
      
        let actionMove = SKAction.move(to: CGPoint(x: -size.width/2-pipe.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        pipe.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    private func birdMovement(pipe: SKSpriteNode)->Movement{
        if pipe.name == "pipeFacingDown"{
            if (bird.position.y + bird.size.height / 2) > (pipe.position.y - pipe.size.height/2){
                return .down
            }
        }
        else{
            if (bird.position.y - bird.size.height / 2) < (pipe.position.y + pipe.size.height/2){
                return .up
            }
        }
        return .none
    }
    
    override func update(_ currentTime: TimeInterval) {
        if bird.position.x < -size.width/2 {
             finishGame()
        }
        
        if isAudioFeedbackOn{
            if pipes.count > 0{
                if pipes[0].position.x > bird.position.x{
                    if !said{
                        if birdMovement(pipe: pipes[0]) == .up{
                            bird.run(upSound)
                            said = true
                        }
                        else if birdMovement(pipe: pipes[0]) == .down{
                            bird.run(downSound)
                            said = true
                        }
                    }
                }
                else{
                    pipes.removeFirst()
                    said = false
                }
            }
        }
        
    }
    
    func finishGame(){
        bird.isPaused = true
        self.isPaused = true
        self.view?.isPaused = true
        flappyBirdTimer.invalidate()
        physicsWorld.speed = 0
        resultsLbl.text = "You Lost!"
        scoreResultLbl.text = "score: \(time)"
        resultsLbl.isHidden = false
        scoreResultLbl.isHidden = false
        tryAgainButton.isHidden = false
    }
}
