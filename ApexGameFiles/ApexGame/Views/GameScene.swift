//
//  GameScene.swift
//  ApexGame
//
//  Created by Adam Abdalla on 4/12/20.
//  Copyright © 2020 Adam Abdalla. All rights reserved.
//

import UIKit
import SpriteKit

class GameScene: SKScene {
    var score = 0
    var timed = true
    var board: Board? = nil
    var boardWidth: CGFloat? = nil
    var boardHeight: CGFloat? = nil
    var timeLabel: UILabel!
    var scoreLabel: UILabel!
    var pressed = [Target]()
    var startTime: Date? = nil
    var lifeIndicators: [UILabel]? = nil
    var viewController: GameViewController? = nil
    var currentColor = UIColor(named: "purple")!
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(named: "background")!
        if let skscene = scene {
            let size = skscene.size
            boardWidth = size.width
            boardHeight = size.height
            Target.maxSize = min(Int(boardWidth! / 5), Int(boardHeight! / 8))
        }
        board = Board()
        for r in 0 ... board!.height - 1 {
            for c in 0 ... board!.width - 1{
                if let target = board!.board[r][c] {
                    let s = SKSpriteNode(imageNamed: "whitecircle.png")
                    s.colorBlendFactor = 1
                    s.color = currentColor
                    target.connectSprite(sprite: s)
                    s.position = pointToCGPoint(r: r, c: c)
                    addChild(s)
                }
            }
        }
        startTime = Date()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, let b = board {
            for r in 0 ... b.board.count - 1 {
                for c in 0 ... b.board[r].count - 1 {
                    if let target = b.board[r][c], let sprite = target.sprite {
                        if !target.pressed && sprite.contains(touch.location(in: scene!)) {
                            target.press()
                            pressed.append(target)
                            b.countPressed += 1
                            score += 1
                            scoreLabel.text = String(score)
                            checkRoundEnd()
                            return
                        }
                    }
                }
            }
            b.lives -= 1
            lifeIndicators![2 - b.lives].backgroundColor = .clear
            if (b.lives == 0) {
                endGame()
            }
            
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        let sec = 5 + startTime!.timeIntervalSinceNow
        timeLabel.text = String((sec * 10).rounded() / 10)
        if (sec < 0) {
            endGame()
        }
        if let b = board {
            let moves = b.setNext()
            for tp in moves {
                let action = SKAction.move(to: pointToCGPoint(r: tp.destination[0], c: tp.destination[1]), duration: TimeInterval(0.5 / tp.target.speed))
                tp.target.sprite?.run(action) {
                    if b.board[tp.origin[0]][tp.origin[1]] != nil {
                        b.board[tp.origin[0]][tp.origin[1]] = nil
                        b.board[tp.destination[0]][tp.destination[1]] = tp.target
                    }
                }
            }
        }
    }
    
    func checkRoundEnd() {
        if let b = board {
            if (b.countPressed == 5) {
                nextRound()
            } else if b.lives == 0 {
                    endGame()
            }
        }
    }
    
    func nextRound() {
        if let b = board {
            var live = [Target]()
            for r in 0 ... b.board.count - 1 {
                for c in 0 ... b.board[r].count - 1 {
                    if let target = b.board[r][c] {
                        if !target.pressed {
                            live.append(target)
                        }
                    }
                }
            }
            for _ in 0 ... 4 {
                let spawned = live.remove(at: 0).spawn()
                let point = b.placeRandom(target: spawned)
                let sprite = SKSpriteNode(imageNamed: "whitecircle.png")
                sprite.colorBlendFactor = 1
                sprite.color = currentColor
                sprite.position = pointToCGPoint(r: point[0], c: point[1])
                spawned.connectSprite(sprite: sprite)
                scene?.addChild(sprite)
                spawned.pressed = false
            }
            b.countPressed = 0
        }
        startTime = Date()
    }
    
    func endGame() {
        viewController!.performSegue(withIdentifier: "gameToGameOverSegue", sender: view?.window?.rootViewController)
        scene?.isPaused = true
    }
    
    func pointToCGPoint(r: Int, c: Int) -> CGPoint {
        var x = (boardWidth!*0.9)/CGFloat(board!.width)
        x *= (CGFloat(c) + 0.5)
        var y = (boardHeight!*0.9)/CGFloat(board!.height)
        y *= (CGFloat(r) + 0.5)
        return CGPoint(x: x, y: y + 0.5)
    }
}
