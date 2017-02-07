//
//  ResultScene.swift
//  HachitaiGame
//
//  Created by admin on 2016/12/04.
//  Copyright © 2016年 admin. All rights reserved.
//

import SpriteKit
import SwiftEventBus

class ResultScene: SKScene {
    
    private var restartButton: SKButton!
    
    var score: Int = 0
    
    required init(size: CGSize, score: Int) {
        super.init(size: size)
        
        self.score = score
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        let scoreLabel = SKLabelNode(text: "Score: " + String(score))
        scoreLabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + 100)
        self.addChild(scoreLabel)
        
        
        restartButton = SKButton(color: UIColor.orange, size: CGSize(width: 180, height: 60))
        restartButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - 100)

        let restartLabel = SKLabelNode(text: "RESTART")
        restartLabel.position = CGPoint.zero
        restartLabel.verticalAlignmentMode = .center
        
        restartButton.addChild(restartLabel)
        self.addChild(restartButton)
        
        restartButton.setCallback {
            self.moveToGameScene()
        }

    }
    
    func moveToGameScene() {
        restartButton.setCallback {
            
        }
        restartButton = nil
        
        let gameScene = GameScene()
        gameScene.scaleMode = .aspectFill
        gameScene.size = (self.view?.frame.size)!
        self.view?.presentScene(gameScene, transition: SKTransition.doorsOpenVertical(withDuration: 0.5) )
    }
}
