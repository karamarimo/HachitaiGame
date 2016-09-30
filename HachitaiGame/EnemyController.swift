//
//  EnemyController.swift
//  HachitaiGame
//
//  Created by admin on 2016/09/30.
//  Copyright © 2016年 admin. All rights reserved.
//

import UIKit
import GameKit
import SKTUtils

class EnemyController {
    public var enemies: [EnemyNode] = []
    public var player: PlayerNode?
    public var physicsWorld: SKPhysicsWorld?
    
    required init(enemies: [EnemyNode], player: PlayerNode, physicsWorld: SKPhysicsWorld) {
        self.enemies = enemies
        self.player = player
        self.physicsWorld = physicsWorld
    }
    
    private func enemyDetectPlayer(enemy: EnemyNode) -> Bool {
        let vec = CGPointSubtract(player!.position, enemy.position)
        
        // check distance
        if CGPointLength(vec) > enemy.visionRange {
            return false
        }
        
        // check angle
        let angle = fabs( (CGPointToAngle(vec) - enemy.zRotation).remainder(dividingBy: (CGFloat)(M_PI * 2)) )
        if angle > enemy.fieldOfView {
            return false
        }
        
        // check obstacles
        var unobstructed = true
        physicsWorld!.enumerateBodies(alongRayStart: enemy.position, end: player!.position, using: { (body: SKPhysicsBody, point: CGPoint, normal: CGVector, stop: UnsafeMutablePointer<ObjCBool>) in
            if let node = body.node {
                if node !== enemy && node !== self.player {
                    unobstructed = false
                    stop.pointee = false
                }
            }
        })
        return unobstructed
    }
    
    public func update() {
        for enemy in enemies {
            if enemyDetectPlayer(enemy: enemy) {
                enemy.color = UIColor.purple
            } else {
                enemy.color = UIColor.red
            }
        }
    }
}
