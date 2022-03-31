//
//  GameScene.swift
//  JurassicDodge
//
//  Created by Alessandro Colantonio on 30/03/22.
//

import SpriteKit
import GameplayKit
import SwiftUI

struct PhysicsCategory {
    static let none : UInt32 = 0
    static let all : UInt32 = UInt32.max
    static let player : UInt32 = 0b1
    static let meteor : UInt32 = 0b10
    static let ground : UInt32 = 0b100
    static let powerup : UInt32 = 0b1000
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    /**
     * # The Game Logic
     *     The game logic keeps track of the game variables
     *   you can use it to display information on the SwiftUI view,
     *   for example, and comunicate with the Game Scene.
     **/
    
    var gameLogic: GameLogic = GameLogic.shared
    
    var bg: SKSpriteNode!
    var ground: SKNode!
    
//    var player: SKSpriteNode!
    var player: PlayerClass!
    var playerSize = 100.0
    
    var healthPoints: [SKSpriteNode] = [SKSpriteNode(imageNamed: "heart"), SKSpriteNode(imageNamed: "heart"), SKSpriteNode(imageNamed: "heart")]
    
    var isMovingToTheRight: Bool = false
    var isMovingToTheLeft: Bool = false
    
    var entitieszPos = 10.0
    var bgzPos = 0.0
    
    // Keeps track of when the last update happend.
    // Used to calculate how much time has passed between updates.
    var lastUpdate: TimeInterval = 0
    
    override func didMove(to view: SKView) {
        self.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

        self.setUpGame()
        self.setUpPhysicsWorld()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if isMovingToTheRight {
            self.moveRight()
        }
        
        if isMovingToTheLeft {
            self.moveLeft()
        }
    }
}
// MARK: - GAME SET UP
extension GameScene {
    
    private func setUpGame() {
        self.gameLogic.setUpGame()
        self.createBackground()
        self.createGround()
        self.createPlayer(initPos: CGPoint(x: 0, y: 0))
        self.startMeteorsCycle()
        self.setLifes()
    }
    
    private func setUpPhysicsWorld() {
        physicsWorld.gravity = CGVector(dx: 0, dy: -0.9)
        
        physicsWorld.contactDelegate = self
    }
    
    private func createBackground() {
        bg = SKSpriteNode(imageNamed: "background")
        bg.name = "background"
        bg.position = CGPoint(x: 0, y: 30)
        bg.size.width *= 2
        bg.size.height *= 2
        bg.zPosition = bgzPos
        
        addChild(bg)
    }
    
    private func createGround() {
        ground = SKNode()
        ground.position = CGPoint(x: 0, y: -UIScreen.main.bounds.height/2)
        ground.zPosition = entitieszPos
        
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: UIScreen.main.bounds.width, height: bg.size.height * 0.1))
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.isDynamic = false
        
        ground.physicsBody?.categoryBitMask = PhysicsCategory.ground
        
        ground.physicsBody?.contactTestBitMask = PhysicsCategory.player
        
        addChild(ground)
    }
    
    private func createPlayer(initPos: CGPoint) {
        player = PlayerClass(imageNamed: "dino-front")
        player.name = "player"
        player.position = initPos
        player.size.width = playerSize
        player.size.height = playerSize
        player.zPosition = entitieszPos
        
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: playerSize, height: playerSize))
        player.physicsBody?.affectedByGravity = true
        player.physicsBody?.categoryBitMask = PhysicsCategory.player
        
        player.physicsBody?.contactTestBitMask = PhysicsCategory.ground
        
        player.speed = 8
        
        let xRange = SKRange(lowerLimit: -frame.width, upperLimit: frame.width)
        let xConstraint = SKConstraint.positionX(xRange)
        self.player.constraints = [xConstraint]
        
        addChild(player)
    }
    
    func startMeteorsCycle() {
        let createMeteorAction = SKAction.run(createMeteor)
        let waitAction = SKAction.wait(forDuration: 2.0)
        
        let createAndWaitAction = SKAction.sequence([createMeteorAction, waitAction])
        let meteorCycleAction = SKAction.repeatForever(createAndWaitAction)
        
        run(meteorCycleAction)
    }
    
    private func setLifes() {
        let initPos = CGPoint(x: -self.size.width*0.40, y: self.size.height*0.40)
        
        for i in 0...2 {
            healthPoints[i].name = "heart"
            healthPoints[i].size.width = 80.0
            healthPoints[i].size.height = 80.0
            healthPoints[i].position.x = initPos.x + CGFloat(70*i)
            healthPoints[i].position.y = initPos.y
            healthPoints[i].zPosition = entitieszPos
            
            addChild(healthPoints[i])
        }
    }
}

// MARK: - Player Movement
extension GameScene {
    private func moveLeft() {
        
        let action = SKAction.move(to: CGPoint(x: -UIScreen.main.bounds.maxX, y: self.player.position.y), duration: getDuration(pointA: self.player.position, pointB: CGPoint(x: -UIScreen.main.bounds.maxX, y: self.player.position.y), speed: self.player.speed))
        self.player.walkLeftAnimation()
        self.player.run(action, withKey: "move-left")

        print("Moving Left: \(player.physicsBody!.velocity)")
    }
    
    private func moveRight() {
        
        let action = SKAction.move(to: CGPoint(x: UIScreen.main.bounds.maxX, y: self.player.position.y), duration: getDuration(pointA: self.player.position, pointB: CGPoint(x: UIScreen.main.bounds.maxX, y: self.player.position.y), speed: self.player.speed))
        self.player.walkRightAnimation()
        self.player.run(action, withKey: "move-right")
        
        print("Moving Right: \(player.physicsBody!.velocity)")
    }
}

// MARK: - Handle Player Inputs
extension GameScene {
    
    enum SideOfTheScreen {
        case right, left
    }
    
    private func getDuration(pointA:CGPoint,pointB:CGPoint,speed:CGFloat)->TimeInterval {
        let xDist = (pointB.x - pointA.x)
        let yDist = (pointB.y - pointA.y)
        let distance = sqrt((xDist * xDist) + (yDist * yDist));
        let duration : TimeInterval = TimeInterval(distance/speed)
        return duration
    }
    
    private func sideTouched(for position: CGPoint) -> SideOfTheScreen {
        if position.x < 0 {
            return .left
        } else {
            return .right
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            guard let touch = touches.first else { return }
            let touchLocation = touch.location(in: self)
            
            switch sideTouched(for: touchLocation) {
            case .right:
                self.isMovingToTheRight = true
                print("ℹ️ Touching the RIGHT side.")
            case .left:
                self.isMovingToTheLeft = true
                print("ℹ️ Touching the LEFT side.")
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isMovingToTheRight = false
//        self.player.removeAction(forKey: "move-left")
        self.isMovingToTheLeft = false
//        self.player.removeAction(forKey: "move-right")
    }
    
}

// MARK: - Meteors
extension GameScene {
    
    private func createMeteor() {
        let meteorPosition = self.randomMeteorPosition()
        newMeteor(at: meteorPosition)
    }
    
    private func randomMeteorPosition() -> CGPoint {
        let initialX: CGFloat = -self.frame.width * 0.45
        let finalX: CGFloat = self.frame.width * 0.45
        
        let positionX = CGFloat.random(in: initialX...finalX)
        let positionY = UIScreen.main.bounds.maxY
        
        return CGPoint(x: positionX, y: positionY)
    }
    
    private func newMeteor(at position: CGPoint) {
        let newMeteor = SKSpriteNode(imageNamed: "enemy-meteor")
        newMeteor.name = "asteroid"
        newMeteor.position = position
        newMeteor.zPosition = entitieszPos
        
        newMeteor.physicsBody = SKPhysicsBody(circleOfRadius: 25.0)
        newMeteor.physicsBody?.affectedByGravity = true
        
        newMeteor.physicsBody?.categoryBitMask = PhysicsCategory.meteor
        
        newMeteor.physicsBody?.contactTestBitMask = PhysicsCategory.player
        newMeteor.physicsBody?.collisionBitMask = PhysicsCategory.ground
        
        addChild(newMeteor)
        
        newMeteor.run(SKAction.sequence([
            SKAction.wait(forDuration: 5.0),
            SKAction.removeFromParent()
        ]))
    }
    
}
