//
//  PlayerClass.swift
//  JurassicDodge
//
//  Created by Alessandro Colantonio on 30/03/22.
//

import Foundation
import SpriteKit

class PlayerClass: SKSpriteNode {
    var playerState = PlayerState.roger
    var lives = 3
    var animationName = "dino"
    var isMovingLeft = false
    var isMovingRight = false
    //var isMovingTowards : CGFloat = 0
    var walkRight: [SKTexture]
    var walkLeft: [SKTexture]
    var idle: SKTexture
    var hasArmor: Bool = false
    var hasMango: Bool = false
    
    init(imageNamed: String) {
        
        idle = SKTexture(imageNamed: "\(animationName)-front")
        
        walkRight = [SKTexture(imageNamed: "\(animationName)-walk-right-1"), SKTexture(imageNamed: "\(animationName)-walk-right-2"), SKTexture(imageNamed: "\(animationName)-walk-right-3"), SKTexture(imageNamed: "\(animationName)-walk-right-2")]
            
        walkLeft = [SKTexture(imageNamed: "\(animationName)-walk-left-1"), SKTexture(imageNamed: "\(animationName)-walk-left-2"), SKTexture(imageNamed: "\(animationName)-walk-left-3"), SKTexture(imageNamed: "\(animationName)-walk-left-2")]
        
//        super.init(texture: SKTexture(imageNamed: imageNamed), color: UIColor.clear, size: SKTexture(imageNamed: imageNamed).size())
        
        super.init(texture: SKTexture(imageNamed: "\(animationName)-front"), color: UIColor.clear, size: SKTexture(imageNamed: "\(animationName)-front").size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func walkLeftAnimation() {
        let walkLeftAction = SKAction.animate(with: [walkLeft[0], walkLeft[1], walkLeft[2], walkLeft[1]],  timePerFrame: 1.5)
        let walk = SKAction.repeatForever(walkLeftAction)
        self.run(walk)
    }
    
    func walkRightAnimation() {
        let walkRightAction = SKAction.animate(with: [walkRight[0], walkRight[1], walkRight[2], walkRight[1]], timePerFrame: 1.5)
        let walk = SKAction.repeatForever(walkRightAction)
        self.run(walk)
    }
    
    func idleAnimation() {
        let idleAction = SKAction.animate(with: [idle], timePerFrame: 1.5)
        let idle = SKAction.repeatForever(idleAction)
        self.run(idle)
    }
    
    func updateWalkAnimations(powerUp: String) {
//        self.removeAllActions()
                
        walkRight = [SKTexture(imageNamed: "\(animationName)-walk-right-1"), SKTexture(imageNamed: "\(animationName)-walk-right-2"), SKTexture(imageNamed: "\(animationName)-walk-right-3"), SKTexture(imageNamed: "\(animationName)-walk-right-2")]
        walkLeft = [SKTexture(imageNamed: "\(animationName)-walk-left-1"), SKTexture(imageNamed: "\(animationName)-walk-left-2"), SKTexture(imageNamed: "\(animationName)-walk-left-3"), SKTexture(imageNamed: "\(animationName)-walk-left-2")]
        idle = SKTexture(imageNamed: "\(animationName)-front")
        
        if (isMovingLeft == true && isMovingRight == false) {
            self.walkLeftAnimation()
        }
        if (isMovingRight == true && isMovingLeft == false) {
            self.walkRightAnimation()
        }
//        if (isMovingRight == false && isMovingRight == false) {
//            self.idleAnimation()
//        }
        
    }
    
}
