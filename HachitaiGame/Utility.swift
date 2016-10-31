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
    
    // return value is within -PI to PI
    static func angleSubtract(_ angle1: CGFloat, _ angle2: CGFloat) -> CGFloat {
        return (angle1 - angle2).remainder(dividingBy: (CGFloat)(M_PI) * 2)
    }
    // return value is within 0 to PI
    static func angleDiff(_ angle1: CGFloat, _ angle2: CGFloat) -> CGFloat {
        return fabs(angleSubtract(angle1, angle2))
    }
    
    static func CGPointRotate(_ p: CGPoint, _ angle: CGFloat) -> CGPoint {
        let cosAngle = cos(angle)
        let sinAngle = sin(angle)
        let x = p.x
        let y = p.y
        return CGPoint(x: x * cosAngle - y * sinAngle, y: x * sinAngle + y * cosAngle)
    }
    
    static func intersectionsOf(segmentStart p1: CGPoint, end p2: CGPoint,
                                   circleCenter c: CGPoint, radius r: CGFloat) -> [CGPoint] {
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
    
    static func intersectionOfSegments(start1 p1: CGPoint, end1 p2: CGPoint,
                                       start2 p3: CGPoint, end2 p4: CGPoint) -> CGPoint? {
        if let (p, k, l) = lineInter(start1: p1, end1: p2, start2: p3, end2: p4) {
            if k >= 0 && k <= 1 && l >= 0 && l <= 1 {
                return p
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    static func intersectionOfLines(start1 p1: CGPoint, end1 p2: CGPoint,
                                    start2 p3: CGPoint, end2 p4: CGPoint) -> CGPoint? {
        return lineInter(start1: p1, end1: p2, start2: p3, end2: p4)?.0
    }
    
    private static func lineInter(start1 p1: CGPoint, end1 p2: CGPoint,
                          start2 p3: CGPoint, end2 p4: CGPoint) -> (CGPoint, CGFloat, CGFloat)?  {
        let c = (p4.y - p3.y) * (p2.x - p1.x) - (p4.x - p3.x) * (p2.y - p1.y)
        if c == 0 {
            return nil
        }
        let a = (p4.y - p3.y) * (p4.x - p1.x) - (p4.x - p3.x) * (p4.y - p1.y)
        let b = 0 - (p2.y - p1.y) * (p4.x - p1.x) + (p2.x - p1.x) * (p4.y - p1.y)
        let k = a / c
        let l = b / c
        return (CGPointLerp(p1, p2, k), k, l)
    }
    
    // supposing it is a minor arc
    static func cropSegmentWithSector(start: CGPoint, end: CGPoint,
                                      center: CGPoint, radius: CGFloat,
                                      startAngle: CGFloat, endAngle: CGFloat) -> (CGPoint, CGPoint)? {
        var ints: [CGPoint] = []
        
        let circleInts = intersectionsOf(segmentStart: start, end: end, circleCenter: center, radius: radius)
        // get intersections with the arc
        let arcInts = circleInts.filter({ (p: CGPoint) -> Bool in
            let angle = CGPointToAngle(CGPointSubtract(p, center))
            return (angleSubtract(angle, startAngle) >= 0 && angleSubtract(angle, endAngle) <= 0)
        })
        for int in arcInts {
            ints.append(int)
        }
        
        let arcStart = CGPointAdd(center, CGPointMultiplyScalar(CGPointForAngle(startAngle), radius))
        let arcEnd = CGPointAdd(center, CGPointMultiplyScalar(CGPointForAngle(endAngle), radius))
        
        // get intersections with the two radii of the sector
        let int1 = intersectionOfSegments(start1: start, end1: end, start2: center, end2: arcStart)
        let int2 = intersectionOfSegments(start1: start, end1: end, start2: center, end2: arcEnd)
        
        if let int = int1 {
            ints.append(int)
        }
        if let int = int2 {
            ints.append(int)
        }
        
        let startPointAngle = CGPointToAngle(CGPointSubtract(start, center))
        let startIsBetweenRadii = angleSubtract(startPointAngle, startAngle) > 0
            && angleSubtract(startPointAngle, endAngle) < 0
        let startIsClose = CGPointDistance(start, center) <= radius
        let startIsInside = startIsBetweenRadii && startIsClose
        
        switch ints.count {
        case 2:
            return (ints[0], ints[1])
        case 1:
            if startIsInside {
                // start point inside, end point outside
                return (ints[0], start)
            } else {
                // start point outside, end point inside
                return (ints[0], end)
            }
        case 0:
            if startIsInside {
                // both points inside
                return (start, end)
            } else {
                // both poin ts outside
                return nil
            }
        default:
            print("something is wrong")
            return nil
        }
    }
}

extension Bool {
    static func ^(b1: Bool, b2: Bool) -> Bool {
        return b1 && !b2 || !b1 && b2
    }
}
