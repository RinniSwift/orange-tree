//
//  GameScene.swift
//  OrangeTree
//
//  Created by Rinni Swift on 9/19/18.
//  Copyright © 2018 Rinni Swift. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var orangeTree: SKSpriteNode!
    var orange: Orange?
    var touchStart: CGPoint = .zero
    var shapeNode = SKShapeNode()
    var boundary = SKNode()
    var numOfLevels: UInt32 = 2
    
    // class method to load .sks files
    static func Load(level: Int) -> GameScene? {
        return GameScene(fileNamed: "Level-\(level)")
    }
    
    override func didMove(to view: SKView) {
        // connect game objects
        orangeTree = childNode(withName: "tree") as! SKSpriteNode
        
        // configure shape node
        shapeNode.lineWidth = 20
        shapeNode.lineCap = .round
        shapeNode.strokeColor = UIColor(white: 1, alpha: 0.3)
        addChild(shapeNode)
        
        // set the contact delegate
        physicsWorld.contactDelegate = self
        
        // set up the boundaries
        boundary.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(origin: .zero, size: size))
        boundary.position = .zero
        addChild(boundary)
        
        // add the sun to the scene
        let sun = SKSpriteNode(imageNamed: "Sun")
        sun.name = "sun"
        sun.position.x = size.width - (sun.size.width * 0.75)
        sun.position.y = size.height - (sun.size.height * 0.75)
        addChild(sun)
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // get the location of the touch on screen
        let touches = touches.first!
        let location = touches.location(in: self)
        
        // check if touch is on the orange tree
        if atPoint(location).name == "tree" {
            // create orange at the touched location on the tree
            orange = Orange()
            orange?.physicsBody?.isDynamic = false
            orange?.position = location
            addChild(orange!)
            
            // store the location of the touch
            touchStart = location
        }
        
        // change level when sun is touched
        for node in nodes(at: location) {
            if node.name == "sun" {
                let n = Int(arc4random() % numOfLevels + 1)
                if let scene = GameScene.Load(level: n) {
                    scene.scaleMode = .aspectFill
                    if let view = view {
                        view.presentScene(scene)
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // get location of the touch
        let touch = touches.first!
        let location = touch.location(in: self)
        
        // update location of orange on the orane tree
        orange?.position = location
        
        // draw the firing vector
        let path = UIBezierPath()
        path.move(to: touchStart)
        path.addLine(to: location)
        shapeNode.path = path.cgPath
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        
        // get difference of start and end point of drag distance
        let dx = (touchStart.x - location.x) * 0.7
        let dy = (touchStart.y - location.y) * 0.7
        let vector = CGVector(dx: dx, dy: dy)
        
        // set orange dynamic and apply vector as impulse
        orange?.physicsBody?.isDynamic = true
        orange?.physicsBody?.applyImpulse(vector)
        
        // remove firing vector
        shapeNode.path = nil
    }
}

extension GameScene: SKPhysicsContactDelegate {
    // called when two nodes collide
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        //check that the bodies of the node collide hard enough
        if contact.collisionImpulse > 15 {
            if nodeA?.name == "skull" {
                removeSkull(node: nodeA!)
            } else if nodeB?.name == "skull" {
                removeSkull(node: nodeB!)
            }
        }
    }
    
    // function used to remove skull from scene
    func removeSkull(node: SKNode) {
        node.removeFromParent()
    }
}









