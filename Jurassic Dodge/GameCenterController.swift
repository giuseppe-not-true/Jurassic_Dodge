//
//  GameCenterController.swift
//  Jurassic Dodge
//
//  Created by Giuseppe Falso on 02/09/22.
//

import Foundation
import GameKit

class GameCenterController: ObservableObject {
    static let shared: GameCenterController = GameCenterController()
    
    let localPlayer = GKLocalPlayer.local
    let accessPoint = GKAccessPoint.shared
    
    init() {
        accessPoint.location = .topLeading
        accessPoint.showHighlights = true
        accessPoint.isActive = true
    }
    
    public func authenticateUser() {
        localPlayer.authenticateHandler = { vc, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            
            self.accessPoint.isActive = self.localPlayer.isAuthenticated
        }
    }
    
    public func submitScore() {
        if GKLocalPlayer.local.isAuthenticated {
            GKLeaderboard.submitScore(
                UserDefaults.standard.integer(forKey: "HighScore"),
                context: 0,
                player: GKLocalPlayer.local,
                leaderboardIDs: ["Jurassic_Dodge_Highscores"]
            ) { error in
                print(error)
            }
        }
    }
}
