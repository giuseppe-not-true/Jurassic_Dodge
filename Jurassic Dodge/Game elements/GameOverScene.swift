//
//  GameOverScene.swift
//  Jurassic Dodge
//
//  Created by Giuseppe Falso on 01/04/22.
//

import Foundation
import SpriteKit
import SwiftUI

class GameOverScene: SKScene {
    @ObservedObject var gameLogic: GameLogic = GameLogic.shared
    
    var bg = SKSpriteNode(imageNamed: "background")
    var finalScore = SKLabelNode()
    var restartButton = SKSpriteNode(imageNamed: "replay-button")
    var restartLabel = SKLabelNode()
    var cam = SKCameraNode()
    
    override init(size: CGSize) {
        super.init(size: size)
        
        
        
        bg.name = "background"
        bg.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2*1.1)
        bg.size.width *= 1
        bg.size.height *= 1
        bg.zPosition = 0.0
        
        addChild(bg)
        
       

        
        
        finalScore.text = "Your score: \(gameLogic.currentScore)"
        finalScore.fontSize = 50.0
        finalScore.color = SKColor.white
        finalScore.fontName = "Thonburi-Bold"
        finalScore.position = CGPoint(x: size.width / 2, y: size.height / 2 + 50)
        
        addChild(finalScore)
        
        restartButton.name = "restartButton"
        restartButton.size = CGSize(width: 150.0, height: 100.0)
        restartButton.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        addChild(restartButton)
        
//        restartLabel.text = "Replay"
//        restartLabel.fontSize = 20.0
//        restartLabel.color = SKColor.white
//        restartLabel.fontName = "Thonburi-Bold"
        restartLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 - 50)
        
        addChild(restartLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if touchedNode.name == "restartButton" {
                restartGame()
            }
        }
    }
    
    func restartGame(){
        let gameScene = GameScene(size: size)
        gameScene.scaleMode = .fill
//        gameScene.camera!.position = CGPoint(x: 0, y: 0)
        let reveal = SKTransition.fade(withDuration: 0.5)
        self.view?.presentScene(gameScene, transition: reveal)

    }
}
