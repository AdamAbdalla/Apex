//
//  Target.swift
//  ApexGame
//
//  Created by Adam Abdalla on 4/12/20.
//  Copyright © 2020 Adam Abdalla. All rights reserved.
//

import Foundation
import SpriteKit

func == (lhs: Target, rhs: Target) -> Bool {
    return lhs.sprite == rhs.sprite
}
class Target: Equatable {
    var size: Int
    var opacity: Float
    var speed: Float
    var pressed: Bool
    var sprite: SKSpriteNode?
    static var maxSize = 70
    static var minSize = 15
    static let minOpacity: Float = 0.1
    static let minSpeed: Float = 0.1
    static var startSize = 50
    static let startOpacity: Float = 1
    static let startSpeed: Float = 0.2
    
    init(size: Int, opacity: Float, speed: Float) {
        self.size = size
        self.opacity = opacity
        self.speed = speed
        self.sprite = nil
        self.pressed = false
    }
    
    init() {
        self.size = Target.startSize
        self.opacity = Target.startOpacity
        self.speed = Target.startSpeed
        self.sprite = nil
        self.pressed = false
    }
    
    func connectSprite(sprite: SKSpriteNode) {
        self.sprite = sprite
        sprite.size = CGSize(width: size, height: size)
        sprite.color = sprite.color.withAlphaComponent(CGFloat(opacity))
        self.pressed = false
    }
    
    func spawn() -> Target {
        var sSize = size + Int.random(in: -8 ... 8)
        var sOpacity = opacity + Float.random(in: -0.2 ... 0.2)
        var sSpeed = speed + Float.random(in: -0.2 ... 0.2)
        sSize = min(max(sSize, Target.minSize), Target.maxSize)
        sOpacity = min(max(sOpacity, Target.minOpacity), 1)
        sSpeed = min(max(sSpeed, Target.minSpeed), 1)
        return Target(size: sSize, opacity: sOpacity, speed: sSpeed)
    }
    
    func press() {
        self.pressed = true
        sprite?.removeFromParent()
    }
}
