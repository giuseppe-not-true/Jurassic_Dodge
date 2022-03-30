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
    var ground: SKShapeNode!
    
    var player: SKSpriteNode!
    var playerSize = 100.0
    
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
//        let initPos = CGPoint(x: 0, y: -218)
        self.createBackground()
        self.createGround()
        self.createPlayer(initPos: CGPoint(x: 0, y: 0))
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
        let groundX = -frame.width / 2
        let groundY = -frame.height / 2
        let groundHeight = groundY - 100
        
        ground = SKShapeNode(rect: CGRect(x: groundX, y: groundY, width: bg.size.height * 2, height: 80))
        ground.zPosition = entitieszPos
//        ground.alpha = 0
        
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: groundX, height: groundHeight))
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.categoryBitMask = PhysicsCategory.ground
        
        ground.physicsBody?.contactTestBitMask = PhysicsCategory.player
        
        addChild(ground)
    }
    
    private func createPlayer(initPos: CGPoint) {
        player = SKSpriteNode(imageNamed: "dino-front")
        player.name = "player"
        player.position = initPos
        player.size.width = playerSize
        player.size.height = playerSize
        player.zPosition = entitieszPos
        
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: playerSize, height: playerSize))
        player.physicsBody?.affectedByGravity = true
        player.physicsBody?.categoryBitMask = PhysicsCategory.player
        
        player.physicsBody?.contactTestBitMask = PhysicsCategory.ground
        
        let xRange = SKRange(lowerLimit: 0, upperLimit: frame.width)
        let xConstraint = SKConstraint.positionX(xRange)
        self.player.constraints = [xConstraint]
        
        addChild(player)
    }
}

// MARK: - Player Movement
extension GameScene {
    private func moveLeft() {
        self.player.physicsBody?
            .applyForce(CGVector(dx: 5, dy: 0))
//        let action = SKAction.move(to: CGPoint(x: 100.0, y: 0.0), duration: 1)
//        self.player.run(action)
        
        print("Moving Left: \(player.physicsBody!.velocity)")
    }
    
    private func moveRight() {
        self.player.physicsBody?
            .applyForce(CGVector(dx: -5, dy: 0))
        
        print("Moving Right: \(player.physicsBody!.velocity)")
    }
}

// MARK: - Handle Player Inputs
extension GameScene {
    
    enum SideOfTheScreen {
        case right, left
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
        self.isMovingToTheLeft = false
    }
    
}
