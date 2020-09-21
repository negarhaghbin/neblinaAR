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

enum Movement{
    case up
    case down
    case right
    case left
    case none
}

class GameScene: SKScene {
    
    var blocks :[SKSpriteNode] = [SKSpriteNode]()
    var ball = SKSpriteNode()
    var scoreLbl = SKLabelNode()
    var resultsLbl = SKLabelNode()
    var scoreResultsLbl = SKLabelNode()
    let nextLevelButton = SKButton()
    let addImpulseButton = SKButton()
    var said = false
    let leftSound = SKAction.playSoundFileNamed("left.mp3", waitForCompletion: true)
    let rightSound = SKAction.playSoundFileNamed("right.mp3", waitForCompletion: true)
    
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
            if (ball.physicsBody?.velocity.dx)! > 0{
                ball.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 0))
            }
            else{
                ball.physicsBody?.applyImpulse(CGVector(dx: -5, dy: 0))
            }
        }
        else{
            if (ball.physicsBody?.velocity.dy)! > 0 {
                ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 5))
            }
            else{
                ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -5))
            }
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
    
    private func rayCast(start: CGPoint, direction: CGVector) -> (destination:CGPoint, normal: CGVector)? {
        let endVector = CGVector(
            dx: start.x + direction.normalized().dx * 4000,
            dy: start.y + direction.normalized().dy * 4000
        )

        let endPoint = CGPoint(x: endVector.dx, y: endVector.dy)

        var closestPoint: CGPoint?
        var normal: CGVector?

        physicsWorld.enumerateBodies(alongRayStart: start, end: endPoint) {
            (physicsBody:SKPhysicsBody,
            point:CGPoint,
            normalVector:CGVector,
            stop:UnsafeMutablePointer<ObjCBool>) in

            guard start.distanceTo(point) > 1 else {
                return
            }

            guard let newClosestPoint = closestPoint else {
                closestPoint = point
                normal = normalVector
                return
            }

            guard start.distanceTo(point) < start.distanceTo(newClosestPoint) else {
                return
            }

            normal = normalVector
        }
        guard let p = closestPoint, let n = normal else { return nil }
        return (p, n)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if ball.position.y < player.position.y - player.size.height / 2{
            finishGame(result: "You Lost!")
        }
        if (ball.physicsBody?.velocity.dy)! > 0{
            said = false
        }
        if ((ball.physicsBody?.velocity.dy)! < 0) && !said{
            guard let collision = rayCast(start: ball.position, direction: ball.physicsBody!.velocity.normalized()) else { return }
            if collision.destination.y < player.position.y {
                if paddleMovement(point: collision.destination) == .left{
                    ball.run(leftSound)
                }
                else if paddleMovement(point: collision.destination) == .right{
                    ball.run(rightSound)
                }
                said = true
            }
        }
        
    }
    
    func paddleMovement(point: CGPoint)->Movement{
        if point.x < (player.position.x - (player.size.width / 2)){
            return .left
        }
        else if point.x > (player.position.x + (player.size.width / 2)){
            return .right
        }
        else{
            return .none
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
