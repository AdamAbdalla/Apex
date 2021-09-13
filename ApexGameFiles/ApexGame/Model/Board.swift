//
//  Board.swift
//  ApexGame
//
//  Created by Adam Abdalla on 4/12/20.
//  Copyright © 2020 Adam Abdalla. All rights reserved.
//

import Foundation
import SpriteKit

class Board {
    //var targets: [Target]!
    var board: [[Target?]]!
    var nextBoard: [[Target?]]
    var lives: Int
    let width = 5
    let height = 8
    let targetCount = 10
    var countPressed = 0
    let directions = [0: [0, 1], 1: [1, 0], 2: [0, -1], 3: [-1, 0]]
    
    init() {
        self.board = [[Target?]]()
        self.nextBoard = [[Target?]]()
        for i in 0 ... height - 1 {
            self.board.append([Target]())
            self.nextBoard.append([Target]())
            for _ in 0 ... width - 1{
                self.board[i].append(nil)
                self.nextBoard[i].append(nil)
            }
        }
        self.lives = 3
        for _ in 0 ... targetCount - 1{
            let t = Target().spawn()
            let _ = placeRandom(target: t)
        }
    }
    
    func placeRandom(target: Target) -> [Int]{
        var r = Int.random(in: 0 ... height - 1)
        var c = Int.random(in: 0 ... width - 1)
        while !(board[r][c] == nil || board[r][c]!.pressed) || !(nextBoard[r][c] == nil || nextBoard[r][c]!.pressed){
            r = Int.random(in: 0 ... height - 1)
            c = Int.random(in: 0 ... width - 1)
        }
        board[r][c] = target
        nextBoard[r][c] = target
        return [r, c]
    }
    
    func setNext() -> [TargetPoint] {
        var moves = [TargetPoint]()
        for r in 0 ... height - 1 {
            for c in 0 ... width - 1 {
                if let target = board[r][c] {
                    if (!target.pressed) && target == nextBoard[r][c] {
                        var checked = [false, false, false, false]
                        var numcounted = 0
                        while numcounted < 3 {
                            var i = Int.random(in: 0 ... 3)
                            if !checked[i]{
                                let dir = directions[i]!
                                let nr = r + dir[0]
                                let nc = c + dir[1]
                                if nr >= 0 && nr < height && nc >= 0 && nc < width && (board[nr][nc] == nil
                                    || board[nr][nc]!.pressed) && (nextBoard[nr][nc] == nil || nextBoard[nr][nc]!.pressed) {
                                    nextBoard[nr][nc] = target
                                    nextBoard[r][c] = nil
                                    moves.append(TargetPoint(target: target, origin: [r, c], destination: [nr, nc]))
                                    break
                                }
                                checked[i] = true
                                numcounted += 1
                                i = Int.random(in: 0 ... 3)
                            }
                        }
                    }
                }
            }
        }
        return moves
    }
}

struct TargetPoint {
    let target: Target
    let origin: [Int]
    let destination: [Int]
}

