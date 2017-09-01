/*
 
 Categories for the physics engine.
 
 */

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Slime   : UInt32 = 0b1       // 1
    static let Shroom: UInt32 = 0b10      // 2
}
