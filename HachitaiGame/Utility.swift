//
//  Uitility.swift
//  HachitaiGame
//
//  Created by admin on 2016/09/25.
//  Copyright © 2016年 admin. All rights reserved.
//

import UIKit
import GameKit
import SKTUtils

class Utility: NSObject {
    static func makeArrow(_ length: Int = 30) -> SKShapeNode {
        let directionPath = CGMutablePath()
        
        directionPath.move(to: CGPoint(x: 0, y: 0))
        directionPath.addLine(to: CGPoint(x: 0, y: length))
        directionPath.addLine(to: CGPoint(x: -5, y: length - 10))
        directionPath.addLine(to: CGPoint(x: 5, y: length - 10))
        directionPath.addLine(to: CGPoint(x: 0, y: length))
        
        let shape = SKShapeNode(path: directionPath)
        shape.lineWidth = 1.0
        shape.strokeColor = UIColor.darkGray
        
        return shape
    }
    
    static func globalZRotation(_ node: SKNode) -> CGFloat {
        if let p = node.parent {
            return globalZRotation(p) + node.zRotation
        }
        return node.zRotation
    }
    
    static func angleSutract(_ angle1: CGFloat, _ angle2: CGFloat) -> CGFloat {
        return (angle1 - angle2).remainder(dividingBy: (CGFloat)(M_PI) * 2)
    }
    
    static func angleDiff(_ angle1: CGFloat, _ angle2: CGFloat) -> CGFloat {
        return fabs(angleSutract(angle1, angle2))
    }
    
    static func CGPointRotate(_ p: CGPoint, _ angle: CGFloat) -> CGPoint {
        let cosAngle = cos(angle)
        let sinAngle = sin(angle)
        let x = p.x
        let y = p.y
        return CGPoint(x: x * cosAngle - y * sinAngle, y: x * sinAngle + y * cosAngle)
    }
    
    static func SegmentCircleIntersection(_ p1: CGPoint, _ p2: CGPoint, c: CGPoint, r: CGFloat) -> [CGPoint] {
        /*
         C: center of circle
         P,Q: ends of segment
         A: intersection
         r: radius
         
         PA = kPQ for some k
         |CA|^2 = r^2
         |CP + PA|^2 = r^2
         |CP + kPQ|^2 = r^2
         |CP|^2 + 2kCP*PQ + k^2|PQ|^2 = r^2
         (|PQ|^2)k^2 + 2(CP*PQ)k + (|CP|^2-r^2) = 0
         ak^2 + 2bk + c = 0
         
         A = P + PA = P + kPQ
        */
        
        let v = CGPointSubtract(p1, p2)
        let a = v.x * v.x + v.y * v.y
        if a == 0 {
            return []
        }

        let v1 = CGPointSubtract(p1, c)
        let v2 = CGPointSubtract(p2, p1)
        let b = v1.x * v2.x + v1.y * v2.y
        
        let v3 = CGPointSubtract(p1, c)
        let c = v3.x * v3.x + v3.y * v3.y - r * r
        
        let D = b * b - a * c
        if D <= 0 {
            return []
        }
        
        let k = [(-b + sqrt(D)) / a, (-b - sqrt(D)) / a]
        let intersections = k.flatMap({ (x: CGFloat) -> CGPoint? in
            if x >= 0 && x <= 1 {
                return CGPointLerp(p1, p2, x)
            } else {
                return nil
            }
        })
        
        return intersections
    }
}

extension Bool {
    static func ^(b1: Bool, b2: Bool) -> Bool {
        return b1 && !b2 || !b1 && b2
    }
}
