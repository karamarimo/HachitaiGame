//
//  PlayerController.swift
//  HachitaiGame
//
//  Created by admin on 2016/09/25.
//  Copyright © 2016年 admin. All rights reserved.
//

import Foundation
import GameKit
import SKTUtils
import SwiftEventBus

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
        player?.speed = 0
        // for debug
        SwiftEventBus.post(GameConst.UI.touchPositionChanged, sender: startPoint! as AnyObject)
    }
    
    func update() {
        //        nextUpdate?()
        player.map { player in
            player.physicsBody?.velocity = velocity
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.map {player in
            let touch = touches.first
            let targetPoint = touch?.location(in: self)
            let diff = CGPointSubtract(targetPoint!, self.startPoint!)
            
            // for debug
            SwiftEventBus.post(GameConst.UI.touchPositionChanged, sender: targetPoint! as AnyObject)
            
            let length =  CGPointLength(diff)
            let speed = maxSpeed * min(length / maxInputLength, 1)
            let direction = CGPointToAngle(diff) - CGFloat(M_PI_2)
            velocity = CGVectorFromCGPoint(CGPointMultiplyScalar(CGPointNormalize(diff), speed))
            player.zRotation = direction
            
            // set the animation speed
            player.speed = speed / maxSpeed
            
            //            self.nextUpdate = { ()->() in
            //
            //                player.position.x += vec.dx * speed / 10
            //                player.position.y += vec.dy * speed / 10
            //
            //
            //            }
            //
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        nextUpdate = nil
        velocity = CGVector.zero
        player?.removeAllActions()
    }
    
}
