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
    let maxSpeed: CGFloat = 50
    var nextUpdate: (()->())? = nil
    
    required init() {
        super.init(texture: nil, color: UIColor.clear, size: CGSize(width: 100000, height: 10000) )
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        startPoint = touches.first?.location(in: self)
    }
    
    func update() {
        nextUpdate?()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        _ = player.map({player in
            let touch = touches.first
            let targetPoint = touch?.location(in: self)
            var vec = CGVector (dx: targetPoint!.x - self.startPoint!.x, dy: targetPoint!.y - self.startPoint!.y)
            
            let length =  hypot(vec.dx, vec.dy)
            let velocity = length < maxSpeed ? length : maxSpeed
            let direction = atan2(vec.dy, vec.dx)
            vec = CGVector(dx: vec.dx / length, dy: vec.dy / length )
            player.zRotation = direction
            
            
            self.nextUpdate = { ()->() in
                
                player.position.x += vec.dx * velocity / 10
                player.position.y += vec.dy * velocity / 10
            
               
            }
        
        })
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        nextUpdate = nil
    }
    
}
