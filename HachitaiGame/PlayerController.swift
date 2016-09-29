//
//  PlayerController.swift
//  HachitaiGame
//
//  Created by admin on 2016/09/25.
//  Copyright © 2016年 admin. All rights reserved.
//

import Foundation
import GameKit

class PlayerControllerNode: SKSpriteNode {
    
    var player: PlayerNode?
    var startPoint: CGPoint?
    let maxInputLength: CGFloat = 150
    let maxSpeed: CGFloat = 250
    let walkingAnim = SKAction.repeatForever(SKAction.animate(with:
        [
            SKTexture(image: #imageLiteral(resourceName: "player2")),
            SKTexture(image: #imageLiteral(resourceName: "player3")),
            SKTexture(image: #imageLiteral(resourceName: "player2")),
            SKTexture(image: #imageLiteral(resourceName: "player1"))
        ], timePerFrame: 0.03))
    
    private var velocity = CGVector.zero
    
//    var nextUpdate: (()->())? = nil
    
    required init() {
        super.init(texture: nil, color: UIColor.clear, size: CGSize(width: 100000, height: 10000) )
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        startPoint = touches.first?.location(in: self)
        player?.run(walkingAnim)
    }
    
    func update() {
//        nextUpdate?()
        player.map { player in
            player.physicsBody?.velocity = velocity
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.map({player in
            let touch = touches.first
            let targetPoint = touch?.location(in: self)
            let vec = CGVector(dx: targetPoint!.x - self.startPoint!.x, dy: targetPoint!.y - self.startPoint!.y)
            
            let length =  hypot(vec.dx, vec.dy)
            let speed = maxSpeed * min(length / maxInputLength, 1)
            let direction = atan2(-vec.dx, vec.dy)
            velocity = CGVector(dx: vec.dx / length * speed, dy: vec.dy / length * speed)
            player.zRotation = direction
            player.speed = speed / maxSpeed
            
//            self.nextUpdate = { ()->() in
//                
//                player.position.x += vec.dx * speed / 10
//                player.position.y += vec.dy * speed / 10
//            
//               
//            }
//        
        })
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        nextUpdate = nil
        velocity = CGVector.zero
        player?.removeAllActions()
    }
    
}
