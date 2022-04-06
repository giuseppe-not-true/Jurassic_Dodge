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
    
    @ObservedObject var gameLogic: GameLogic = GameLogic.shared
    
    var waitAction = SKAction()
    var meteorCycleAction = SKAction()
    var bg: SKSpriteNode!
    var ground: SKNode!
    
    var player: PlayerClass!
    var playerSize = 100.0
    
    var score: SKLabelNode!
    
    var healthPoints: [SKSpriteNode] = [SKSpriteNode(imageNamed: "heart"), SKSpriteNode(imageNamed: "heart"), SKSpriteNode(imageNamed: "heart")]
    
    var isMovingToTheRight: Bool = false
    var isMovingToTheLeft: Bool = false
    //var arrivedAtDestination: Bool = false
    
    var entitieszPos = 10.0
    var UIzPos = 11.0
    var bgzPos = 0.0
    
    // Keeps track of when the last update happend.
    // Used to calculate how much time has passed between updates.
    var lastUpdate: TimeInterval = 0
    var spawnTime = 2.0
    var counter = 0
    
    var cam = SKCameraNode()
    
    let backgroundMusic = SKAudioNode(fileNamed: "meteor shower.wav")
    let meteorSound = SKAction.playSoundFileNamed("meteor.wav", waitForCompletion: true)
    let hitSound = SKAction.playSoundFileNamed("roger-hit.wav", waitForCompletion: true)
    let armorSound = SKAction.playSoundFileNamed("armor.mp3", waitForCompletion: true)
    let mangoSound = SKAction.playSoundFileNamed("mango.wav", waitForCompletion: true)
    let healthSound = SKAction.playSoundFileNamed("health.wav", waitForCompletion: true)
    
    override func didMove(to view: SKView) {
        self.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        self.setUpGame()
        self.setUpPhysicsWorld()
        cam.position = CGPoint(x: bg.position.x , y: bg.position.y )
        addChild(cam)
        self.camera = cam


    }
    
    override func update(_ currentTime: TimeInterval) {
        if isMovingToTheRight {
            self.moveRight()
        }
        
        if isMovingToTheLeft {
            self.moveLeft()
        }
        
//        if arrivedAtDestination {
//            self.stop()
//        }
        
        if (self.gameLogic.currentScore < 50) {
            if counter >= 5 {
                counter -= 5
                
                if spawnTime > 0.3 {
                    spawnTime -= 0.2
                    updateMeteorsCycle()
                }
                
                if self.player.speed <= 20 {
                    self.player.speed += 0.75
                }
            }
        }
        else {
            if counter >= 25 {
                counter -= 25
                if spawnTime > 0.10005 {
                    spawnTime -= 0.001
                    updateMeteorsCycle()
                }
            }
        }
        
        if self.player.lives == 0 {
            self.gameLogic.finishTheGame()
        }
        
        if self.gameLogic.isGameOver {
            gameOverDisplay()
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
        self.setLives()
        self.setScore()
    }
    
    private func setUpPhysicsWorld() {
        physicsWorld.gravity = CGVector(dx: 0, dy: -0.9)
        
        physicsWorld.contactDelegate = self
    }
    
    private func createBackground() {
        bg = SKSpriteNode(imageNamed: "background")
        bg.name = "background"
//        bg.position = CGPoint(x: 500, y: 500)
        bg.size.width *= 1
        bg.size.height *= 1.1
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
        self.addChild(backgroundMusic)
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
        
        player.physicsBody?.contactTestBitMask = PhysicsCategory.meteor | PhysicsCategory.powerUp
        player.physicsBody?.collisionBitMask = PhysicsCategory.ground
        
        player.speed = 10
        
//        let xRange = SKRange(lowerLimit: -frame.width, upperLimit: frame.width)
//        let xConstraint = SKConstraint.positionX(xRange)
//        self.player.constraints = [xConstraint]
        
        addChild(player)
    }
    
    func startMeteorsCycle() {
        var createMeteorAction = SKAction.run(createMeteor)
        self.waitAction = SKAction.wait(forDuration: spawnTime)
        
        var createAndWaitAction = SKAction.sequence([createMeteorAction, waitAction])
        self.meteorCycleAction = SKAction.repeatForever(createAndWaitAction)
        
        run(self.meteorCycleAction, withKey: "MeteorCycle")
    }
    
    func updateMeteorsCycle() {
        removeAction(forKey: "MeteorCycle")
        var createMeteorAction = SKAction.run(createMeteor)
        self.waitAction = SKAction.wait(forDuration: spawnTime)
        var createAndWaitAction = SKAction.sequence([createMeteorAction, waitAction])
        self.meteorCycleAction = SKAction.repeatForever(createAndWaitAction)
        run(self.meteorCycleAction, withKey: "MeteorCycle")
    }
    
    private func setLives() {
        let initPos = CGPoint(x: -self.size.width*0.40, y: self.size.height*0.40)
        
        for i in 0...self.player.lives-1 {
            healthPoints[i].name = "heart"
            healthPoints[i].size.width = 80.0
            healthPoints[i].size.height = 80.0
            healthPoints[i].position.x = initPos.x + CGFloat(70*i)
            healthPoints[i].position.y = initPos.y
            healthPoints[i].zPosition = UIzPos
            
            addChild(healthPoints[i])
        }
    }
    
    private func setScore() {
        score = SKLabelNode(text: "Score: \(self.gameLogic.currentScore)")
        score.name = "score"
        score.fontName = "Minecraft"
        score.fontSize = 50
        score.fontColor = .white
        score.position = CGPoint(x: self.size.width*0.30, y: self.size.height*0.35)
        score.zPosition = UIzPos
        addChild(score)
    }
}

// MARK: - Player Movement
extension GameScene {
    private func moveLeft() {
        
        let action = SKAction.move(to: CGPoint(x: -self.frame.width*0.45, y: self.player.position.y), duration: getDuration(pointA: self.player.position, pointB: CGPoint(x: -self.frame.width*0.45, y: self.player.position.y), speed: self.player.speed))
        self.player.walkLeftAnimation()
        self.player.run(action, withKey: "move-left")

    }
    
    private func moveRight() {
        
        let action = SKAction.move(to: CGPoint(x: self.frame.width*0.45, y: self.player.position.y), duration: getDuration(pointA: self.player.position, pointB: CGPoint(x: self.frame.width*0.45, y: self.player.position.y), speed: self.player.speed))
        self.player.walkRightAnimation()
        self.player.run(action, withKey: "move-right")
        
    }
    
    private func stop() {
        
        self.player.removeAction(forKey: "move-right")
        self.player.removeAction(forKey: "move-left")
        self.player.idleAnimation()
        
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
        case .left:
            self.isMovingToTheLeft = true
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isMovingToTheRight = false
        self.isMovingToTheLeft = false
        
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
        
        var range = (self.player.speed * 5) * 2
        
        var adjleftX: CGFloat = 0
        var adjrightX: CGFloat = 0
        
        if(CGFloat(self.player.position.x) - (range / 2) <= initialX) {
            adjleftX = initialX
        }
        else {
            adjleftX = CGFloat(self.player.position.x) - (range / 2)
        }
        
        if(CGFloat(self.player.position.x) + (range / 2)  >= finalX) {
            adjrightX = finalX
        }
        else {
            adjrightX = CGFloat(self.player.position.x) + (range / 2)
        }
        
        var positionX = CGFloat.random(in: initialX...finalX)
        let positionY = UIScreen.main.bounds.maxY - 130
        
        if (Int.random(in: 1 ... 100) < 66) {
            positionX = CGFloat.random(in: adjleftX...adjrightX)
        }
        else {
            if (CGFloat(self.player.position.x) - (range / 2) <= initialX) {
                positionX = CGFloat.random(in: adjrightX...finalX)
            }
            if (CGFloat(self.player.position.x) + (range / 2)  >= finalX) {
                positionX = CGFloat.random(in: initialX...adjleftX)
            }
        }
        
//        return CGPoint(x: 0, y: positionY)
        return CGPoint(x: positionX, y: positionY)

    }
    
    private func newMeteor(at position: CGPoint) {
        let newMeteor = SKSpriteNode(imageNamed: "enemy-meteor")
        
        newMeteor.name = "meteor"
        newMeteor.speed = 0.1
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
        let firstBody: SKPhysicsBody = contact.bodyA
        let secondBody: SKPhysicsBody = contact.bodyB

        if let node = firstBody.node, node.name == "meteor" {
            if let ground = firstBody.node, ground.name == "ground" {
                self.gameLogic.score(points: 1)
                self.counter += 1
                self.score.text = "Score: \(self.gameLogic.currentScore)"
                let tempNode = MeteorClass()
                
                tempNode.randomPowerUp()
                if tempNode.powerUpName != "none" {
                    newPowerUp(at: CGPoint(x: node.position.x, y: self.player.position.y), powerUpName: tempNode.powerUpName)
                }
                
//                ground.run(meteorSound)
                node.removeFromParent()
            }
            
            if let player = secondBody.node, player.name == "player" {
                if self.player.hasArmor {
                    self.player.hasArmor = false
                    self.player.animationName = "dino"
                    self.player.updateWalkAnimations(powerUp: self.player.animationName)
                } else {
                    if self.player.lives > 0 {
                        updateLives(update: -1)
                    }
                }
                
                ground.run(hitSound)
                node.removeFromParent()
            }
            
        }
        
        if let node = secondBody.node, node.name == "meteor" {
            if let ground = firstBody.node, ground.name == "ground" {
                self.gameLogic.score(points: 1)
                self.counter += 1
                self.score.text = "Score: \(self.gameLogic.currentScore)"
                let tempNode = MeteorClass()
                
                tempNode.randomPowerUp()
                if tempNode.powerUpName != "none" {
                    newPowerUp(at: CGPoint(x: node.position.x, y: self.player.position.y), powerUpName: tempNode.powerUpName)
                }
                
//                ground.run(meteorSound)
                node.removeFromParent()
            }
            
            if let player = firstBody.node, player.name == "player" {
                if self.player.hasArmor {
                    self.player.hasArmor = false
                    self.player.animationName = "dino"
                    self.player.updateWalkAnimations(powerUp: self.player.animationName)
                } else {
                    if self.player.lives > 0 {
                        updateLives(update: -1)
                    }
                }
                
                ground.run(hitSound)
                node.removeFromParent()
            }
            
        }
                
        if let player = firstBody.node, player.name == "player" {
            if let powerUp = secondBody.node as? PowerUpClass, powerUp.name == "power-up" {
                    switch(powerUp.powerUpType) {
                    case .heart:
                        ground.run(healthSound)
                        if self.player.lives < 3 {
                            updateLives(update: 1)
                        } else {
                            self.gameLogic.score(points: 2)
                            self.counter += 2
                        }
                        break
                    case .armor:
                        ground.run(armorSound)
                        switch(self.player.hasArmor) {
                        case true:
                            self.gameLogic.score(points: 2)
                            self.counter += 2
                            self.score.text = "Score: \(self.gameLogic.currentScore)"
                            break
                        case false:
                            if self.player.hasMango{
                                self.player.animationName = "red-armor"
                                self.player.hasArmor = true
                                self.player.updateWalkAnimations(powerUp: self.player.animationName)
                                if isMovingToTheLeft {
                                    self.player.isMovingLeft = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        self.player.isMovingLeft = false
                                    }
                                } else if isMovingToTheRight {
                                    self.player.isMovingRight = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        self.player.isMovingRight = false
                                    }
                                }
                            } else {
                                self.player.animationName = "armor"
                                self.player.hasArmor = true
                                self.player.updateWalkAnimations(powerUp: self.player.animationName)
                                if isMovingToTheLeft {
                                    self.player.isMovingLeft = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        self.player.isMovingLeft = false
                                    }
                                } else if isMovingToTheRight {
                                    self.player.isMovingRight = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        self.player.isMovingRight = false
                                    }
                                }
                            }
                            break
                        default:
                            break
                        }
                        break
                    case .mango:
                        ground.run(mangoSound)
                        switch(self.player.hasMango) {
                        case true:
                            self.gameLogic.score(points: 2)
                            self.counter += 2
                            self.score.text = "Score: \(self.gameLogic.currentScore)"
                            break
                        case false:
                            if self.player.hasArmor {
                                self.player.animationName = "red-armor"
                                self.player.hasMango = true
                                self.player.updateWalkAnimations(powerUp: self.player.animationName)
                                if isMovingToTheLeft {
                                    self.player.isMovingLeft = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        self.player.isMovingLeft = false
                                    }
                                } else if isMovingToTheRight {
                                    self.player.isMovingRight = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        self.player.isMovingRight = false
                                    }
                                }
                                self.player.speed *= 1.5
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                    self.player.speed /= 1.5
                                    self.player.hasMango = false
                                    if self.player.hasArmor {
                                        self.player.animationName = "armor"
                                    } else {
                                        self.player.animationName = "dino"
                                    }
                                    self.player.updateWalkAnimations(powerUp: self.player.animationName)
                                }

                            } else {
                                self.player.animationName = "mango"
                                self.player.hasMango = true
                                self.player.updateWalkAnimations(powerUp: self.player.animationName)
                                if isMovingToTheLeft {
                                    self.player.isMovingLeft = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        self.player.isMovingLeft = false
                                    }
                                } else if isMovingToTheRight {
                                    self.player.isMovingRight = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        self.player.isMovingRight = false
                                    }
                                }
                                self.player.speed *= 1.5
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                    self.player.speed /= 1.5
                                    self.player.hasMango = false
                                    self.player.animationName = "dino"
                                    self.player.updateWalkAnimations(powerUp: self.player.animationName)
                                }
                            }
                            break
                        default:
                            break
                        }
                        break
                    default:
                        break
                    }
                
                powerUp.removeFromParent()
            }
        }
        
        if let player = secondBody.node, player.name == "player" {
            print("OK")
            if let powerUp = firstBody.node as? PowerUpClass, powerUp.name == "power-up" {
                switch(powerUp.powerUpType) {
                case .heart:
                    ground.run(healthSound)
                    if self.player.lives < 3 {
                        updateLives(update: 1)
                    } else {
                        self.gameLogic.score(points: 2)
                        self.counter += 2
                    }
                    break
                case .armor:
                    ground.run(armorSound)
                    switch(self.player.hasArmor) {
                    case true:
                        self.gameLogic.score(points: 2)
                        self.counter += 2
                        self.score.text = "Score: \(self.gameLogic.currentScore)"
                        break
                    case false:
                        if self.player.hasMango{
                            self.player.animationName = "red-armor"
                            self.player.hasArmor = true
                            self.player.updateWalkAnimations(powerUp: self.player.animationName)
                            if isMovingToTheLeft {
                                self.player.isMovingLeft = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    self.player.isMovingLeft = false
                                }
                            } else if isMovingToTheRight {
                                self.player.isMovingRight = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    self.player.isMovingRight = false
                                }
                            }
                        } else {
                            self.player.animationName = "armor"
                            self.player.hasArmor = true
                            self.player.updateWalkAnimations(powerUp: self.player.animationName)
                            if isMovingToTheLeft {
                                self.player.isMovingLeft = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    self.player.isMovingLeft = false
                                }
                            } else if isMovingToTheRight {
                                self.player.isMovingRight = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    self.player.isMovingRight = false
                                }
                            }
                        }
                        break
                    default:
                        break
                    }
                    break
                case .mango:
                    ground.run(mangoSound)
                    switch(self.player.hasMango) {
                    case true:
                        self.gameLogic.score(points: 2)
                        self.counter += 2
                        self.score.text = "Score: \(self.gameLogic.currentScore)"
                        break
                    case false:
                        if self.player.hasArmor {
                            self.player.animationName = "red-armor"
                            self.player.hasMango = true
                            self.player.updateWalkAnimations(powerUp: self.player.animationName)
                            if isMovingToTheLeft {
                                self.player.isMovingLeft = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    self.player.isMovingLeft = false
                                }
                            } else if isMovingToTheRight {
                                self.player.isMovingRight = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    self.player.isMovingRight = false
                                }
                            }
                            self.player.speed *= 1.5
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                self.player.speed /= 1.5
                                self.player.hasMango = false
                                if self.player.hasArmor {
                                    self.player.animationName = "armor"
                                } else {
                                    self.player.animationName = "dino"
                                }
                                self.player.updateWalkAnimations(powerUp: self.player.animationName)
                            }

                        } else {
                            self.player.animationName = "mango"
                            self.player.hasMango = true
                            self.player.updateWalkAnimations(powerUp: self.player.animationName)
                            if isMovingToTheLeft {
                                self.player.isMovingLeft = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    self.player.isMovingLeft = false
                                }
                            } else if isMovingToTheRight {
                                self.player.isMovingRight = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    self.player.isMovingRight = false
                                }
                            }
                            self.player.speed *= 1.5
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                self.player.speed /= 1.5
                                self.player.hasMango = false
                                self.player.animationName = "dino"
                                self.player.updateWalkAnimations(powerUp: self.player.animationName)
                            }
                        }
                        break
                    default:
                        break
                    }
                    break
                default:
                    break
                }
                
                powerUp.removeFromParent()
            }
        }
    }
    
}

//MARK: - Power Up

extension GameScene {
    private func newPowerUp(at position: CGPoint, powerUpName: String) {
        let powerUp = PowerUpClass()
        powerUp.size = CGSize(width: 50, height: 50)
        
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

//MARK: - Adding Lives

extension GameScene {
    private func updateLives(update: Int) {
        if update == 1 {
            if self.player.lives < 3 {
                self.player.lives += 1
                self.healthPoints[self.player.lives-1].run(.fadeIn(withDuration: 0.2))
            }
        } else if update == -1 {
            if self.player.lives >= 1 {
                self.healthPoints[self.player.lives-1].run(.fadeOut(withDuration: 0.2))
                self.player.lives -= 1
            }
        }
    }
}

//MARK: - Game Over Scene

extension GameScene {
    private func gameOverDisplay() {
        backgroundMusic.run(SKAction.stop())
        let gameOverScene = GameOverScene(size: size)
        gameOverScene.scaleMode = scaleMode
        
        let reveal = SKTransition.fade(withDuration: 0.5)
        view?.presentScene(gameOverScene, transition: reveal)
    }
}
