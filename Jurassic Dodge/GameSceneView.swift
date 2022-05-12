//
//  GameSceneView.swift
//  Jurassic Dodge
//
//  Created by Giuseppe Falso on 12/05/22.
//

import SwiftUI
import SpriteKit

struct GameSceneView: View {
    @Environment(\.scenePhase) var scenePhase
    var gameScene: GameScene = GameScene()
    
    var body: some View {
        SpriteView(scene: gameScene)
            .ignoresSafeArea()
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    print("Active")
                    gameScene.view?.isPaused = false
                } else if newPhase == .inactive {
                    print("Inactive")
                    gameScene.view?.isPaused = true
                } else if newPhase == .background {
                    print("Background")
                    gameScene.view?.isPaused = true
                }
            }
    }
}
