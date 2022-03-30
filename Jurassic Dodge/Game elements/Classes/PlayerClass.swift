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
    var lifes = 3
    
    let walkRight: [SKTexture] = [SKTexture(imageNamed: "dino-walk-right-1"), SKTexture(imageNamed: "dino-walk-right-2"), SKTexture(imageNamed: "dino-walk-right-3")]
        
    let walkLeft: [SKTexture] = [SKTexture(imageNamed: "dino-walk-left-1"), SKTexture(imageNamed: "dino-walk-left-2"), SKTexture(imageNamed: "dino-walk-left-3")]
    
    func walkLeftAnimation() {
        let walkLeftAction = SKAction.animate(with: [walkLeft[0], walkLeft[1], walkLeft[2]], timePerFrame: 1.5)
        let walk = SKAction.repeatForever(walkLeftAction)
        self.run(walk)
    }
    
    func walkRightAnimation() {
        let walkRightAction = SKAction.animate(with: [walkRight[0], walkRight[1], walkRight[2]], timePerFrame: 1.5)
        let walk = SKAction.repeatForever(walkRightAction)
        self.run(walk)
    }
    
}
