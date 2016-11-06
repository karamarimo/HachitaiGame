//
//  CollisionBitmask.swift
//  HachitaiGame
//
//  Created by admin on 2016/11/06.
//  Copyright © 2016年 admin. All rights reserved.
//

import Foundation

struct CollisionBitmask {
    static let player: UInt32 = 1
    static let enemy: UInt32  = 2
    static let wall: UInt32  = 4
    static let item: UInt32  = 8
    static let goal: UInt32  = 16
}
