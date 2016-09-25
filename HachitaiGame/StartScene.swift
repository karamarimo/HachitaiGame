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
    override func didMove(to view: SKView) {
        makeView()
    }
    
    func canFind(target: CGPoint) -> Bool {
        return true
    }
    
//    func updateObstacle( _ objects: [ Obstacle ] ) {
//        
//    }
    
    private func makeView() {
        let newGameLabel = SKLabelNode(text: "START")
        let newGameButton = SKButton(color: UIColor.orange, size: CGSize(width: 100, height: 100))
        
        newGameButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        newGameButton.addChild(newGameLabel)
        self.addChild(newGameButton)
        
        newGameButton.setCallback {
            self.moveToGameScene()
        }
        // TODO: remove this later
        // for debug
        moveToGameScene()
    }
    private func moveToGameScene() {
        let gameScene = GameScene()
        gameScene.scaleMode = .aspectFill
        gameScene.size = (self.view?.frame.size)!
        self.view?.presentScene(gameScene, transition: SKTransition.doorsOpenHorizontal(withDuration: 0.5) )
    }
}


