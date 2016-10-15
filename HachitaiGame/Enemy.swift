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
    
    
    let fieldOfView = CGFloat(M_PI / 5)
    let visionRange: CGFloat = 200.0
    let walkDistance: CGFloat = 100.0
    
    private var visionIndicator: SKShapeNode!
    private var patrolAnimation: SKAction!
    
    required init(){
        super.init(texture: nil, color: UIColor.red, size: CGSize(width:20, height:20))
        
//        let directionIndicator = Utility.makeArrow()
//        self.addChild(directionIndicator)
        
        visionIndicator = SKShapeNode()
        visionIndicator.strokeColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.4)
        visionIndicator.lineWidth = 2.0
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
        let segments: [(min: CGPoint, max: CGPoint)] = []
        
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
            var maxPointIndex = 0
            var minPointIndex = 0
            
            var maxAngle: CGFloat? = nil
            var minAngle: CGFloat? = nil
            for (i, point) in vertices.enumerated() {
                let angle = CGPointToAngle(CGPointSubtract(point, self.position))
                if let max = maxAngle, let min = minAngle {
                    if Utility.angleSutract(angle, max) > 0 {
                        maxAngle = angle
                        maxPointIndex = i
                    }
                    if Utility.angleSutract(angle, min) < 0 {
                        minAngle = angle
                        minPointIndex = i
                    }
                } else {
                    maxAngle = angle
                    minAngle = angle
                    maxPointIndex = i
                    minPointIndex = i
                }
            }

            let minInside = CGPointDistance(self.position, vertices[minPointIndex]) < visionRange
            let maxInside = CGPointDistance(self.position, vertices[maxPointIndex]) < visionRange
            
            // if both points are too far, ignore this obstacle
            if !minInside && !maxInside {
                continue
            }
            
            if Utility.angleDiff(maxAngle!, self.zRotation) < self.fieldOfView {
                // if max point in FoV
                if Utility.angleDiff(minAngle!, self.zRotation) < self.fieldOfView {
                    // if min point in FoV
                    if minInside ^ maxInside {
                        // if the segment intersects with the arc
                        let intersection = 0
                    } else {
                        
                    }
                } else {
                    
                }
            } else if Utility.angleDiff(minAngle!, self.zRotation) < self.fieldOfView {
                
            } else {
                continue
            }
            // crop the segment so that it is inside the vision fan
        }
        
        let fovPath = CGMutablePath()
        fovPath.move(to: CGPoint(x: 0, y: 0))
        fovPath.addArc(center: CGPoint.zero, radius: visionRange, startAngle: -fieldOfView, endAngle: fieldOfView, clockwise: false)
        fovPath.addLine(to: CGPoint.zero)
        
        self.visionIndicator.path = fovPath
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
            if let node = body.node {
                if let _ = node as? ObstacleSpriteNode {
                    unobstructed = false
                    stop.pointee = true
                }
            }
        }
        
        if unobstructed {
            SwiftEventBus.post(GameConst.Enemy.foundPlayer, sender: self)
        }
    }
}
