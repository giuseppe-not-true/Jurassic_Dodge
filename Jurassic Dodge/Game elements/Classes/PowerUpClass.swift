//
//  PowerUpClass.swift
//  JurassicDodge
//
//  Created by Alessandro Colantonio on 30/03/22.
//

import Foundation
import SpriteKit

enum PowerUpType {
    case heart
    case armor
    case mango
    case none
}

class PowerUpClass: SKSpriteNode {
    var powerUpType = PowerUpType.none
}
