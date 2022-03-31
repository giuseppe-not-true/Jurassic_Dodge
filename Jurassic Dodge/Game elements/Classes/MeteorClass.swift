//
//  MeteorClass.swift
//  JurassicDodge
//
//  Created by Alessandro Colantonio on 30/03/22.
//

import Foundation
import SpriteKit

class MeteorClass: SKSpriteNode {
    var powerUp = PowerUpType.none
    var powerUpName = "none"
    
    func randomPowerUp() {
        let random = Int.random(in: 1 ... 10)
        
        switch(random) {
        case 1:
            powerUp = .heart
            powerUpName = "heart"
            break
        case 2:
            powerUp = .armor
            powerUpName = "armor"
            break
        case 3:
            powerUp = .mango
            powerUpName = "mango"
            break
        default:
            powerUpName = "none"
            break
        }        
    }
}
