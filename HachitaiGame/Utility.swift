//
//  Uitility.swift
//  HachitaiGame
//
//  Created by admin on 2016/09/25.
//  Copyright © 2016年 admin. All rights reserved.
//

import UIKit
import GameKit

class Utility: NSObject {
    static func makeArrow(_ length: Int = 30) -> SKShapeNode {
        let directionPath = CGMutablePath()
        
        directionPath.move(to: CGPoint(x: 0, y: 0))
        directionPath.addLine(to: CGPoint(x: 0, y: length))
        directionPath.addLine(to: CGPoint(x: -5, y: length - 10))
        directionPath.addLine(to: CGPoint(x: 5, y: length - 10))
        directionPath.addLine(to: CGPoint(x: 0, y: length))
        
        let shape = SKShapeNode(path: directionPath)
        shape.zRotation = -(CGFloat)(M_PI_2)
        shape.lineWidth = 1.0
        shape.strokeColor = UIColor.darkGray
        
        return shape
    }

}
