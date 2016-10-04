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
    
    required init(enemies: [EnemyNode], player: PlayerNode) {
        self.enemies = enemies
        self.player = player
        
    }
    
    
    public func update() {
        for enemy in enemies {
            enemy.detect(target: player!)
        }
    }
}
