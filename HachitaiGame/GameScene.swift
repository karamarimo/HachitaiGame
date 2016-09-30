//
//  GameScene.swift
//  HachitaiGame
//
//  Created by admin on 2016/09/24.
//  Copyright © 2016年 admin. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let playerSpeed: CGFloat = 200.0
    
    var enemy: EnemyNode!
    
    var block: ObstacleSpriteNode!
    
    var player: PlayerNode!
    
    let playerController = PlayerControllerNode()
    var enemyController: EnemyController!
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = UIColor.white

        let obsRect = CGRect(x: 150, y: 300, width: 20, height: 100)
        block = ObstacleSpriteNode(rect: obsRect ,texture: nil)
        self.addChild(block)
        
        
        enemy = EnemyNode()
        enemy.position = CGPoint(x: 50, y: 300)
        self.addChild(enemy)
        
        player = PlayerNode()
        self.addChild(player)
        player.position = CGPoint(x: 200, y: 50)
        
        playerController.player = player
        self.addChild(playerController)
        playerController.position = CGPoint(x: 50, y: 50)
        
        enemyController = EnemyController(enemies: [enemy], player: player, physicsWorld: self.physicsWorld)
       
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        return
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        playerController.update()
        enemyController.update()
    }
}
