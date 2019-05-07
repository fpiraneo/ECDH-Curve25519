//
//  GroupElementOperations.swift
//  ECDH-Curve25519
//
//  Created by Francesco Piraneo G. on 03.05.19.
//  Copyright © 2019 Francesco Piraneo G. All rights reserved.
//

import Foundation

class GroupElementsOperations {
    /// h = a * B
    /// where a = a[0]+256*a[1]+...+256^31 a[31]
    /// B is the Ed25519 base point (x,4/5) with x positive.
    ///
    /// Preconditions:
    /// a[31] <= 127
    internal static func ScalarMultiplicationBase(a: [UInt8], offset: Int = 0) -> GroupElementP3 {
        var e = [Int8].init(repeating: 0, count: 64)
        var carry: Int8 = 0

        var r: GroupElementP1
        var s: GroupElementP2
        var t: GroupElementP4

        for i in 0..<32 {
            e[2 * i + 0] = Int8((a[offset + i] >> 0) & 15)
            e[2 * i + 1] = Int8((a[offset + i] >> 4) & 15)
        }
        
        /* each e[i] is between 0 and 15 */
        /* e[63] is between 0 and 7 */
    
        for i in 1..<63 {
            e[i] += carry
            carry = Int8(e[i] + 8)
            carry >>= 4
            e[i] -= Int8(carry << 4)
        }
        
        e[63] += carry      // Each e[i] is between -8 and 8
    
        var h = GroupElementP3(X: FieldElementOperations.Set0(),
                               Y: FieldElementOperations.Set1(),
                               Z: FieldElementOperations.Set1(),
                               T: FieldElementOperations.Set0()
        )
    
        for i in stride(from: 1, to: 64, by: 2) {
            t = Select(i / 2, e[i])
            r = Madd(h, t)
            h = P1ToP3(r)
        }
        
        r = P3ToP1(h)
        s = P1ToP2(r)
        
        r = P2ToP1(s)
        s = P1ToP2(r)
        
        r = P2ToP1(s)
        s = P1ToP2(r)
        
        r = P2ToP1(s)
        h = P1ToP3(r)
        
        for i in stride(from: 0, to: 64, by: 2) {
            t = Select(i / 2, e[i])
            r = Madd(h, t)
            h = P1ToP3(r)
        }
        
        return h
    }
    
    private static func Equal(_ b: UInt8, _ c: UInt8) -> UInt8 {
//        let x = UInt8(b ^ c)        // 0: yes; 1..255: no
//        var y = UInt(x)             // 0: yes; 1..255: no
//        y = y - 1                   // 4294967295: yes; 0..254: no
//        y >>= 31                    // 1: yes; 0: no
//        return UInt8(y)
        return UInt8((b == c) ? 1 : 0)
    }
    
    private static func Negative(_ b: Int8) -> UInt8 {
//        var x = UInt64(b)   // 18446744073709551361..18446744073709551615: yes; 0..255: no
//        x >>= 63            // 1: yes; 0: no
//        return UInt8(x)
        return UInt8((b < 0) ? 1 : 0)
    }
    
    private static func Cmov(_ t: inout GroupElementP4, _ u: GroupElementP4, _ b: UInt8) {
        FieldElementOperations.Mov(&t.YplusX, u.YplusX, Int(b))
        FieldElementOperations.Mov(&t.YminusX, u.YminusX, Int(b))
        FieldElementOperations.Mov(&t.XY2D, u.XY2D, Int(b))
    }
    
    private static func Select(_ pos: Int, _ b: Int8) -> GroupElementP4 {
        let bnegative: UInt8 = Negative(b)
        let babs = UInt8(abs(b))
        
        var t = GroupElementP4(YplusX: FieldElementOperations.Set1(), YminusX: FieldElementOperations.Set1(), XY2D: FieldElementOperations.Set0())
        
        var table = LookupTables.Base[pos]
        
        Cmov(&t, table[0], Equal(babs, 1))
        Cmov(&t, table[1], Equal(babs, 2))
        Cmov(&t, table[2], Equal(babs, 3))
        Cmov(&t, table[3], Equal(babs, 4))
        Cmov(&t, table[4], Equal(babs, 5))
        Cmov(&t, table[5], Equal(babs, 6))
        Cmov(&t, table[6], Equal(babs, 7))
        Cmov(&t, table[7], Equal(babs, 8))

        let minust = GroupElementP4(YplusX: t.YminusX, YminusX: t.YplusX, XY2D: FieldElementOperations.Negate(t.XY2D))
        Cmov(&t, minust, bnegative)
        
        return t
    }
    
    private static func P3ToP1(_ p: GroupElementP3) -> GroupElementP1 {
        // r = 2 * p
        let q = GroupElementP2(X: p.X, Y: p.Y, Z: p.Z)
        return P2ToP1(q)
    }
    
    private static func P2ToP1(_ p: GroupElementP2) -> GroupElementP1 {
        var r = GroupElementP1(X: FieldElementOperations.Squared(p.X),          // XX = X1^2
                               Y: FieldElementOperations.Add(p.X, p.Y),         // A = X1+Y1
                               Z: FieldElementOperations.Squared(p.Y),          // YY = Y1^2
                               T: FieldElementOperations.DoubleSquare(p.Z))     // B = 2*Z1^2
        
        
        let t0 = FieldElementOperations.Squared(r.Y)    // AA = A^2
        r.Y = FieldElementOperations.Add(r.Z, r.X)      // Y3 = YY+XX
        r.Z = FieldElementOperations.Sub(r.Z, r.X)      // Z3 = YY-XX
        r.X = FieldElementOperations.Sub(t0, r.Y)       // X3 = AA-Y3
        r.T = FieldElementOperations.Sub(r.T, r.Z)      // T3 = B-Z3
        
        return r
    }
    
    private static func P1ToP3(_ p: GroupElementP1) -> GroupElementP3 {
        return GroupElementP3(X: FieldElementOperations.Multiplication(p.X, p.T),
                              Y: FieldElementOperations.Multiplication(p.Y, p.Z),
                              Z: FieldElementOperations.Multiplication(p.Z, p.T),
                              T: FieldElementOperations.Multiplication(p.X, p.Y))
    }
    
    private static func P1ToP2(_ p: GroupElementP1) -> GroupElementP2 {
        return GroupElementP2(X: FieldElementOperations.Multiplication(p.X, p.T),
                              Y: FieldElementOperations.Multiplication(p.Y, p.Z),
                              Z: FieldElementOperations.Multiplication(p.Z, p.T))
    }
    
    private static func Madd(_ p: GroupElementP3, _ q: GroupElementP4) -> GroupElementP1 {
        let t0 = FieldElementOperations.Add(p.Z, p.Z)                   // D = 2*Z1
        let rX = FieldElementOperations.Add(p.Y, p.X)                   // YpX1 = Y1+X1
        
        var r = GroupElementP1(
            X: rX,                                                      // YpX1 = Y1+X1
            Y: FieldElementOperations.Sub(p.Y, p.X),                    // YmX1 = Y1-X1
            Z: FieldElementOperations.Multiplication(rX, q.YplusX),     // A = YpX1*ypx2
            T: FieldElementOperations.Multiplication(q.XY2D, p.T)       // C = xy2d2*T1
        )
    
        r.Y = FieldElementOperations.Multiplication(r.Y, q.YminusX)     // C = xy2d2*T1
    
        r.X = FieldElementOperations.Sub(r.Z, r.Y)                      // X3 = A-B
        r.Y = FieldElementOperations.Add(r.Z, r.Y)                      // Y3 = A+B
        r.Z = FieldElementOperations.Add(t0, r.T)                       // Z3 = D+C
        r.T = FieldElementOperations.Sub(t0, r.T)                       // T3 = D-C
        
        return r
    }
}
