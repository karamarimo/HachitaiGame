//
//  enemy.swift
//  
//
//  Created by KamedaKei on 2016/09/25.
//
//

import Foundation
import GameKit
import SKTUtils
import SwiftEventBus


class EnemyNode: SKSpriteNode {
    
    
    var fieldOfView = CGFloat(M_PI / 5)
    var visionRange: CGFloat = 200.0
    var walkDistance: CGFloat = 100.0
    
    private let txt = SKTexture(imageNamed: "enemy")
    private var visionIndicator: SKShapeNode!
    private var patrolAnimation: SKAction!
    
    required init(){
        super.init(texture: txt, color: UIColor.white, size: CGSize(width:20, height:20))
        
//        let directionIndicator = Utility.makeArrow()
//        self.addChild(directionIndicator)
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = CollisionBitmask.enemy
        self.physicsBody?.contactTestBitMask = CollisionBitmask.player
        self.physicsBody?.collisionBitMask = .allZeros
        
        visionIndicator = SKShapeNode()
        visionIndicator.zPosition = -100.0
        visionIndicator.strokeColor = UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 0.2)
        visionIndicator.lineWidth = 0.0
        visionIndicator.glowWidth = 5.0
        visionIndicator.fillColor = UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 0.4)
        self.addChild(visionIndicator)
                
        SwiftEventBus.onMainThread(self, name: GameConst.Enemy.updateVision) {
            (ntf: Notification!) in
            if let obcs = ntf.object as? [ObstacleSpriteNode] {
                self.updateVisionIndicator(obcs)
            }
        }
        SwiftEventBus.onMainThread(self, name: GameConst.Enemy.detect) {
            (ntf: Notification!) in
            if let target = ntf.object as? SKSpriteNode {
                self.detect(target: target)
            }
        }
        SwiftEventBus.onMainThread(self, name: GameConst.Game.sceneFinished) {
            (ntf: Notification!) in
            SwiftEventBus.unregister(self)
            self.removeAllActions()
//            self.removeAllChildren()
            self.patrolAnimation = nil
        }
        
        attachAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // TODO: decode properties
        
        super.init(coder: aDecoder)
    }
    
    func attachAnimation() {
        let lookAroundAnimation = SKAction.sequence([
            SKAction.rotate(byAngle: CGFloat(M_PI_4), duration: 0.25),
            SKAction.wait(forDuration: 1.0),
            SKAction.rotate(byAngle: -CGFloat(M_PI_2), duration: 0.5),
            SKAction.wait(forDuration: 1.0),
            SKAction.rotate(byAngle: CGFloat(M_PI_4), duration: 0.25),
            SKAction.wait(forDuration: 1.0)
            ])
        
        let walkAnimation = SKAction.run {
            let vec = CGVectorFromCGPoint(CGPointMultiplyScalar(CGPointForAngle(self.zRotation), self.walkDistance))
            self.run(SKAction.move(by: vec, duration: 3.0))
        }
        
        patrolAnimation = SKAction.repeatForever(SKAction.sequence([
            walkAnimation,
            SKAction.wait(forDuration: 3.0),
            lookAroundAnimation,
            SKAction.rotate(byAngle: CGFloat(M_PI), duration: 1.0)
            ]))
        
        self.run(patrolAnimation)
    }
    
    func updateVisionIndicator(_ obstacles: [ObstacleSpriteNode]) {
        // min has to have lower angle than max
        var segments: [(min: CGPoint, max: CGPoint, minAngle: CGFloat, maxAngle: CGFloat)] = []
        let startAngle = Utility.angleSubtract(self.zRotation - self.fieldOfView, 0)
        let endAngle = Utility.angleSubtract(self.zRotation + self.fieldOfView, 0)
        
        for obc in obstacles {
            let pos = self.scene!.convert(obc.position, from: obc.parent!)
            let rot = Utility.globalZRotation(obc)
            let width = obc.size.width
            let height = obc.size.height
            let anchor = obc.anchorPoint
            var vertices: [CGPoint] = []
            
            // get the absolute positions of the 4 vertices of the rectangle
            vertices.append(CGPointAdd(pos, Utility.CGPointRotate(CGPoint(x: (1 - anchor.x) * width,
                                                                          y: (1 - anchor.y) * height), rot)))
            vertices.append(CGPointAdd(pos, Utility.CGPointRotate(CGPoint(x: (-anchor.x) * width,
                                                                          y: (1 - anchor.y) * height), rot)))
            vertices.append(CGPointAdd(pos, Utility.CGPointRotate(CGPoint(x: (-anchor.x) * width,
                                                                          y: (-anchor.y) * height), rot)))
            vertices.append(CGPointAdd(pos, Utility.CGPointRotate(CGPoint(x: (1 - anchor.x) * width,
                                                                          y: (-anchor.y) * height), rot)))
            
            // get the 2 vertices that have the max/min angles from this enemy
            var maxPoint: CGPoint! = nil
            var minPoint: CGPoint! = nil
            var maxAngle: CGFloat! = nil
            var minAngle: CGFloat! = nil
            
            for point in vertices {
                let angle = CGPointToAngle(CGPointSubtract(point, self.position))
                if let max = maxAngle, let min = minAngle {
                    if Utility.angleSubtract(angle, max) > 0 {
                        maxAngle = angle
                        maxPoint = point
                    }
                    if Utility.angleSubtract(angle, min) < 0 {
                        minAngle = angle
                        minPoint = point
                    }
                } else {
                    maxAngle = angle
                    minAngle = angle
                    maxPoint = point
                    minPoint = point
                }
            }
            
            // crop the segment with the circle sector of vision
            if let croppedSeg = Utility.cropSegmentWithSector(
                start: maxPoint, end: minPoint, center: self.position, radius: self.visionRange,
                startAngle: startAngle, endAngle: endAngle) {
                
                // make coodinates relative to enemy position
                // and make sure the first point of the tuple has lower angle
                let p1 = CGPointSubtract(croppedSeg.0, self.position)
                let p2 = CGPointSubtract(croppedSeg.1, self.position)
                let angle1 = CGPointToAngle(p1)
                let angle2 = CGPointToAngle(p2)
                if  angle1 < angle2 {
                    segments.append((p1, p2, angle1, angle2))
                } else {
                    segments.append((p2, p1, angle2, angle1))
                }
            }
        }
        
        // sort by min point's angle
        // better to sort both min and max points...???
        segments.sort { (seg1: (CGPoint, CGPoint, CGFloat, CGFloat),
                         seg2: (CGPoint, CGPoint, CGFloat, CGFloat)) -> Bool in
            return Utility.angleSubtract(seg1.2, seg2.2) < 0
        }
        
        var ends: [(angle: CGFloat, segid: Int, isStart: Bool)] = []
        for (i, seg) in segments.enumerated() {
            ends.append((angle: seg.minAngle, segid: i, isStart: true))
            ends.append((angle: seg.maxAngle, segid: i, isStart: false))
        }
        
        ends.sort { (end1: (CGFloat, Int, Bool), end2: (CGFloat, Int, Bool)) -> Bool in
            return Utility.angleSubtract(end1.0, end2.0) < 0
        }
        
        // create path
        let fovPath = CGMutablePath()
        
        if segments.isEmpty {
            // if no segments inside, create sector path
            fovPath.move(to: CGPoint(x: 0, y: 0))
            fovPath.addArc(center: CGPoint.zero, radius: visionRange,
                           startAngle: startAngle, endAngle: endAngle, clockwise: false)
            fovPath.addLine(to: CGPoint.zero)
        } else {
            fovPath.move(to: CGPoint(x: 0, y: 0))
            
            // initial arc
//            if Utility.angleSubtract(segments[0].minAngle, startAngle) > 0.001 {
//                fovPath.addArc(center: CGPoint.zero, radius: visionRange,
//                               startAngle: startAngle, endAngle: segments[0].minAngle, clockwise: false)
//            }
            
            var lastSegId: Int = -1
            var lastEndIsStart: Bool = false
            var lastAngle: CGFloat = startAngle
            var segsAlive = Set<Int>()
            
            for end in ends {
                // update segsAlive
                if end.isStart {
                    segsAlive.insert(end.segid)
                } else {
                    segsAlive.remove(end.segid)
                }
                
                if !lastEndIsStart {
                    // if last end was end point
                    if end.isStart {
                        // if next end is start point, put arc between
                        if lastAngle < end.angle {
                            fovPath.addArc(center: CGPoint.zero, radius: visionRange,
                                           startAngle: lastAngle, endAngle: end.angle,
                                           clockwise: false)
                        } else {
                            fovPath.addLine(to: segments[end.segid].min)
                        }
                        fovPath.addLine(to: segments[end.segid].min)
                        lastSegId = end.segid
                        lastEndIsStart = true
                        // lastAngle = end.angle
                    } else {
                        // if next end is end
                    }
                } else {
                    // if last end was start point
                    if end.isStart {
                        // if next end is start point
                        let pointOnSeg = Utility.intersectionOfLines(start1: CGPoint.zero,
                            end1: CGPointMultiplyScalar(CGPointForAngle(end.angle), visionRange * 2),
                            start2: segments[lastSegId].min, end2: segments[lastSegId].max)!
                        if CGPointLength(segments[end.segid].min) < CGPointLength(pointOnSeg) {
                            // stop current segment and switch to closer segment
                            fovPath.addLine(to: pointOnSeg)
                            fovPath.addLine(to: segments[end.segid].min)
                            lastSegId = end.segid
                            lastEndIsStart = true
                            lastAngle = end.angle
                        } else {
                            
                        }
                    } else {
                        // if next end is end point
                        if lastSegId == end.segid {
                            // if on the same segment, finish the segment
                            fovPath.addLine(to: segments[end.segid].max)
                            
                            // if there's ongoing segments, switch to the closest of them
                            if segsAlive.count > 0 {
                                var closest: CGPoint?
                                var closestSegId = -1
                                var minDis = visionRange
                                for seg2 in segsAlive {
                                    let pointOnSeg2 = Utility.intersectionOfLines(
                                        start1: CGPoint.zero,
                                        end1: CGPointMultiplyScalar(CGPointForAngle(end.angle), visionRange * 2),
                                        start2: segments[seg2].min, end2: segments[seg2].max)!
                                    let dis = CGPointLength(pointOnSeg2)
                                    if  dis < minDis {
                                        closest = pointOnSeg2
                                        closestSegId = seg2
                                        minDis = dis
                                    }
                                }
                                fovPath.addLine(to: closest!)
                                lastSegId = closestSegId
                                lastEndIsStart = true
                                lastAngle = end.angle
                            } else {
                                lastEndIsStart = false
                                lastAngle = end.angle
                            }
                        } else {
                            // if another segment's end
                        }
                    }
                }
            }
            
            if Utility.angleSubtract(lastAngle, endAngle) < -0.001 {
                fovPath.addArc(center: CGPoint.zero, radius: visionRange,
                               startAngle: lastAngle, endAngle: endAngle, clockwise: false)
            }
            
            fovPath.addLine(to: CGPoint.zero)
        }
        
        // for debug
//        for seg in segments {
//            fovPath.addEllipse(in: CGRect(origin: seg.min, size: CGSize(width: 10, height: 10)))
//            fovPath.addEllipse(in: CGRect(origin: seg.max, size: CGSize(width: 10, height: 10)))
//        }
        self.visionIndicator.path = fovPath
        self.visionIndicator.zRotation = -self.zRotation
    }

    func detect(target: SKSpriteNode) {
        let vec = CGPointSubtract(target.position, self.position)
        
        // check distance
        if CGPointLength(vec) > self.visionRange {
            return
        }
        
        // check angle
        let angle = fabs( (CGPointToAngle(vec) - self.zRotation).remainder(dividingBy: (CGFloat)(M_PI * 2)) )
        if angle > self.fieldOfView {
            return
        }
        
        // check obstacles
        var unobstructed = true
        self.scene?.physicsWorld.enumerateBodies(alongRayStart: self.position, end: target.position) {
            (body: SKPhysicsBody, point: CGPoint, normal: CGVector, stop: UnsafeMutablePointer<ObjCBool>) in
            if body.categoryBitMask == CollisionBitmask.wall {
                unobstructed = false
                stop.pointee = true
            }
        }
        
        if unobstructed {
            SwiftEventBus.post(GameConst.Enemy.foundPlayer, sender: self)
        }
    }
}
