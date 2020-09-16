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
class FlappyBird: SKScene, SKPhysicsContactDelegate {
    var time = 0
    
    override func didMove(to view: SKView) {
      bird = self.childNode(withName: "bird") as! SKSpriteNode
      bird.position = CGPoint(x: 0, y: 0)
      
      physicsWorld.gravity = .zero
      physicsWorld.contactDelegate = self
      
      run(SKAction.repeatForever(
        SKAction.sequence([
          SKAction.run(addPipe),
          SKAction.wait(forDuration: 1.0)
          ])
      ))
      
//      let backgroundMusic = SKAudioNode(fileNamed: "background.mp3")
//      backgroundMusic.autoplayLooped = true
//      addChild(backgroundMusic)
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        self.physicsBody = border
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
        
        addChild(pipe)
      
//        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        let actualDuration = CGFloat(4.0)
      
      let actionMove = SKAction.move(to: CGPoint(x: -size.width/2, y: actualY), duration: TimeInterval(actualDuration))
      //let actionMoveDone = SKAction.removeFromParent()
//      let loseAction = SKAction.run() { [weak self] in
////        guard let `self` = self else { return }
////        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
////        let gameOverScene = GameOverScene(size: self.size, won: false)
////        self.view?.presentScene(gameOverScene, transition: reveal)
//      }
      pipe.run(SKAction.sequence([actionMove]))
    }
    
    func birdDidCollideWithPipe(bird: SKSpriteNode, pipe: SKSpriteNode) {
        if bird.position.x == -size.width/2{
           print("lost")
      }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
      var firstBody: SKPhysicsBody
      var secondBody: SKPhysicsBody
      if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
        firstBody = contact.bodyA
        secondBody = contact.bodyB
      } else {
        firstBody = contact.bodyB
        secondBody = contact.bodyA
      }
      
      // 2
        if ((firstBody.categoryBitMask == PhysicsCategory.pipe.rawValue ) &&
            (secondBody.categoryBitMask == PhysicsCategory.bird.rawValue )) {
        if let pipe = firstBody.node as? SKSpriteNode,
          let bird = secondBody.node as? SKSpriteNode {
          birdDidCollideWithPipe(bird: bird, pipe: pipe)
        }
      }
    }
}
