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
    
    let con = PlayerControllerNode()
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = UIColor.white
//        
//        player = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 30, height: 30))
//        player.position = CGPoint(x: 100, y: 100)
//        player.zPosition = 10.0
//        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
//        player.physicsBody?.affectedByGravity = false
//        self.addChild(player)
//        
        let obsRect = CGRect(x: 300, y: 300, width: 100, height: 20)
        block = ObstacleSpriteNode(rect: obsRect ,texture: nil)
        block.position = CGPoint(x: 150, y: 200)
        self.addChild(block)
        
        
        enemy = EnemyNode()
        enemy.position = CGPoint(x: 50, y: 300)
        self.addChild(enemy)
        
        player = PlayerNode()
        self.addChild(player)
        player.position = CGPoint(x: 200, y: 50)
        
        con.player = player
        self.addChild(con)
        con.position = CGPoint(x: 50, y: 50)
        

       
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        return
//        let destination = touches.first!.location(in: self)
//        let distance = hypot(player.position.x - destination.x, player.position.y - destination.y)
//        let duration = distance / playerSpeed
//        player.removeAction(forKey: "move")
//        player.run(SKAction.move(to: destination, duration: TimeInterval(duration)), withKey: "move")
//        player.zRotation = atan2((destination.y - player.position.y), (destination.x - player.position.x))
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        con.update()
//        let frame = self.frame.size
//        player.position
    }
}
