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
    
    var isMuted: Bool = false
    var isFeedbackMuted: Bool = false
    var bg = SKSpriteNode(imageNamed: "background")
    var finalScore = SKLabelNode()
    var highScore = SKLabelNode()
    var restartButton = SKSpriteNode(imageNamed: "button")
    var homeButton = SKSpriteNode(imageNamed: "button")
    var restartLabel = SKLabelNode()
    var homeLabel = SKLabelNode()
    var cam = SKCameraNode()
    
    override init(size: CGSize) {
        super.init(size: size)
        
        bg.name = "background"
        bg.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        bg.size.width = self.frame.width
        bg.size.height = self.frame.height
        bg.zPosition = 0.0
        
        addChild(bg)
        
        finalScore.text = "Your score: \(gameLogic.currentScore)"
        finalScore.fontSize = 50.0
        finalScore.color = SKColor.white
        finalScore.fontName = "Minecraft"
        finalScore.position = CGPoint(x: size.width / 2, y: size.height * 0.75)
        
        addChild(finalScore)
        
        highScore.text = "Highscore: \(String(UserDefaults.standard.integer(forKey: "HighScore")))"
        highScore.fontSize = 50.0
        highScore.color = SKColor.white
        highScore.fontName = "Minecraft"
        highScore.position = CGPoint(x: size.width / 2, y: size.height * 0.55)
        
        addChild(highScore)
        
        restartButton.name = "restartButton"
        restartButton.size = CGSize(width: 200.0, height: 60.0)
        restartButton.position = CGPoint(x: size.width / 3, y: size.height / 3)
        
        addChild(restartButton)
        
        restartLabel.text = "Replay"
        restartLabel.name = "replay"
        restartLabel.fontSize = 40.0
        restartLabel.color = SKColor.white
        restartLabel.fontName = "Minecraft"
        restartLabel.position = CGPoint(x: size.width / 3, y: size.height / 3)
        restartLabel.verticalAlignmentMode = .center
        restartLabel.horizontalAlignmentMode = .center
        
        addChild(restartLabel)
        
        homeButton.name = "homeButton"
        homeButton.size = CGSize(width: 200.0, height: 60.0)
        homeButton.position = CGPoint(x: size.width / 1.5, y: size.height / 3)
        
        addChild(homeButton)
        
        homeLabel.text = "Home"
        homeLabel.name = "home"
        homeLabel.fontSize = 40.0
        homeLabel.color = SKColor.white
        homeLabel.fontName = "Minecraft"
        homeLabel.position = CGPoint(x: size.width / 1.5, y: size.height / 3)
        homeLabel.verticalAlignmentMode = .center
        homeLabel.horizontalAlignmentMode = .center

        addChild(homeLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if touchedNode.name == "restartButton" || touchedNode.name == "replay" {
                restartGame()
            } else if touchedNode.name == "homeButton" || touchedNode.name == "home" {
                homeScreen()
            }
        }
    }
    
    func restartGame(){
        let gameScene = GameScene(size: size)
        
        if self.isMuted {
            gameScene.isMuted = true
        }
        
        if self.isFeedbackMuted {
            gameScene.isFeedbackMuted = true
        }
        
        gameScene.scaleMode = .fill
        let reveal = SKTransition.fade(withDuration: 0.5)
        self.view?.presentScene(gameScene, transition: reveal)
    }
    
    func homeScreen() {
        self.removeFromParent()
        
        gameLogic.currentGameState = .mainScreen
    }
}
