//
//  MeteorClass.swift
//  JurassicDodge
//
//  Created by Alessandro Colantonio on 30/03/22.
//

import Foundation
import SpriteKit
import SwiftUI

class MeteorClass: SKSpriteNode {
    @ObservedObject var gameLogic: GameLogic = GameLogic.shared
    var powerUp = PowerUpType.none
    var powerUpName = "none"
    
    func randomPowerUp() {
        var maxrand = self.gameLogic.currentScore / 4
        
        if maxrand <= 8 {
            maxrand = 8
        }
        
        let random = Int.random(in: 1 ... Int(maxrand))
        
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
