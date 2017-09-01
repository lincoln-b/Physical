import SpriteKit

class Game {

    let player = SKSpriteNode(imageNamed: "zerox")
    let backgroundMusic = SKAudioNode(fileNamed: "Arcade Funk.mp3")
    var monsters = [SKSpriteNode]()
    var score = 0
    
    var size: CGSize!
    var scene: GameScene!
    
    func setup(scene: GameScene) {
        self.scene = scene
        self.size = scene.size
        scene.physicsWorld.gravity = CGVector.zero
        scene.physicsWorld.contactDelegate = scene
        
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.2)
        backgroundMusic.autoplayLooped = true
    }
    
    func run() {
        scene.run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(scene.addMonster),
                SKAction.wait(forDuration: 1.0)
                ])
        ))
    }
    
    func addMonster() -> SKSpriteNode {
        let monster = SKSpriteNode(imageNamed: "slime")
        
        monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size)
        monster.physicsBody?.isDynamic = true
        monster.physicsBody?.categoryBitMask = PhysicsCategory.Slime
        monster.physicsBody?.contactTestBitMask = PhysicsCategory.Shroom
        monster.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        let actualX = random(min: monster.size.width/2, max: size.width - monster.size.width/2)
        
        monster.position = CGPoint(x: actualX, y: size.height - monster.size.height/2)
        
        monsters.append(monster)
        
        // Determine speed of the monster
        let actualDuration = random(min: CGFloat(6.0), max: CGFloat(12.0))
        
        // Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: monster.size.height/3), duration: TimeInterval(actualDuration))
        
        monster.run(SKAction.sequence([
            SKAction.group([
                SKAction.repeatForever(SKAction.sequence([
                    SKAction.scale(by: 1.25, duration: 0.4),
                    SKAction.scale(by: 0.8, duration: 0.4)
                    ])),
                actionMove
                ])
            ]))
        
        return monster
    }
    
    func frameLogic() {
        for monster in monsters {
            if monster.position.y <= monster.size.height/2 {
                monsters.remove(at: monsters.index(of: monster)!)
                monster.removeFromParent()
                
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameOverScene = GameOverScene(size: self.size)
                scene.view?.presentScene(gameOverScene, transition: reveal)
            }
        }
    }
    
    func addProjectile(touchLocation: CGPoint) -> SKSpriteNode? {
        
        scene.run(SKAction.playSoundFileNamed("Throw Mushroom.mp3", waitForCompletion: false))
        
        let projectile = SKSpriteNode(imageNamed: "shroom")
        projectile.position = player.position
        
        projectile.physicsBody = SKPhysicsBody(
            rectangleOf: CGSize(width: projectile.size.width, height: projectile.size.height/2),
            center: CGPoint(x: projectile.size.width/2, y: projectile.size.height/4)
        )
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.Shroom
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Slime
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        
        let offset = touchLocation - projectile.position
        if (offset.y < 0) { return nil }
        
        let direction = offset.normalized()
        let shootAmount = direction * 1000
        let realDest = shootAmount + projectile.position
        
        let actionMove = SKAction.move(to: realDest, duration: 2.0)
        let actionSpin = SKAction.rotate(byAngle: CGFloat.pi * random(min: -10.0, max: 10.0), duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([
            SKAction.group([actionMove, actionSpin]),
            actionMoveDone
            ]))
        
        return projectile
        
    }
    
    func projectileDidCollideWithMonster(projectile: SKSpriteNode, monster: SKSpriteNode) {
        projectile.removeFromParent()
        monster.removeFromParent()
        monsters.remove(at: monsters.index(of: monster)!)
        score += 1
    }
}
