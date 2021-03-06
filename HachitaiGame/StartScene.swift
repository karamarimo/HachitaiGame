//
//  StartScene.swift
//  HachitaiGame
//
//  Created by admin on 2016/09/24.
//  Copyright © 2016年 admin. All rights reserved.
//

import UIKit
import GameKit



class StartScene: SKScene {
    
    var newGameButton: SKButton!
    
    override func didMove(to view: SKView) {
        makeView()
    }
    
    private func makeView() {
        let newGameLabel = SKLabelNode(text: "START")
        newGameButton = SKButton(color: UIColor.orange, size: CGSize(width: 100, height: 100))
        
        newGameButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        newGameButton.addChild(newGameLabel)
        self.addChild(newGameButton)
        
        newGameButton.setCallback {
            self.moveToGameScene()
        }
    }
    
    private func moveToGameScene() {
        newGameButton.setCallback {
            
        }
        newGameButton = nil
        
        let gameScene = GameScene()
        gameScene.scaleMode = .aspectFill
        gameScene.size = (self.view?.frame.size)!
        self.view?.presentScene(gameScene, transition: SKTransition.doorsOpenHorizontal(withDuration: 0.5) )
    }
}


