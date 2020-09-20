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
var currentLevel = LevelSceneNames.level1.rawValue

class GameScene: SKScene {
    
    var blocks :[SKSpriteNode] = [SKSpriteNode]()
    var ball = SKSpriteNode()
    var scoreLbl = SKLabelNode()
    var resultsLbl = SKLabelNode()
    var scoreResultsLbl = SKLabelNode()
    let nextLevelButton = SKButton()
    let addImpulseButton = SKButton()
    
    override func didMove(to view: SKView) {
        startGame()
        
        createPaddle()
        
        let blockChildren = self.children.filter({$0.name == "block"})
        for block in blockChildren{
            block.physicsBody?.contactTestBitMask = block.physicsBody?.collisionBitMask ?? 0
            blocks.append(block as! SKSpriteNode)
        }
        
        createBall(blockChildren: blockChildren)
        scoreLbl = self.childNode(withName: "scoreLabel") as! SKLabelNode
        scoreLbl.position = CGPoint(x: (-self.frame.width/2) + 50, y: (self.frame.height/2) - 100)
        createResultLabels()
        createNextLevelButton()
        createAddImpulseButton()
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        self.physicsBody = border
        
        physicsWorld.contactDelegate = self
    }
    
    func createPaddle(){
        player = self.childNode(withName: "slider") as! SKSpriteNode
        player.position.y = (-self.frame.height/2) + 100
        player.size.width = CGFloat(BreakoutSettings.get().paddleWidth) * player.size.width
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.pinned = false
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.isDynamic = false
        player.physicsBody?.friction = 0
        player.physicsBody?.restitution = 0
        player.physicsBody?.categoryBitMask = 1
        player.physicsBody?.collisionBitMask = 2
        player.physicsBody?.contactTestBitMask = 2
    }
    
    func createBall(blockChildren: [SKNode]){
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
        let speedMultiplier = BreakoutSettings.get().speed
        ball.physicsBody?.applyImpulse(CGVector(dx: speedMultiplier * 22, dy: speedMultiplier * -22))
        var blocks_by_lowest_y = blockChildren
        blocks_by_lowest_y = blocks_by_lowest_y.sorted(by: {$0.position.y < $1.position.y})
        ball.position = CGPoint(x: 0, y: blocks_by_lowest_y[0].position.y - blocks[0].size.height)
    }
    
    func createResultLabels(){
        resultsLbl = self.childNode(withName: "resultsLabel") as! SKLabelNode
        resultsLbl.position = CGPoint(x: 0, y: 100)
        resultsLbl.isHidden = true
        
        scoreResultsLbl = self.childNode(withName: "scoreResult") as! SKLabelNode
        scoreResultsLbl.position = CGPoint(x: 0, y: 0)
        scoreResultsLbl.isHidden = true
    }
    
    func createNextLevelButton(){
        nextLevelButton.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(GameScene.goNextLevel))
        nextLevelButton.setButtonLabel(title: "Next Level", font: "ARCADECLASSIC", fontSize: 30)
        nextLevelButton.color = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        nextLevelButton.label.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        nextLevelButton.position = CGPoint(x: scoreResultsLbl.position.x,y: scoreResultsLbl.position.y - 2*scoreResultsLbl.frame.height)
        nextLevelButton.zPosition = 1
        nextLevelButton.name = "nextLevelButton"
        nextLevelButton.isHidden = true
        self.addChild(nextLevelButton)
    }
    
    func createAddImpulseButton(){
        addImpulseButton.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(GameScene.addImpulse))
        addImpulseButton.setButtonLabel(title: "Shake", font: "ARCADECLASSIC", fontSize: 25)
        addImpulseButton.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        addImpulseButton.position = CGPoint(x: (self.frame.width/2) - 50, y: (self.frame.height/2) - 75)
        addImpulseButton.zPosition = 1
        addImpulseButton.name = "addImpulseButton"
        self.addChild(addImpulseButton)
    }
    
    func nextLevel()->String{
        var level = getLevel()
        level = level + 1
        return "BOLevel\(level)"
    }
    
    func getLevel()->Int{
        return Int(String(currentLevel.last!))!
    }
  
    @objc func goNextLevel() {
        var scene = SKScene()
        switch nextLevelButton.label.text {
        case "Next Level":
            scene = GameScene(fileNamed:nextLevel())!
            break
        case "Try Again":
            scene = GameScene(fileNamed:currentLevel)!
        default:
            break
        }
        self.view?.presentScene(scene)
    }
    
    @objc func addImpulse() {
        if (abs((ball.physicsBody?.velocity.dx)!) < abs((ball.physicsBody?.velocity.dy)!)){
            ball.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 0))
        }
        else{
            ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 5))
        }
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
        if ball.position.y < player.position.y - player.size.height / 2{
            finishGame(result: "You Lost!")
        }
    }
    
    func finishGame(result: String){
        ball.isPaused = true
        player.isPaused = true
        physicsWorld.speed = 0
        resultsLbl.text = result
        resultsLbl.isHidden = false
        scoreResultsLbl.text = "Score: \(score)"
        scoreResultsLbl.isHidden = false
        if result == "You Lost!"{
            nextLevelButton.isHidden = false
            nextLevelButton.label.text = "Try Again"
        }
        else{
            if currentLevel != LevelSceneNames.level6.rawValue{
                nextLevelButton.isHidden = false
                nextLevelButton.label.text = "Next Level"
            }
        }
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
