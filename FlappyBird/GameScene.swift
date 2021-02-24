//
//  GameScene.swift
//  FlappyGame
//
//  Created by Sai Balaji on 24/02/21.
//

import SpriteKit
import GameplayKit

var isAlive = true
var score = 0
var upgravity = CGVector(dx: 0, dy: 10)
var downgravity = CGVector(dx: 0, dy: -10)


struct PhysicsCategory
{
   static let player: UInt32 = 1
   static let ground: UInt32 = 2
   static let pipe: UInt32 = 3
  
    
}



class GameScene: SKScene,SKPhysicsContactDelegate {
    
    
    
    
    var textureAtLas = SKTextureAtlas(named: "bird")
    var textures = [SKTexture]()
    
    
    
    var scorelbl: SKLabelNode!
    var player: SKSpriteNode!
    var groundpipe: SKSpriteNode!
    var roofpipe: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        let backgroundImage = SKSpriteNode(imageNamed: "flappy-bird-background-11")
        backgroundImage.size = CGSize(width: frame.size.width, height: frame.size.height)
        backgroundImage.position = CGPoint(x: frame.midX, y: frame.midY)
        backgroundImage.zPosition = -1
        
        addChild(backgroundImage)
        
        let landImage = SKSpriteNode(imageNamed: "land")
        landImage.size = CGSize(width: frame.size.width, height:200)
        landImage.position = CGPoint(x: frame.midX, y: frame.midY - 500)
        landImage.physicsBody = SKPhysicsBody(rectangleOf: landImage.size)
        landImage.physicsBody?.isDynamic = false
        landImage.physicsBody?.categoryBitMask = PhysicsCategory.pipe
        landImage.physicsBody?.contactTestBitMask = PhysicsCategory.player
        landImage.name = "pipe"
        addChild(landImage)
        
        
        scorelbl = SKLabelNode()
       
        scorelbl.fontName = "Futura"
        scorelbl.fontSize = 60
        scorelbl.fontColor = UIColor.white
        scorelbl.position = CGPoint(x: frame.midX - 180, y: frame.midY + 500)
        addChild(scorelbl)
       
       
        for i in 1..<textureAtLas.textureNames.count
        {
            let name = "bird-0\(i).png"
            print(name)
            textures.append(SKTexture(imageNamed: name))
        }
        
       
        SpawnPlayer()
        
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(RandomPipes), userInfo: nil, repeats: true)
        
        
        
    
        
     
    }
    
    
    func SpawnGroundPipe()
    {
         
        groundpipe = SKSpriteNode(imageNamed: "PipeUp")
        groundpipe.position = CGPoint(x: frame.midX + 300, y: frame.midY - 220)
        groundpipe.size = CGSize(width: 80, height: Int.random(in: 315...450))
        groundpipe.physicsBody = SKPhysicsBody(rectangleOf: groundpipe.size)
        groundpipe.physicsBody?.categoryBitMask = PhysicsCategory.pipe
        groundpipe.physicsBody?.contactTestBitMask = PhysicsCategory.player
        
        groundpipe.physicsBody?.isDynamic = false
        groundpipe.name = "pipe"
        addChild(groundpipe)
        let moveToLeft = SKAction.moveTo(x: -1000, duration: 1.5)
        let wait = SKAction.wait(forDuration: 2.0)
        let destroy = SKAction.run {
            self.groundpipe.removeFromParent()
        }
        
        
        groundpipe.run(SKAction.sequence([moveToLeft,wait,destroy]))
        
        

    }
    
    func SpawnRoofPipe()
    {
       
        
       roofpipe = SKSpriteNode(imageNamed: "PipeDown")
       roofpipe.position = CGPoint(x: frame.midX + 400, y: frame.midY + 400)
        roofpipe.size = CGSize(width: 80, height: Int.random(in: 315...500))
        roofpipe.physicsBody = SKPhysicsBody(rectangleOf: roofpipe.size)
       roofpipe.physicsBody?.categoryBitMask = PhysicsCategory.pipe
        roofpipe.physicsBody?.contactTestBitMask = PhysicsCategory.player
        
       roofpipe.physicsBody?.isDynamic = false
        roofpipe.name = "pipe"
        addChild(roofpipe)
        let moveToLeft = SKAction.moveTo(x: -1000, duration: 1.5)
        
        let wait = SKAction.wait(forDuration: 2.0)
        let destroy = SKAction.run {
            self.roofpipe.removeFromParent()
        }
        
        
        roofpipe.run(SKAction.sequence([moveToLeft,wait,destroy]))
        
    }
    
    func SpawnPlayer()
    {
        player = SKSpriteNode(imageNamed:"bird-1")
        player.size = CGSize(width: 80, height: 80)
        player.position = CGPoint(x: frame.midX - 200, y: frame.midY)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.categoryBitMask = PhysicsCategory.player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.pipe
        player.physicsBody?.isDynamic = true
        player.physicsBody?.affectedByGravity = true
        player.name = "player"
        addChild(player)
        
        player.run(SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.1)))

      
    }
    
    @objc
    func RandomPipes()
    {
        if(isAlive == true)
        {
        let i = Int.random(in: 0...1)
        if(i==0)
        {
            print(i)
            score = score + 1
            scorelbl.text = "Score: \(score)"
            self.SpawnRoofPipe()
        }
        else if (i==1)
        {
            print(i)
            score = score + 1
            scorelbl.text = "Score: \(score)"
            self.SpawnGroundPipe()
        }
        }
        else
        {
            scorelbl.text = "Bird Dead"
            scorelbl.fontSize = 80
            scorelbl.fontName = "Futura"
            scorelbl.position = CGPoint(x: frame.midX, y: frame.midY)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        physicsWorld.gravity = upgravity
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        physicsWorld.gravity = downgravity
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if(bodyA.node?.name == "player" && bodyB.node?.name == "pipe" || bodyB.node?.name == "player" && bodyA.node?.name == "pipe"  )
        {
            isAlive = false
            player.removeFromParent()
        }
    }
    
    
    
    
    
    
    
}

