import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var game = Game()
    
    override func didMove(to view: SKView) {
        game.setup(scene: self)
        
        addChild(game.player)
        addChild(game.backgroundMusic)
        
        game.run()
    }
    
    func addMonster() {
        addChild(game.addMonster())
    }
    
    override func didEvaluateActions() {
        game.frameLogic()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        
        let projectile: SKSpriteNode? = game.addProjectile(touchLocation: touchLocation)
        if projectile != nil {
            addChild(projectile!)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Slime != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Shroom != 0)) {
            if let monster = firstBody.node as? SKSpriteNode, let
                projectile = secondBody.node as? SKSpriteNode {
                game.projectileDidCollideWithMonster(projectile: projectile, monster: monster)
            }
        }
        
    }
}
