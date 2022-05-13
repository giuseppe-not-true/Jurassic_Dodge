//
//  GameSceneView.swift
//  Jurassic Dodge
//
//  Created by Giuseppe Falso on 12/05/22.
//

import SwiftUI
import SpriteKit

struct SpriteKitContainer : UIViewRepresentable {
    var isMuted: Bool?
    
    class Coordinator: NSObject {
        var scene: GameScene? = GameScene()
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    func makeUIView(context: Context) -> SKView {
        let view = SKView(frame: .zero)
        view.preferredFramesPerSecond = 60
        view.showsFPS = false
        view.showsNodeCount = false
        
        //load SpriteKit Scene
        guard let aScene = context.coordinator.scene
        else {
            view.backgroundColor = UIColor.red
            return view
        }
        aScene.scaleMode = .resizeFill
        context.coordinator.scene = aScene
        context.coordinator.scene?.isMuted = isMuted!
        return view
    }
    
    
    func updateUIView(_ view: SKView, context: Context) {
        view.presentScene(context.coordinator.scene)
    }
    
}

struct GameSceneView: View {
    @Environment(\.scenePhase) var scenePhase
    var gameScene: GameScene = GameScene()
    @Binding var isMuted: Bool
    
    var body: some View {
        //        SpriteView(scene: gameScene)
        SpriteKitContainer(isMuted: isMuted)
            .ignoresSafeArea()
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    print("Active")
                    gameScene.view?.isPaused = false
                    gameScene.view?.scene?.isPaused = false
                } else if newPhase == .inactive {
                    print("Inactive")
                    gameScene.view?.isPaused = true
                    gameScene.view?.scene?.isPaused = true
                } else if newPhase == .background {
                    print("Background")
                    gameScene.view?.isPaused = true
                    gameScene.view?.scene?.isPaused = true
                }
            }
    }
}
