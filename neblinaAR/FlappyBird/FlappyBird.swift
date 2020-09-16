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

class FlappyBird: SKScene, SKPhysicsContactDelegate {
    var resultsLbl = SKLabelNode()
    var scoreLbl = SKLabelNode()
    let tryAgainButton = SKButton()
    
    override func didMove(to view: SKView) {
      bird = self.childNode(withName: "bird") as! SKSpriteNode
      bird.position = CGPoint(x: 0, y: 0)
        
      resultsLbl = self.childNode(withName: "resultsLabel") as! SKLabelNode
      resultsLbl.position = CGPoint(x: 0, y: 0)
      resultsLbl.zPosition = 3
      resultsLbl.isHidden = true
        
      scoreLbl = self.childNode(withName: "scoreLabel") as! SKLabelNode
        
      tryAgainButton.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(FlappyBird.tryAgain))
      tryAgainButton.setButtonLabel(title: "Try Again", font: "ARCADECLASSIC", fontSize: 30)
      tryAgainButton.color = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
      tryAgainButton.position = CGPoint(x: resultsLbl.position.x,y: resultsLbl.position.y - 2*resultsLbl.frame.height)
      tryAgainButton.zPosition = 3
      tryAgainButton.name = "nextLevelButton"
      tryAgainButton.isHidden = true
      self.addChild(tryAgainButton)
      
      physicsWorld.gravity = .zero
      physicsWorld.contactDelegate = self
      
        _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            time += 1
            self.scoreLbl.text = "\(time)"
      }
      
      run(SKAction.repeatForever(
        SKAction.sequence([
          SKAction.run(addPipe),
          SKAction.wait(forDuration: 1.0)
          ])
      ))
      
//      let backgroundMusic = SKAudioNode(fileNamed: "background.mp3")
//      backgroundMusic.autoplayLooped = true
//      addChild(backgroundMusic)
        
//        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
//        border.friction = 0
//        border.restitution = 0
//        self.physicsBody = border
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
        let pipe = SKSpriteNode(imageNamed: "pipe")
        let upOrDown = Int.random(in: 0...1)
        var actualY = CGFloat()
        if upOrDown == 0{
            pipe.texture = SKTexture(imageNamed: "flippedPipe")
            actualY = random(min: size.height/2 - pipe.size.height/2, max: size.height/2)
            pipe.position = CGPoint(x: size.width + pipe.size.width/2, y: actualY)
        }
        else{
            actualY = random(min: -size.height/2, max: -size.height/2 + pipe.size.height/2)
            pipe.position = CGPoint(x: size.width + pipe.size.width/2, y: actualY)
        }
        pipe.physicsBody = SKPhysicsBody(rectangleOf: pipe.size)
        pipe.physicsBody?.isDynamic = false
        pipe.physicsBody?.categoryBitMask = PhysicsCategory.pipe.rawValue
        pipe.physicsBody?.contactTestBitMask = PhysicsCategory.bird.rawValue
        pipe.physicsBody?.collisionBitMask = PhysicsCategory.bird.rawValue
        pipe.zPosition = 2
        
        addChild(pipe)
      
//        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        let actualDuration = CGFloat(4.0)
      
        let actionMove = SKAction.move(to: CGPoint(x: -size.width/2-pipe.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
      let actionMoveDone = SKAction.removeFromParent()
//      let loseAction = SKAction.run() { [weak self] in
////        guard let `self` = self else { return }
////        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
////        let gameOverScene = GameOverScene(size: self.size, won: false)
////        self.view?.presentScene(gameOverScene, transition: reveal)
//      }
      pipe.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    override func update(_ currentTime: TimeInterval) {
        if bird.position.x < -size.width/2 {
             finishGame()
        }
    }
    
    func finishGame(){
        bird.isPaused = true
        self.isPaused = true
        self.view?.isPaused = true
        physicsWorld.speed = 0
        resultsLbl.text = "You Lost!"
        resultsLbl.isHidden = false
        tryAgainButton.isHidden = false
    }
}
