//
//  SalsaCore.swift
//  ECDH-Curve25519
//
//  Created by Francesco Piraneo G. on 30.04.19.
//  Copyright © 2019 Francesco Piraneo G. All rights reserved.
//

import Foundation

class SalsaCore {
    static func Salsa20(state: inout Array16<UInt32>, doubleRounds: Int) {
        for _ in 0..<doubleRounds {
            state.X4 ^= ((state.X0 &+ state.X12) << 7) | ((state.X0 &+ state.X12) >> 25)
            state.X8 ^= ((state.X4 &+ state.X0) << 9) | ((state.X4 &+ state.X0) >> 23)
            state.X12 ^= ((state.X8 &+ state.X4) << 13) | ((state.X8 &+ state.X4) >> 19)
            state.X0 ^= ((state.X12 &+ state.X8) << 18) | ((state.X12 &+ state.X8) >> 14)
            
            // row 1
            state.X9 ^= ((state.X5 &+ state.X1) << 7) | ((state.X5 &+ state.X1) >> 25)
            state.X13 ^= ((state.X9 &+ state.X5) << 9) | ((state.X9 &+ state.X5) >> 23)
            state.X1 ^= ((state.X13 &+ state.X9) << 13) | ((state.X13 &+ state.X9) >> 19)
            state.X5 ^= ((state.X1 &+ state.X13) << 18) | ((state.X1 &+ state.X13) >> 14)
            
            // row 2
            state.X14 ^= ((state.X10 &+ state.X6) << 7) | ((state.X10 &+ state.X6) >> 25)
            state.X2 ^= ((state.X14 &+ state.X10) << 9) | ((state.X14 &+ state.X10) >> 23)
            state.X6 ^= ((state.X2 &+ state.X14) << 13) | ((state.X2 &+ state.X14) >> 19)
            state.X10 ^= ((state.X6 &+ state.X2) << 18) | ((state.X6 &+ state.X2) >> 14)
            
            // row 3
            state.X3 ^= ((state.X15 &+ state.X11) << 7) | ((state.X15 &+ state.X11) >> 25)
            state.X7 ^= ((state.X3 &+ state.X15) << 9) | ((state.X3 &+ state.X15) >> 23)
            state.X11 ^= ((state.X7 &+ state.X3) << 13) | ((state.X7 &+ state.X3) >> 19)
            state.X15 ^= ((state.X11 &+ state.X7) << 18) | ((state.X11 &+ state.X7) >> 14)
            
            // column 0
            state.X1 ^= ((state.X0 &+ state.X3) << 7) | ((state.X0 &+ state.X3) >> 25)
            state.X2 ^= ((state.X1 &+ state.X0) << 9) | ((state.X1 &+ state.X0) >> 23)
            state.X3 ^= ((state.X2 &+ state.X1) << 13) | ((state.X2 &+ state.X1) >> 19)
            state.X0 ^= ((state.X3 &+ state.X2) << 18) | ((state.X3 &+ state.X2) >> 14)
            
            // column 1
            state.X6 ^= ((state.X5 &+ state.X4) << 7) | ((state.X5 &+ state.X4) >> 25)
            state.X7 ^= ((state.X6 &+ state.X5) << 9) | ((state.X6 &+ state.X5) >> 23)
            state.X4 ^= ((state.X7 &+ state.X6) << 13) | ((state.X7 &+ state.X6) >> 19)
            state.X5 ^= ((state.X4 &+ state.X7) << 18) | ((state.X4 &+ state.X7) >> 14)
            
            // column 2
            state.X11 ^= ((state.X10 &+ state.X9) << 7) | ((state.X10 &+ state.X9) >> 25)
            state.X8 ^= ((state.X11 &+ state.X10) << 9) | ((state.X11 &+ state.X10) >> 23)
            state.X9 ^= ((state.X8 &+ state.X11) << 13) | ((state.X8 &+ state.X11) >> 19)
            state.X10 ^= ((state.X9 &+ state.X8) << 18) | ((state.X9 &+ state.X8) >> 14)
            
            // column 3
            state.X12 ^= ((state.X15 &+ state.X14) << 7) | ((state.X15 &+ state.X14) >> 25)
            state.X13 ^= ((state.X12 &+ state.X15) << 9) | ((state.X12 &+ state.X15) >> 23)
            state.X14 ^= ((state.X13 &+ state.X12) << 13) | ((state.X13 &+ state.X12) >> 19)
            state.X15 ^= ((state.X14 &+ state.X13) << 18) | ((state.X14 &+ state.X13) >> 14)
        }
    }
}
