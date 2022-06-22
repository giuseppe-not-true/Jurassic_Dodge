//
//  PlayerClass.swift
//  JurassicDodge
//
//  Created by Alessandro Colantonio on 30/03/22.
//

import Foundation
import SpriteKit

class PlayerClass: SKSpriteNode {
    public var playerState = PlayerState.roger
    public var lives: Int = 3
    public var animationName: String = "dino"
    public var isMovingLeft: Bool = false
    public var isMovingRight: Bool = false
    //var isMovingTowards : CGFloat = 0
    public var walkRight: [SKTexture]
    public var walkLeft: [SKTexture]
    var idle: SKTexture
    public var hasArmor: Bool = false
    public var hasMango: Bool = false
    public var mangoTimer = Timer()
    public var isInvincible: Bool = false
    public var invincibleTimer = Timer()
    
    public var goingMango = SKAction()
    public var comingFromMango = SKAction()
    public var mangoSequence = SKAction()
    
    init(imageNamed: String) {
        
        walkRight = [SKTexture(imageNamed: "dino-walk-right-1"), SKTexture(imageNamed: "dino-walk-right-2"), SKTexture(imageNamed: "dino-walk-right-3"), SKTexture(imageNamed: "dino-walk-right-2")]
        
        walkLeft = [SKTexture(imageNamed: "dino-walk-left-1"), SKTexture(imageNamed: "dino-walk-left-2"), SKTexture(imageNamed: "dino-walk-left-3"), SKTexture(imageNamed: "dino-walk-left-2")]
        
        idle = SKTexture(imageNamed: "dino-front")
        
        super.init(texture: SKTexture(imageNamed: "dino-front"), color: UIColor.clear, size: SKTexture(imageNamed: "dino-front").size())
        
        self.goingMango = SKAction.run {
            if self.hasArmor {
                self.updateWalkAnimations(powerUp: "red-armor")
            } else {
                self.updateWalkAnimations(powerUp: "mango")
            }
        }
        
        self.comingFromMango = SKAction.run {
            if self.hasArmor {
                self.updateWalkAnimations(powerUp: "armor")
            } else {
                self.updateWalkAnimations(powerUp: "none")
            }
        }
        
        self.mangoSequence = SKAction.sequence([
            .wait(forDuration: 4),
            comingFromMango,
            .wait(forDuration: 0.2),
            goingMango,
            .wait(forDuration: 0.2),
            comingFromMango,
            .wait(forDuration: 0.2),
            goingMango,
            .wait(forDuration: 0.2),
            comingFromMango
        ])
        
//        super.init(texture: SKTexture(imageNamed: imageNamed), color: UIColor.clear, size: SKTexture(imageNamed: imageNamed).size())
        
//        super.init(texture: SKTexture(imageNamed: "\(animationName)-front"), color: UIColor.clear, size: SKTexture(imageNamed: "\(animationName)-front").size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func walkLeftAnimation() {
        self.removeAllActions()
        let walkLeftAction = SKAction.animate(with: [walkLeft[0], walkLeft[1], walkLeft[2], walkLeft[1]],  timePerFrame: 1.5)
        let walk = SKAction.repeatForever(walkLeftAction)
        self.run(walk, withKey: "walk-left")
    }
    
    func walkRightAnimation() {
        self.removeAllActions()
        let walkRightAction = SKAction.animate(with: [walkRight[0], walkRight[1], walkRight[2], walkRight[1]], timePerFrame: 1.5)
        let walk = SKAction.repeatForever(walkRightAction)
        self.run(walk, withKey: "walk-right")
    }
    
    func idleAnimation() {
        self.removeAllActions()
        let idleAction = SKAction.animate(with: [idle], timePerFrame: 1.5)
        let idle = SKAction.repeatForever(idleAction)
        self.run(idle, withKey: "idle")
    }
    
    func updateWalkAnimations(powerUp: String) {
        walkRight = [SKTexture(imageNamed: "\(animationName)-walk-right-1"), SKTexture(imageNamed: "\(animationName)-walk-right-2"), SKTexture(imageNamed: "\(animationName)-walk-right-3"), SKTexture(imageNamed: "\(animationName)-walk-right-2")]
        walkLeft = [SKTexture(imageNamed: "\(animationName)-walk-left-1"), SKTexture(imageNamed: "\(animationName)-walk-left-2"), SKTexture(imageNamed: "\(animationName)-walk-left-3"), SKTexture(imageNamed: "\(animationName)-walk-left-2")]
        idle = SKTexture(imageNamed: "\(animationName)-front")
        
        if (isMovingLeft == true) {
            self.walkLeftAnimation()
        }
        if (isMovingRight == true) {
            self.walkRightAnimation()
        }
        
//        if (isMovingRight == false && isMovingRight == false) {
//            self.idleAnimation()
//        }
        
    }
    
}
