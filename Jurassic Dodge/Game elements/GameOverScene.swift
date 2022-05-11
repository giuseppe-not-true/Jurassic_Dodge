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
    var homeButton = SKSpriteNode(imageNamed: "replay-button")
    var restartLabel = SKLabelNode()
    var cam = SKCameraNode()
    
    override init(size: CGSize) {
        super.init(size: size)
        
        bg.name = "background"
        bg.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        bg.size.width *= 1
        bg.size.height *= 1
        bg.zPosition = 0.0
        
        addChild(bg)
        
        finalScore.text = "Your score: \(gameLogic.currentScore)"
        finalScore.fontSize = 50.0
        finalScore.color = SKColor.white
        finalScore.fontName = "Minecraft"
        finalScore.position = CGPoint(x: size.width / 2, y: size.height / 2 + 50)
        
        addChild(finalScore)
        
        restartButton.name = "restartButton"
        restartButton.size = CGSize(width: 200.0, height: 80.0)
        restartButton.position = CGPoint(x: size.width / 2 + 100, y: size.height / 2 - 30)
        
        addChild(restartButton)
        
        homeButton.name = "homeButton"
        homeButton.size = CGSize(width: 200.0, height: 80.0)
        homeButton.position = CGPoint(x: size.width / 2 - 100, y: size.height / 2 - 30)
        
        addChild(homeButton)
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
            } else if touchedNode.name == "homeButton" {
                homeScreen()
            }
        }
    }
    
    func restartGame(){
        self.removeAllChildren()
        self.removeAllActions()

        let gameScene = GameScene(size: size)
        gameScene.scaleMode = .fill
        let reveal = SKTransition.fade(withDuration: 0.5)
        self.view?.presentScene(gameScene, transition: reveal)
    }
    
    func homeScreen() {
        self.removeAllChildren()
        self.removeAllActions()
        
        gameLogic.currentGameState = .mainScreen
    }
}
