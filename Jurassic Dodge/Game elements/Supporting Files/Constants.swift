//
//  Constants.swift
//  JurassicDodge
//
//  Created by Alessandro Colantonio on 30/03/22.
//

import Foundation
import SwiftUI

/**
 * # Constants
 *
 * This file gathers contant values that are shared all around the project.
 * Modifying the values of these constants will reflect along the complete interface of the application.
 *
 **/


/**
 * # GameState
 * Defines the different states of the game.
 * Used for supporting the navigation in the project template.
 */

enum GameState {
    case mainScreen
    case playing
    case instructions
}

/**
 * # PlayerState
 * Defines the different states of the player.
 * Used for supporting the navigation in the project template.
 */

enum PlayerState {
    case roger
    case mango
    case armor
    case mangoarmor
    case dead
}

//typealias Instruction = (icon: String, title: String, description: String)
//
///**
// * # MainScreenProperties
// *
// * Keeps the information that shows up on the main screen of the game.
// *
// */
//
//struct MainScreenProperties {
//    static let gameTitle: String = "Game Title"
//
//    static let gameInstructions: [Instruction] = [
//        (icon: "hand.raised", title: "Instruction 1", description: "Instruction description."),
//        (icon: "hand.tap", title: "Instruction 2", description: "Instruction description."),
//        (icon: "hand.draw", title: "Instruction 3", description: "Instruction description."),
//        (icon: "hand.tap", title: "Instruction 4", description: "Instruction description."),
//        (icon: "hand.raised", title: "Instruction 5", description: "Instruction description."),
//        (icon: "hands.sparkles", title: "Instruction 6", description: "Instruction description."),
//    ]
//
//    /**
//     * To change the Accent Color of the applciation edit it on the Assets folder.
//     */
//
//    static let accentColor: Color = Color.accentColor
//}
