//
//  GameScene.swift
//  HachitaiGame
//
//  Created by admin on 2016/09/24.
//  Copyright © 2016 admin. All rights reserved.
//

import SpriteKit
import GameplayKit
import SwiftEventBus

class GameScene: SKScene {
    
    let playerSpeed: CGFloat = 200.0
    
    var enemy: EnemyNode!
    
    var blocks: [ObstacleSpriteNode] = []
    
    var player: PlayerNode!
    
    let playerController = PlayerControllerNode()
    var enemyController: EnemyManager!
    
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = UIColor.white

        let block1 = ObstacleSpriteNode(rect: CGRect(x: 150, y: 200, width: 150, height: 20), texture: nil)
        blocks.append(block1)
        let block2 = ObstacleSpriteNode(rect: CGRect(x: 250, y: 300, width: 20, height: 200), texture: nil)
        blocks.append(block2)
        for block in blocks { self.addChild(block) }
        
        
        enemy = EnemyNode()
        enemy.position = CGPoint(x: 50, y: 300)
        self.addChild(enemy)
        
        player = PlayerNode()
        self.addChild(player)
        player.position = CGPoint(x: 50, y: 50)
        
        playerController.player = player
        self.addChild(playerController)
        playerController.position = CGPoint(x: 50, y: 50)
        
        enemyController = EnemyManager(enemies: [enemy], player: player)
        
        SwiftEventBus.onMainThread(self, name: "i see you") { (ntf: Notification!) in
            self.restartScene()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        return
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        playerController.update()
        enemyController.update()
    }
    
    
    func restartScene() {
        SwiftEventBus.unregister(self)
        let newScene = GameScene(size: self.size)
        self.view!.presentScene(newScene, transition: SKTransition.flipVertical(withDuration: 0.5))
    }
}
