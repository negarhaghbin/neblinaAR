//
//  GameScene.swift
//  neblinaAR
//
//  Created by Negar on 2020-03-14.
//  Copyright © 2020 Negar. All rights reserved.
//

import SpriteKit
import GameplayKit

var player = SKSpriteNode()
var score = 0

class GameScene: SKScene {
    
    var blocks :[SKSpriteNode] = [SKSpriteNode]()
    var ball = SKSpriteNode()
    var scoreLbl = SKLabelNode()
    var resultsLbl = SKLabelNode()
    
    override func didMove(to view: SKView) {
        startGame()
        
        player = self.childNode(withName: "slider") as! SKSpriteNode
        player.position.y = (-self.frame.height/2) + 100
        
        let blockChildren = self.children.filter({$0.name == "block"})
        for block in blockChildren{
            block.physicsBody?.contactTestBitMask = block.physicsBody?.collisionBitMask ?? 0
            //block.position.y = (self.frame.height/2) - 100
            blocks.append(block as! SKSpriteNode)
        }
        
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
        ball.physicsBody?.applyImpulse(CGVector(dx: 20, dy: -20))
        var blocks_by_lowest_y = blockChildren
        blocks_by_lowest_y = blocks_by_lowest_y.sorted(by: {$0.position.y < $1.position.y})
        ball.position = CGPoint(x: 0, y: blocks_by_lowest_y[0].position.y - blocks[0].size.height)
        
        scoreLbl = self.childNode(withName: "scoreLabel") as! SKLabelNode
        scoreLbl.position = CGPoint(x: (-self.frame.width/2) + 50, y: (self.frame.height/2) - 100)
        
        resultsLbl = self.childNode(withName: "resultsLabel") as! SKLabelNode
        resultsLbl.position = CGPoint(x: 0, y: 0)
        resultsLbl.isHidden = true
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        self.physicsBody = border
        
        physicsWorld.contactDelegate = self
    }
  
  
    func startGame(){
        score = 0
        scoreLbl.text = "\(score)"
        ball.isPaused = true
        physicsWorld.speed = 0
        
        var runCount = 3
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.resultsLbl.isHidden = false
            self.resultsLbl.text = "\(runCount)"
            if runCount == 0{
                self.resultsLbl.text = "Go!"
            }
            if runCount == -1 {
                self.resultsLbl.isHidden = true
                self.ball.isPaused = false
                self.physicsWorld.speed = 1.0
                timer.invalidate()
            }
            runCount -= 1
        }
    }
    
  
    func ballDidCollideWithBlock(ball: SKSpriteNode, block: SKSpriteNode) {
        print("Hit")
        block.removeFromParent()
    
        score += 1
        scoreLbl.text = "\(score)"
        if score == blocks.count {
            finishGame(result: "You Won!")
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if ball.position.y < player.position.y{
            finishGame(result: "You Lose!")
        }
    }
    
    func finishGame(result: String){
        ball.isPaused = true
        player.isPaused = true
        physicsWorld.speed = 0
        resultsLbl.text = result
        resultsLbl.isHidden = false
    }
}

extension GameScene: SKPhysicsContactDelegate {
  func didBegin(_ contact: SKPhysicsContact) {
    guard let nodeA = contact.bodyA.node else { return }
    guard let nodeB = contact.bodyB.node else { return }
    
    if contact.bodyA.categoryBitMask == ball.physicsBody?.categoryBitMask{
        ballDidCollideWithBlock(ball: nodeA as! SKSpriteNode, block: nodeB as! SKSpriteNode)
    }
    // 3 is category bit mask for block
    else if contact.bodyA.categoryBitMask == 3{
        ballDidCollideWithBlock(ball: nodeB as! SKSpriteNode, block: nodeA as! SKSpriteNode)
    }
  }
}
