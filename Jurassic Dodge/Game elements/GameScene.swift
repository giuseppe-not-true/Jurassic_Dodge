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
    static let powerUp : UInt32 = 0b1000
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
        
        if self.player.lifes < 3 {
            switch(self.player.lifes) {
            case 0:
                healthPoints[0].run(.fadeOut(withDuration: 0.2))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.healthPoints[0].removeFromParent()
                }
                break
            case 1:
                healthPoints[1].run(.fadeOut(withDuration: 0.2))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.healthPoints[1].removeFromParent()
                }
                break
            case 2:
                healthPoints[2].run(.fadeOut(withDuration: 0.2))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.healthPoints[2].removeFromParent()
                }
                break
            default:
                break
            }
        }
        
    }
}
// MARK: - GAME SET UP
extension GameScene {
    
    private func setUpGame() {
        self.gameLogic.setUpGame()
        self.createBackground()
        self.createGround()
        self.createPlayer(initPos: CGPoint(x: 0, y: -150))
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
        ground.name = "ground"
        ground.position = CGPoint(x: 0, y: -UIScreen.main.bounds.height/2)
        ground.zPosition = entitieszPos
        
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: UIScreen.main.bounds.width, height: bg.size.height * 0.2))
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.isDynamic = false
        
        ground.physicsBody?.categoryBitMask = PhysicsCategory.ground
        
        ground.physicsBody?.contactTestBitMask = PhysicsCategory.meteor
        
        addChild(ground)
    }
    
    private func createPlayer(initPos: CGPoint) {
        player = PlayerClass(imageNamed: "dino-front")
        player.name = "player"
        player.position = initPos
        player.size.width = playerSize
        player.size.height = playerSize
        player.zPosition = entitieszPos
        
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: playerSize/2.5, height: playerSize/2.5))
        player.physicsBody?.affectedByGravity = true
        player.physicsBody?.categoryBitMask = PhysicsCategory.player
        
        player.physicsBody?.contactTestBitMask = PhysicsCategory.meteor
        player.physicsBody?.collisionBitMask = PhysicsCategory.ground
        
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
        
        for i in 0...self.player.lifes-1 {
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
        
        return CGPoint(x: 0, y: positionY)
    }
    
    private func newMeteor(at position: CGPoint) {
        let newMeteor = SKSpriteNode(imageNamed: "enemy-meteor")
        newMeteor.name = "meteor"
        newMeteor.position = position
        newMeteor.zPosition = entitieszPos
        
        newMeteor.physicsBody = SKPhysicsBody(circleOfRadius: newMeteor.size.width/2.5)
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

// MARK: - Contacts and Collisions
extension GameScene {
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("Contact happened!")
        let firstBody: SKPhysicsBody = contact.bodyA
        let secondBody: SKPhysicsBody = contact.bodyB

        if let node = firstBody.node, node.name == "meteor" {
            if let ground = firstBody.node, ground.name == "ground" {
                let tempNode = MeteorClass()
                
                tempNode.randomPowerUp()
                if tempNode.powerUpName != "none" {
                    newPowerUp(at: CGPoint(x: node.position.x, y: self.player.position.y), powerUpName: tempNode.powerUpName)
                }
                
                node.removeFromParent()
            }
            
            if let player = secondBody.node, player.name == "player" {
                if self.player.lifes > 0 {
                    self.player.lifes -= 1
                }
                
                node.removeFromParent()
            }
            
            if let player = firstBody.node, player.name == "player" {
                if let powerUp = secondBody.node, powerUp.name == "power-up" {
                    powerUp.removeFromParent()
//                    switch(powerUp.powerUpType) {
//                    case .heart:
//                        print("nice")
//                        break
//                    case .armor:
//                        print("nice")
//                        break
//                    case .mango:
//                        print("nice")
//                        break
//                    default:
//                        break
//                    }
                }
            }
            
        }
        
        if let node = secondBody.node, node.name == "meteor" {
            if let ground = firstBody.node, ground.name == "ground" {
                let tempNode = MeteorClass()
                
                tempNode.randomPowerUp()
                if tempNode.powerUpName != "none" {
                    newPowerUp(at: CGPoint(x: node.position.x, y: self.player.position.y), powerUpName: tempNode.powerUpName)
                }
                node.removeFromParent()
            }
            
            if let player = firstBody.node, player.name == "player" {
                if self.player.lifes > 0 {
                    self.player.lifes -= 1
                }
                
                node.removeFromParent()
            }
            
        }
        
        if let player = secondBody.node, player.name == "player" {
            if let powerUp = firstBody.node, powerUp.name == "power-up" {
                powerUp.removeFromParent()
//                switch(powerUp.powerUpType) {
//                case .heart:
//                    print("nice")
//                    break
//                case .armor:
//                    print("nice")
//                    break
//                case .mango:
//                    print("nice")
//                    break
//                default:
//                    break
//                }
            }
        }
    }
    
}

//MARK: - Power Up

extension GameScene {
    private func newPowerUp(at position: CGPoint, powerUpName: String) {
        let powerUp = PowerUpClass()

        let newTexture = SKTexture(imageNamed: "power-up-\(powerUpName)")
        let changeTexture = SKAction.setTexture(newTexture, resize: true)
        powerUp.run(changeTexture)
        powerUp.name = "power-up"
        
        switch(powerUpName) {
        case "heart":
            powerUp.powerUpType = .heart
            break
        case "armor":
            powerUp.powerUpType = .armor
            break
        case "mango":
            powerUp.powerUpType = .mango
            break
        default:
            powerUp.powerUpType = .none
            break
        }
        
        powerUp.position = position
        powerUp.zPosition = entitieszPos
        
        powerUp.physicsBody = SKPhysicsBody(circleOfRadius: newTexture.size().width/4)
        powerUp.physicsBody?.affectedByGravity = true
        
        powerUp.physicsBody?.categoryBitMask = PhysicsCategory.powerUp
        
        powerUp.physicsBody?.contactTestBitMask = PhysicsCategory.player
        powerUp.physicsBody?.collisionBitMask = PhysicsCategory.ground
        
        addChild(powerUp)

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            powerUp.removeFromParent()
        }
        
    }
}
