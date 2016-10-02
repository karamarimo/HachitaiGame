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

class EnemyManager {
    public var enemies: [EnemyNode] = []
    public var player: PlayerNode?
    public var physicsWorld: SKPhysicsWorld?
    
    required init(enemies: [EnemyNode], player: PlayerNode, physicsWorld: SKPhysicsWorld) {
        self.enemies = enemies
        self.player = player
        self.physicsWorld = physicsWorld
    }
    
    
    public func update() {
        for enemy in enemies {
            let detecting = enemy.detect(target: player!)
            enemy.color = detecting ? UIColor.purple : UIColor.red
        }
    }
}
