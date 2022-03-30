//
//  MeteorClass.swift
//  JurassicDodge
//
//  Created by Alessandro Colantonio on 30/03/22.
//

import Foundation
import SpriteKit

class MeteorClass {
    var powerUp = PowerUpType.none
    
    func randomPowerUp() {
        let random = Int.random(in: 1 ... 10)
        switch(random) {
        case 1: powerUp = .health
            break
        case 2: powerUp = .armor
            break
        case 3: powerUp = .mango
            break
        default:
            break
        }
    }
}
