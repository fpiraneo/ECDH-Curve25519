//
//  MontgomeryLadderStepOperations.swift
//  ECDH-Curve25519
//
//  Created by Francesco Piraneo G. on 03.05.19.
//  Copyright © 2019 Francesco Piraneo G. All rights reserved.
//

import Foundation

class MontgomeryOperations {
    /// Curve25519 uses a so-called differential-addition chain proposed by Montgomery to multiply a point,
    /// identified only by its x-coordinate, by a scalar
    internal static func ScalarMultiplication(_ n: [UInt8], _ p: [UInt8], _ qSize: Int) -> [UInt8] {
        var q = [UInt8].init(repeating: 0, count: qSize)
        let p0 = FieldElementOperations.FromBytes(data: p)
        let q0 = CalculateLadderStep(n, p0)
        FieldElementOperations.ToBytes(&q, q0)
        
        return q
    }
    
    private static func CalculateLadderStep(_ n: [UInt8], _ p: FieldElement, noffset: Int = 0) -> FieldElement {
        var e = [UInt8].init(repeating: 0, count: 32)
    
        for i in 0..<32 {
            e[i] = n[noffset + i]
        }
        
        ClampOperation.Clamp(&e, offset: 0)
        let x1: FieldElement = p
        var x2: FieldElement = FieldElementOperations.Set1()
        var z2: FieldElement = FieldElementOperations.Set0()
        var x3: FieldElement = x1
        var z3: FieldElement = FieldElementOperations.Set1()
        
        var swap: UInt = 0
    
        for pos in stride(from: 254, through: 0, by: -1) {
            var b = UInt(e[pos / 8] >> (pos & 7))
            b &= 1
            swap ^= b
            FieldElementOperations.Swap(&x2, &x3, swap)
            FieldElementOperations.Swap(&z2, &z3, swap)
            swap = b

            var tmp0 = FieldElementOperations.Sub(x3, z3)           // D = X3-Z3
            var tmp1 = FieldElementOperations.Sub(x2, z2)           // B = X2-Z2
            x2 = FieldElementOperations.Add(x2, z2)                 // A = X2+Z2
            z2 = FieldElementOperations.Add(x3, z3)                 // C = X3+Z3
            z3 = FieldElementOperations.Multiplication(tmp0, x2)    // DA = D*A
            z2 = FieldElementOperations.Multiplication(z2, tmp1)    // CB = C*B
            tmp0 = FieldElementOperations.Squared(tmp1)             // BB = B^2
            tmp1 = FieldElementOperations.Squared(x2)               // AA = A^2
            x3 = FieldElementOperations.Add(z3, z2)                 // t0 = DA+CB
            z2 = FieldElementOperations.Sub(z3, z2)                 // t1 = DA-CB
            x2 = FieldElementOperations.Multiplication(tmp1, tmp0)  // X4 = AA*BB
            tmp1 = FieldElementOperations.Sub(tmp1, tmp0)           // E = AA-BB
            z2 = FieldElementOperations.Squared(z2)                 // t2 = t1^2
            z3 = FieldElementOperations.Multiply121666(tmp1)        // t3 = a24*E
            x3 = FieldElementOperations.Squared(x3)                 // X5 = t0^2
            tmp0 = FieldElementOperations.Add(tmp0, z3)             // t4 = BB+t3
            z3 = FieldElementOperations.Multiplication(x1, z2)      // Z5 = X1*t2
            z2 = FieldElementOperations.Multiplication(tmp1, tmp0)  // Z4 = E*t4
        }
    
        FieldElementOperations.Swap(&x2, &x3, swap)
        FieldElementOperations.Swap(&z2, &z3, swap)
        z2 = FieldElementOperations.Invert(z2)
        return FieldElementOperations.Multiplication(x2, z2)
    }
}
