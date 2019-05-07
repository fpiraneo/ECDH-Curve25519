//
//  FieldElementOperations.swift
//  ECDH-Curve25519
//
//  Created by Francesco Piraneo G. on 03.05.19.
//  Copyright © 2019 Francesco Piraneo G. All rights reserved.
//
// TODO: On some functions they seems to have been optimized for performances on 32 bit machines; still applicable today?
// TODO: Extensive use of references; I think to save memory and speed but "unsafe"; retained unless a modification on parameter's value is needed

import Foundation

class FieldElementOperations {
    internal static func Set0() -> FieldElement {
        return FieldElement()
    }
    
    internal static func Set1() -> FieldElement {
        return try! FieldElement(elements: [1, 0, 0, 0, 0, 0, 0, 0, 0, 0])
    }
    
    /// h = f + g
    /// Can overlap h with f or g.
    ///
    /// Preconditions:
    /// |f| bounded by 1.1*2^25,1.1*2^24,1.1*2^25,1.1*2^24,etc.
    /// |g| bounded by 1.1*2^25,1.1*2^24,1.1*2^25,1.1*2^24,etc.
    ///
    /// Postconditions:
    /// |h| bounded by 1.1*2^26,1.1*2^25,1.1*2^26,1.1*2^25,etc.
    internal static func Add(_ f: FieldElement, _ g: FieldElement) -> FieldElement {
        return try! FieldElement(elements: [
            f.X0 + g.X0,
            f.X1 + g.X1,
            f.X2 + g.X2,
            f.X3 + g.X3,
            f.X4 + g.X4,
            f.X5 + g.X5,
            f.X6 + g.X6,
            f.X7 + g.X7,
            f.X8 + g.X8,
            f.X9 + g.X9
        ])
    }
    
    /// h = f - g
    /// Can overlap h with f or g.
    ///
    /// Preconditions:
    /// |f| bounded by 1.1*2^25,1.1*2^24,1.1*2^25,1.1*2^24,etc.
    /// |g| bounded by 1.1*2^25,1.1*2^24,1.1*2^25,1.1*2^24,etc.
    ///
    /// Postconditions:
    /// |h| bounded by 1.1*2^26,1.1*2^25,1.1*2^26,1.1*2^25,etc.
    internal static func Sub(_ f: FieldElement, _ g: FieldElement) -> FieldElement {
        return try! FieldElement(elements: [
            f.X0 - g.X0,
            f.X1 - g.X1,
            f.X2 - g.X2,
            f.X3 - g.X3,
            f.X4 - g.X4,
            f.X5 - g.X5,
            f.X6 - g.X6,
            f.X7 - g.X7,
            f.X8 - g.X8,
            f.X9 - g.X9
        ])
    }
    
    /// Replace (f,g) with (g,g) if b == 1;
    /// Replace (f,g) with (f,g) if b == 0.
    ///
    /// Preconditions: b in {0,1}.
    internal static func Mov(_ f: inout FieldElement, _ g: FieldElement, _ b: Int) {
        let locb = -b
        
        f.X0 = f.X0 ^ ((f.X0 ^ g.X0) & locb)
        f.X1 = f.X1 ^ ((f.X1 ^ g.X1) & locb)
        f.X2 = f.X2 ^ ((f.X2 ^ g.X2) & locb)
        f.X3 = f.X3 ^ ((f.X3 ^ g.X3) & locb)
        f.X4 = f.X4 ^ ((f.X4 ^ g.X4) & locb)
        f.X5 = f.X5 ^ ((f.X5 ^ g.X5) & locb)
        f.X6 = f.X6 ^ ((f.X6 ^ g.X6) & locb)
        f.X7 = f.X7 ^ ((f.X7 ^ g.X7) & locb)
        f.X8 = f.X8 ^ ((f.X8 ^ g.X8) & locb)
        f.X9 = f.X9 ^ ((f.X9 ^ g.X9) & locb)
    }
    
    /// Replace (f,g) with (g,f) if b == 1;
    /// replace (f,g) with (f,g) if b == 0.
    ///
    /// Preconditions: b in {0,1}.
    internal static func Swap(_ f: inout FieldElement, _ g: inout FieldElement, _ b: UInt) {
        let negb: Int = -1 * Int(b)
        
        let x0 = (f.X0 ^ g.X0) & negb
        let x1 = (f.X1 ^ g.X1) & negb
        let x2 = (f.X2 ^ g.X2) & negb
        let x3 = (f.X3 ^ g.X3) & negb
        let x4 = (f.X4 ^ g.X4) & negb
        let x5 = (f.X5 ^ g.X5) & negb
        let x6 = (f.X6 ^ g.X6) & negb
        let x7 = (f.X7 ^ g.X7) & negb
        let x8 = (f.X8 ^ g.X8) & negb
        let x9 = (f.X9 ^ g.X9) & negb
    
        f.X0 = f.X0 ^ x0
        f.X1 = f.X1 ^ x1
        f.X2 = f.X2 ^ x2
        f.X3 = f.X3 ^ x3
        f.X4 = f.X4 ^ x4
        f.X5 = f.X5 ^ x5
        f.X6 = f.X6 ^ x6
        f.X7 = f.X7 ^ x7
        f.X8 = f.X8 ^ x8
        f.X9 = f.X9 ^ x9
        
        g.X0 = g.X0 ^ x0
        g.X1 = g.X1 ^ x1
        g.X2 = g.X2 ^ x2
        g.X3 = g.X3 ^ x3
        g.X4 = g.X4 ^ x4
        g.X5 = g.X5 ^ x5
        g.X6 = g.X6 ^ x6
        g.X7 = g.X7 ^ x7
        g.X8 = g.X8 ^ x8
        g.X9 = g.X9 ^ x9
    }
    
    /// Does NOT ignore top bit
    internal static func FromBytes(data: [UInt8], offset: Int = 0) -> FieldElement {
        func Load3(data3: [UInt8], offset3: Int) -> Int64 {
            var result: UInt = UInt(data3[offset3 + 0])
            
            for i in 1..<3 {
                result |= UInt(data3[offset3 + i]) << (8 * i)
            }
            
            return Int64(result)
        }
    
        func Load4(data4: [UInt8], offset4: Int) -> Int64 {
            var result: UInt = UInt(data4[offset4 + 0])
            
            for i in 1..<4 {
                result |= UInt(data4[offset4 + i]) << (8 * i)
            }
            
            return Int64(result)
        }
    
        var h0 = Load4(data4: data, offset4: offset)
        var h1 = Load3(data3: data, offset3: offset + 4) << 6
        var h2 = Load3(data3: data, offset3: offset + 7) << 5
        var h3 = Load3(data3: data, offset3: offset + 10) << 3
        var h4 = Load3(data3: data, offset3: offset + 13) << 2
        var h5 = Load4(data4: data, offset4: offset + 16)
        var h6 = Load3(data3: data, offset3: offset + 20) << 7
        var h7 = Load3(data3: data, offset3: offset + 23) << 5
        var h8 = Load3(data3: data, offset3: offset + 26) << 4
        var h9 = Load3(data3: data, offset3: offset + 29) << 2
    
        let carry1 = (h1 + (1 << 24)) >> 25
        h2 += carry1
        h1 -= carry1 << 25
    
        let carry9 = (h9 + (1 << 24)) >> 25
        h0 += carry9 * 19
        h9 -= carry9 << 25
    
        let carry3 = (h3 + (1 << 24)) >> 25
        h4 += carry3
        h3 -= carry3 << 25
    
        let carry5 = (h5 + (1 << 24)) >> 25
        h6 += carry5
        h5 -= carry5 << 25
    
        let carry7 = (h7 + (1 << 24)) >> 25
        h8 += carry7
        h7 -= carry7 << 25
    
        let carry0 = (h0 + (1 << 25)) >> 26
        h1 += carry0
        h0 -= carry0 << 26
    
        let carry2 = (h2 + (1 << 25)) >> 26
        h3 += carry2
        h2 -= carry2 << 26
    
        let carry4 = (h4 + (1 << 25)) >> 26
        h5 += carry4
        h4 -= carry4 << 26
    
        let carry6 = (h6 + (1 << 25)) >> 26
        h7 += carry6
        h6 -= carry6 << 26
    
        let carry8 = (h8 + (1 << 25)) >> 26
        h9 += carry8
        h8 -= carry8 << 26
        
        return try! FieldElement(elements: [Int(h0), Int(h1), Int(h2), Int(h3), Int(h4), Int(h5), Int(h6), Int(h7), Int(h8), Int(h9)])
    }
    
    internal static func Invert(_ z: FieldElement) -> FieldElement {
        /* z2 = z1^2^1 */
        var t0 = Squared(z)
    
        /* z8 = z2^2^2 */
        var t1 = Squared(t0)
        
        t1 = Squared(t1)
        
        /* z9 = z1*z8 */
        t1 = Multiplication(z, t1)
        
        /* z11 = z2*z9 */
        t0 = Multiplication(t0, t1)
    
        /* z22 = z11^2^1 */
        var t2 = Squared(t0)
        
        /* z_5_0 = z9*z22 */
        t1 = Multiplication(t1, t2)
    
        /* z_10_5 = z_5_0^2^5 */
        t2 = Squared(t1);
        for _ in 1...4 {
            t2 = Squared(t2)
        }
    
        /* z_10_0 = z_10_5*z_5_0 */
        t1 = Multiplication(t2, t1)
        
        /* z_20_10 = z_10_0^2^10 */
        t2 = Squared(t1);
        for _ in 1...9 {
            t2 = Squared(t2)
        }
    
        /* z_20_0 = z_20_10*z_10_0 */
        t2 = Multiplication(t2, t1)
    
        /* z_40_20 = z_20_0^2^20 */
        var t3 = Squared(t2)
        for _ in 1...19 {
            t3 = Squared(t3)
        }
        
        /* z_40_0 = z_40_20*z_20_0 */
        t2 = Multiplication(t3, t2);
        
        /* z_50_10 = z_40_0^2^10 */
        t2 = Squared(t2);
        for _ in 1...9 {
            t2 = Squared(t2)
        }
        
        /* z_50_0 = z_50_10*z_10_0 */
        t1 = Multiplication(t2, t1);
        
        /* z_100_50 = z_50_0^2^50 */
        t2 = Squared(t1);
        for _ in 1...49 {
            t2 = Squared(t2)
        }
        
        /* z_100_0 = z_100_50*z_50_0 */
        t2 = Multiplication(t2, t1)
        
        /* z_200_100 = z_100_0^2^100 */
        t3 = Squared(t2)
        for _ in 1...99 {
            t3 = Squared(t3)
        }
        
        /* z_200_0 = z_200_100*z_100_0 */
        t2 = Multiplication(t3, t2)
        
        /* z_250_50 = z_200_0^2^50 */
        t2 = Squared(t2)
        for _ in 1...49 {
            t2 = Squared(t2)
        }
        
        /* z_250_0 = z_250_50*z_50_0 */
        t1 = Multiplication(t2, t1);
        
        /* z_255_5 = z_250_0^2^5 */
        t1 = Squared(t1);
        for _ in 1...4 {
            t1 = Squared(t1)
        }
        
        /* z_255_21 = z_255_5*z11 */
        return Multiplication(t1, t0)
    }
    
    /// h = f * g
    /// Can overlap h with f or g.
    ///
    /// Preconditions:
    /// |f| bounded by 1.65*2^26,1.65*2^25,1.65*2^26,1.65*2^25,etc.
    /// |g| bounded by 1.65*2^26,1.65*2^25,1.65*2^26,1.65*2^25,etc.
    ///
    /// Postconditions:
    /// |h| bounded by 1.01*2^25,1.01*2^24,1.01*2^25,1.01*2^24,etc.
    ///
    /// Notes on implementation strategy:
    /// Using schoolbook multiplication.
    /// Karatsuba would save a little in some cost models.
    ///
    /// Most multiplications by 2 and 19 are 32-bit precomputations;
    /// cheaper than 64-bit postcomputations.
    ///
    /// There is one remaining multiplication by 19 in the carry chain;
    /// one *19 precomputation can be merged into this,
    /// but the resulting data flow is considerably less clean.
    ///
    /// There are 12 carries below.
    /// 10 of them are 2-way parallelizable and vectorizable.
    /// Can get away with 11 carries, but then data flow is much deeper.
    ///
    /// With tighter constraints on inputs can squeeze carries into int32.
    internal static func Multiplication(_ f: FieldElement, _ g: FieldElement) -> FieldElement {
        var h0 = Int64((f.X0 * g.X0) + (2 * f.X1 * 19 * g.X9) + (f.X2 * 19 * g.X8) + (2 * f.X3 * 19 * g.X7) + (f.X4 * 19 * g.X6) + (2 * f.X5 * 19 * g.X5) + (f.X6 * 19 * g.X4) + (2 * f.X7 * 19 * g.X3) + (f.X8 * 19 * g.X2) + (2 * f.X9 * 19 * g.X1))
        var h1 = Int64((f.X0 * g.X1) + (f.X1 * g.X0) + (f.X2 * 19 * g.X9) + (f.X3 * 19 * g.X8) + (f.X4 * 19 * g.X7) + (f.X5 * 19 * g.X6) + (f.X6 * 19 * g.X5) + (f.X7 * 19 * g.X4) + (f.X8 * 19 * g.X3) + (f.X9 * 19 * g.X2))
        var h2 = Int64((f.X0 * g.X2) + (2 * f.X1 * g.X1) + (f.X2 * g.X0) + (2 * f.X3 * 19 * g.X9) + (f.X4 * 19 * g.X8) + (2 * f.X5 * 19 * g.X7) + (f.X6 * 19 * g.X6) + (2 * f.X7 * 19 * g.X5) + (f.X8 * 19 * g.X4) + (2 * f.X9 * 19 * g.X3))
        var h3 = Int64((f.X0 * g.X3) + (f.X1 * g.X2) + (f.X2 * g.X1) + (f.X3 * g.X0) + (f.X4 * 19 * g.X9) + (f.X5 * 19 * g.X8) + (f.X6 * 19 * g.X7) + (f.X7 * 19 * g.X6) + (f.X8 * 19 * g.X5) + (f.X9 * 19 * g.X4))
        var h4 = Int64((f.X0 * g.X4) + (2 * f.X1 * g.X3) + (f.X2 * g.X2) + (2 * f.X3 * g.X1) + (f.X4 * g.X0) + (2 * f.X5 * 19 * g.X9) + (f.X6 * 19 * g.X8) + (2 * f.X7 * 19 * g.X7) + (f.X8 * 19 * g.X6) + (2 * f.X9 * 19 * g.X5))
        var h5 = Int64((f.X0 * g.X5) + (f.X1 * g.X4) + (f.X2 * g.X3) + (f.X3 * g.X2) + (f.X4 * g.X1) + (f.X5 * g.X0) + (f.X6 * 19 * g.X9) + (f.X7 * 19 * g.X8) + (f.X8 * 19 * g.X7) + (f.X9 * 19 * g.X6))
        var h6 = Int64((f.X0 * g.X6) + (2 * f.X1 * g.X5) + (f.X2 * g.X4) + (2 * f.X3 * g.X3) + (f.X4 * g.X2) + (2 * f.X5 * g.X1) + (f.X6 * g.X0) + (2 * f.X7 * 19 * g.X9) + (f.X8 * 19 * g.X8) + (2 * f.X9 * 19 * g.X7))
        var h7 = Int64((f.X0 * g.X7) + (f.X1 * g.X6) + (f.X2 * g.X5) + (f.X3 * g.X4) + (f.X4 * g.X3) + (f.X5 * g.X2) + (f.X6 * g.X1) + (f.X7 * g.X0) + (f.X8 * 19 * g.X9) + (f.X9 * 19 * g.X8))
        var h8 = Int64((f.X0 * g.X8) + (2 * f.X1 * g.X7) + (f.X2 * g.X6) + (2 * f.X3 * g.X5) + (f.X4 * g.X4) + (2 * f.X5 * g.X3) + (f.X6 * g.X2) + (2 * f.X7 * g.X1) + (f.X8 * g.X0) + (2 * f.X9 * 19 * g.X9))
        var h9 = Int64((f.X0 * g.X9) + (f.X1 * g.X8) + (f.X2 * g.X7) + (f.X3 * g.X6) + (f.X4 * g.X5) + (f.X5 * g.X4) + (f.X6 * g.X3) + (f.X7 * g.X2) + (f.X8 * g.X1) + (f.X9 * g.X0))
        
        /*
         |h0| <= (1.65*1.65*2^52*(1+19+19+19+19)+1.65*1.65*2^50*(38+38+38+38+38))
         i.e. |h0| <= 1.4*2^60; narrower ranges for h2, h4, h6, h8
         |h1| <= (1.65*1.65*2^51*(1+1+19+19+19+19+19+19+19+19))
         i.e. |h1| <= 1.7*2^59; narrower ranges for h3, h5, h7, h9
         */
        
        var carry0 = (h0 + (1 << 25)) >> 26
        h1 += carry0                                // |h1| <= 1.71*2^59
        h0 -= carry0 << 26                          // |h0| <= 2^25
        
        var carry4 = (h4 + (1 << 25)) >> 26
        h5 += carry4                                // |h5| <= 1.71*2^59
        h4 -= carry4 << 26                          // |h4| <= 2^25
        
        let carry1 = (h1 + (1 << 24)) >> 25
        h2 += carry1                                // |h2| <= 1.41*2^60
        h1 -= carry1 << 25                          // |h1| <= 2^24; from now on fits into int32
        
        let carry5 = (h5 + (1 << 24)) >> 25
        h6 += carry5                                // |h6| <= 1.41*2^60
        h5 -= carry5 << 25                          // |h5| <= 2^24; from now on fits into int32
        
        let carry2 = (h2 + (1 << 25)) >> 26
        h3 += carry2                                // |h3| <= 1.71*2^59
        h2 -= carry2 << 26                          // |h2| <= 2^25; from now on fits into int32 unchanged
        
        let carry6 = (h6 + (1 << 25)) >> 26
        h7 += carry6                                // |h7| <= 1.71*2^59
        h6 -= carry6 << 26                          // |h6| <= 2^25; from now on fits into int32 unchanged
        
        let carry3 = (h3 + (1 << 24)) >> 25
        h4 += carry3                                // |h4| <= 1.72*2^34
        h3 -= carry3 << 25                          // |h3| <= 2^24; from now on fits into int32 unchanged
        let carry7 = (h7 + (1 << 24)) >> 25
        
        h8 += carry7                                // |h8| <= 1.41*2^60
        h7 -= carry7 << 25                          // |h7| <= 2^24; from now on fits into int32 unchanged
        
        carry4 = (h4 + (1 << 25)) >> 26
        h5 += carry4                                // |h5| <= 1.01*2^24
        h4 -= carry4 << 26                          // |h4| <= 2^25; from now on fits into int32 unchanged
        
        let carry8 = (h8 + (1 << 25)) >> 26
        h9 += carry8                                // |h9| <= 1.71*2^59
        h8 -= carry8 << 26                          // |h8| <= 2^25; from now on fits into int32 unchanged
        
        let carry9 = (h9 + (1 << 24)) >> 25
        h0 += carry9 * 19                           // |h0| <= 1.1*2^39
        h9 -= carry9 << 25                          // |h9| <= 2^24; from now on fits into int32 unchanged
        
        carry0 = (h0 + (1 << 25)) >> 26
        h1 += carry0                                // |h1| <= 1.01*2^24
        h0 -= carry0 << 26                          // |h0| <= 2^25; from now on fits into int32 unchanged
        
        return try! FieldElement(elements: [Int(h0), Int(h1), Int(h2), Int(h3), Int(h4), Int(h5), Int(h6), Int(h7), Int(h8), Int(h9)])
    }
    
    /// h = -f
    ///
    /// Preconditions:
    /// |f| bounded by 1.1*2^25,1.1*2^24,1.1*2^25,1.1*2^24,etc.
    ///
    /// Postconditions:
    /// |h| bounded by 1.1*2^25,1.1*2^24,1.1*2^25,1.1*2^24,etc.
    /// TODO: What is "h"?
    internal static func Negate(_ f: FieldElement) -> FieldElement {
        return try! FieldElement(elements: [-f.X0, -f.X1, -f.X2, -f.X3, -f.X4, -f.X5, -f.X6, -f.X7, -f.X8, -f.X9])
    }
    
    /// h = f * 121666
    /// Can overlap h with f.
    ///
    /// Preconditions:
    /// |f| bounded by 1.1*2^26,1.1*2^25,1.1*2^26,1.1*2^25,etc.
    ///
    /// Postconditions:
    /// |h| bounded by 1.1*2^25,1.1*2^24,1.1*2^25,1.1*2^24,etc.
    internal static func Multiply121666(_ f: FieldElement) -> FieldElement {
        var h0 = Int64(f.X0 * 121666)
        var h1 = Int64(f.X1 * 121666)
        var h2 = Int64(f.X2 * 121666)
        var h3 = Int64(f.X3 * 121666)
        var h4 = Int64(f.X4 * 121666)
        var h5 = Int64(f.X5 * 121666)
        var h6 = Int64(f.X6 * 121666)
        var h7 = Int64(f.X7 * 121666)
        var h8 = Int64(f.X8 * 121666)
        var h9 = Int64(f.X9 * 121666)
        
        let carry9 = (h9 + (1 << 24)) >> 25
        h0 += carry9 * 19
        h9 -= carry9 << 25
        
        let carry1 = (h1 + (1 << 24)) >> 25
        h2 += carry1
        h1 -= carry1 << 25
        
        let carry3 = (h3 + (1 << 24)) >> 25
        h4 += carry3
        h3 -= carry3 << 25
        
        let carry5 = (h5 + (1 << 24)) >> 25
        h6 += carry5
        h5 -= carry5 << 25
        
        let carry7 = (h7 + (1 << 24)) >> 25
        h8 += carry7
        h7 -= carry7 << 25
        
        let carry0 = (h0 + (1 << 25)) >> 26
        h1 += carry0
        h0 -= carry0 << 26
        
        let carry2 = (h2 + (1 << 25)) >> 26
        h3 += carry2
        h2 -= carry2 << 26
        
        let carry4 = (h4 + (1 << 25)) >> 26
        h5 += carry4
        h4 -= carry4 << 26
        
        let carry6 = (h6 + (1 << 25)) >> 26
        h7 += carry6
        h6 -= carry6 << 26
        
        let carry8 = (h8 + (1 << 25)) >> 26
        h9 += carry8
        h8 -= carry8 << 26
    
        return try! FieldElement(elements: [Int(h0), Int(h1), Int(h2), Int(h3), Int(h4), Int(h5), Int(h6), Int(h7), Int(h8), Int(h9)])
    }
    
    /// h = f * f
    /// Can overlap h with f.
    ///
    /// Preconditions:
    /// |f| bounded by 1.65*2^26,1.65*2^25,1.65*2^26,1.65*2^25,etc.
    ///
    /// Postconditions:
    /// |h| bounded by 1.01*2^25,1.01*2^24,1.01*2^25,1.01*2^24,etc.
    internal static func Squared(_ f: FieldElement) -> FieldElement {
        var h0 = Int64((f.X0 * f.X0) + (2 * f.X1 * 38 * f.X9) + (2 * f.X2 * 19 * f.X8) + (2 * f.X3 * 38 * f.X7) + (2 * f.X4 * 19 * f.X6) + (f.X5 * 38 * f.X5))
        var h1 = Int64((2 * f.X0 * f.X1) + (f.X2 * 38 * f.X9) + (2 * f.X3 * 19 * f.X8) + (f.X4 * 38 * f.X7) + (2 * f.X5 * 19 * f.X6))
        var h2 = Int64((2 * f.X0 * f.X2) + (2 * f.X1 * f.X1) + (2 * f.X3 * 38 * f.X9) + (2 * f.X4 * 19 * f.X8) + (2 * f.X5 * 38 * f.X7) + (f.X6 * 19 * f.X6))
        var h3 = Int64((2 * f.X0 * f.X3) + (2 * f.X1 * f.X2) + (f.X4 * 38 * f.X9) + (2 * f.X5 * 19 * f.X8) + (f.X6 * 38 * f.X7))
        var h4 = Int64((2 * f.X0 * f.X4) + (2 * f.X1 * 2 * f.X3) + (f.X2 * f.X2) + (2 * f.X5 * 38 * f.X9) + (2 * f.X6 * 19 * f.X8) + (f.X7 * 38 * f.X7))
        var h5 = Int64((2 * f.X0 * f.X5) + (2 * f.X1 * f.X4) + (2 * f.X2 * f.X3) + (f.X6 * 38 * f.X9) + (2 * f.X7 * 19 * f.X8))
        var h6 = Int64((2 * f.X0 * f.X6) + (2 * f.X1 * 2 * f.X5) + (2 * f.X2 * f.X4) + (2 * f.X3 * f.X3) + (2 * f.X7 * 38 * f.X9) + (f.X8 * 19 * f.X8))
        var h7 = Int64((2 * f.X0 * f.X7) + (2 * f.X1 * f.X6) + (2 * f.X2 * f.X5) + (2 * f.X3 * f.X4) + (f.X8 * 38 * f.X9))
        var h8 = Int64((2 * f.X0 * f.X8) + (2 * f.X1 * 2 * f.X7) + (2 * f.X2 * f.X6) + (2 * f.X3 * 2 * f.X5) + (f.X4 * f.X4) + (f.X9 * 38 * f.X9))
        var h9 = Int64((2 * f.X0 * f.X9) + (2 * f.X1 * f.X8) + (2 * f.X2 * f.X7) + (2 * f.X3 * f.X6) + (2 * f.X4 * f.X5))
    
        var carry0 = (h0 + (1 << 25)) >> 26
        h1 += carry0
        h0 -= carry0 << 26
        
        var carry4 = (h4 + (1 << 25)) >> 26
        h5 += carry4
        h4 -= carry4 << 26
        
        let carry1 = (h1 + (1 << 24)) >> 25
        h2 += carry1
        h1 -= carry1 << 25
        
        let carry5 = (h5 + (1 << 24)) >> 25
        h6 += carry5
        h5 -= carry5 << 25
        
        let carry2 = (h2 + (1 << 25)) >> 26
        h3 += carry2
        h2 -= carry2 << 26
        
        let carry6 = (h6 + (1 << 25)) >> 26
        h7 += carry6
        h6 -= carry6 << 26
        
        let carry3 = (h3 + (1 << 24)) >> 25
        h4 += carry3
        h3 -= carry3 << 25
        
        let carry7 = (h7 + (1 << 24)) >> 25
        h8 += carry7
        h7 -= carry7 << 25
        
        carry4 = (h4 + (1 << 25)) >> 26
        h5 += carry4
        h4 -= carry4 << 26
        
        let carry8 = (h8 + (1 << 25)) >> 26
        h9 += carry8
        h8 -= carry8 << 26
        
        let carry9 = (h9 + (1 << 24)) >> 25
        h0 += carry9 * 19
        h9 -= carry9 << 25
        
        carry0 = (h0 + (1 << 25)) >> 26
        h1 += carry0
        h0 -= carry0 << 26
        
        return try! FieldElement(elements: [Int(h0), Int(h1), Int(h2), Int(h3), Int(h4), Int(h5), Int(h6), Int(h7), Int(h8), Int(h9)])
    }
    
    /// Preconditions:
    /// |h| bounded by 1.1*2^26,1.1*2^25,1.1*2^26,1.1*2^25,etc.
    ///
    /// Write p=2^255-19; q=floor(h/p).
    /// Basic claim: q = floor(2^(-255)(h + 19 2^(-25)h9 + 2^(-1))).
    ///
    /// Proof:
    /// Have |h|<=p so |q|<=1 so |19^2 2^(-255) q|<1/4.
    /// Also have |h-2^230 h9|<2^231 so |19 2^(-255)(h-2^230 h9)|<1/4.
    ///
    /// Write y=2^(-1)-19^2 2^(-255)q-19 2^(-255)(h-2^230 h9).
    /// Then 0<y<1.
    ///
    /// Write r=h-pq.
    /// Have 0<=r<=p-1=2^255-20.
    /// Thus 0<=r+19(2^-255)r<r+19(2^-255)2^255<=2^255-1.
    ///
    /// Write x=r+19(2^-255)r+y.
    /// Then 0<x<2^255 so floor(2^(-255)x) = 0 so floor(q+2^(-255)x) = q.
    ///
    /// Have q+2^(-255)x = 2^(-255)(h + 19 2^(-25) h9 + 2^(-1))
    /// so floor(2^(-255)(h + 19 2^(-25) h9 + 2^(-1))) = q.
    internal static func ToBytes(_ s: inout [UInt8], _ h: FieldElement, offset: Int = 0) {
        func shr(_ number: Int, _ pos: Int) -> UInt8 {
            return UInt8((number >> pos) & 0xff)
        }
        
        func shl(_ number: Int, _ pos: Int) -> UInt8 {
            return UInt8((number << pos) & 0xff)
        }
        
        let hr = Reduce(h)
        /*
         Goal: Output h0+...+2^255 h10-2^255 q, which is between 0 and 2^255-20.
         Have h0+...+2^230 h9 between 0 and 2^255-1;
         evidently 2^255 h10-2^255 q = 0.
         Goal: Output h0+...+2^230 h9.
         */

        s[offset + 0] = shr(hr.X0, 0)
        s[offset + 1] = shr(hr.X0, 8)
        s[offset + 2] = shr(hr.X0, 16)
        s[offset + 3] = shr(hr.X0, 24) | shl(hr.X1, 2)
        s[offset + 4] = shr(hr.X1, 6)
        s[offset + 5] = shr(hr.X1, 14)
        s[offset + 6] = shr(hr.X1, 22) | shl(hr.X2, 3)
        s[offset + 7] = shr(hr.X2, 5)
        s[offset + 8] = shr(hr.X2, 13)
        s[offset + 9] = shr(hr.X2, 21) | shl(hr.X3, 5)
        s[offset + 10] = shr(hr.X3, 3)
        s[offset + 11] = shr(hr.X3, 11)
        s[offset + 12] = shr(hr.X3, 19) | shl(hr.X4, 6)
        s[offset + 13] = shr(hr.X4, 2)
        s[offset + 14] = shr(hr.X4, 10)
        s[offset + 15] = shr(hr.X4, 18)
        s[offset + 16] = shr(hr.X5, 0)
        s[offset + 17] = shr(hr.X5, 8)
        s[offset + 18] = shr(hr.X5, 16)
        s[offset + 19] = shr(hr.X5, 24) | shl(hr.X6, 1)
        s[offset + 20] = shr(hr.X6, 7)
        s[offset + 21] = shr(hr.X6, 15)
        s[offset + 22] = shr(hr.X6, 23) | shl(hr.X7, 3)
        s[offset + 23] = shr(hr.X7, 5)
        s[offset + 24] = shr(hr.X7, 13)
        s[offset + 25] = shr(hr.X7, 21) | shl(hr.X8, 4)
        s[offset + 26] = shr(hr.X8, 4)
        s[offset + 27] = shr(hr.X8, 12)
        s[offset + 28] = shr(hr.X8, 20) | shl(hr.X9, 6)
        s[offset + 29] = shr(hr.X9, 2)
        s[offset + 30] = shr(hr.X9, 10)
        s[offset + 31] = shr(hr.X9, 18)
    }
    
    /// h = 2 * f * f
    /// Can overlap h with f.
    ///
    /// Preconditions:
    /// |f| bounded by 1.65*2^26,1.65*2^25,1.65*2^26,1.65*2^25,etc.
    ///
    /// Postconditions:
    /// |h| bounded by 1.01*2^25,1.01*2^24,1.01*2^25,1.01*2^24,etc.
    internal static func DoubleSquare(_ f: FieldElement) -> FieldElement {
        var h0 = Int64(f.X0 * (f.X0) + 2 * f.X1 * (38 * f.X9) + 2 * f.X2 * (19 * f.X8) + 2 * f.X3 * (38 * f.X7) + 2 * f.X4 * (19 * f.X6) + (f.X5 * 38 * f.X5))
        var h1 = Int64(2 * f.X0 * (f.X1) + f.X2 * (38 * f.X9) + 2 * f.X3 * (19 * f.X8) + f.X4 * (38 * f.X7) + 2 * f.X5 * (19 * f.X6))
        var h2 = Int64(2 * f.X0 * (f.X2) + 2 * f.X1 * (f.X1) + 2 * f.X3 * (38 * f.X9) + 2 * f.X4 * (19 * f.X8) + 2 * f.X5 * (38 * f.X7) + (f.X6 * 19 * f.X6))
        var h3 = Int64(2 * f.X0 * (f.X3) + 2 * f.X1 * (f.X2) + f.X4 * (38 * f.X9) + 2 * f.X5 * (19 * f.X8) + f.X6 * (38 * f.X7))
        var h4 = Int64(2 * f.X0 * (f.X4) + 2 * f.X1 * (2 * f.X3) + f.X2 * (f.X2) + 2 * f.X5 * (38 * f.X9) + 2 * f.X6 * (19 * f.X8) + (f.X7 * 38 * f.X7))
        var h5 = Int64(2 * f.X0 * (f.X5) + 2 * f.X1 * (f.X4) + 2 * f.X2 * (f.X3) + f.X6 * (38 * f.X9) + 2 * f.X7 * (19 * f.X8))
        var h6 = Int64(2 * f.X0 * (f.X6) + 2 * f.X1 * (2 * f.X5) + 2 * f.X2 * (f.X4) + 2 * f.X3 * (f.X3) + 2 * f.X7 * (38 * f.X9) + (f.X8 * 19 * f.X8))
        var h7 = Int64(2 * f.X0 * (f.X7) + 2 * f.X1 * (f.X6) + 2 * f.X2 * (f.X5) + 2 * f.X3 * (f.X4) + f.X8 * (38 * f.X9))
        var h8 = Int64(2 * f.X0 * (f.X8) + 2 * f.X1 * (2 * f.X7) + 2 * f.X2 * (f.X6) + 2 * f.X3 * (2 * f.X5) + (f.X4 * f.X4) + (f.X9 * 38 * f.X9))
        var h9 = Int64(2 * f.X0 * (f.X9) + 2 * f.X1 * (f.X8) + 2 * f.X2 * (f.X7) + 2 * f.X3 * (f.X6) + 2 * f.X4 * (f.X5))
        
        h0 += h0
        h1 += h1
        h2 += h2
        h3 += h3
        h4 += h4
        h5 += h5
        h6 += h6
        h7 += h7
        h8 += h8
        h9 += h9
    
        var carry0 = (h0 + (1 << 25)) >> 26
        h1 += carry0
        h0 -= carry0 << 26
        
        var carry4 = (h4 + (1 << 25)) >> 26
        h5 += carry4
        h4 -= carry4 << 26
        
        let carry1 = (h1 + (1 << 24)) >> 25
        h2 += carry1
        h1 -= carry1 << 25
        
        let carry5 = (h5 + (1 << 24)) >> 25
        h6 += carry5
        h5 -= carry5 << 25
        
        let carry2 = (h2 + (1 << 25)) >> 26
        h3 += carry2
        h2 -= carry2 << 26
        
        let carry6 = (h6 + (1 << 25)) >> 26
        h7 += carry6
        h6 -= carry6 << 26
        
        let carry3 = (h3 + (1 << 24)) >> 25
        h4 += carry3
        h3 -= carry3 << 25
        
        let carry7 = (h7 + (1 << 24)) >> 25
        h8 += carry7
        h7 -= carry7 << 25
        
        carry4 = (h4 + (1 << 25)) >> 26
        h5 += carry4
        h4 -= carry4 << 26
        
        let carry8 = (h8 + (1 << 25)) >> 26
        h9 += carry8
        h8 -= carry8 << 26
        
        let carry9 = (h9 + (1 << 24)) >> 25
        h0 += carry9 * 19
        h9 -= carry9 << 25
        
        carry0 = (h0 + (1 << 25)) >> 26
        h1 += carry0
        h0 -= carry0 << 26
        
        return try! FieldElement(elements: [Int(h0), Int(h1), Int(h2), Int(h3), Int(h4), Int(h5), Int(h6), Int(h7), Int(h8), Int(h9)])
    }
    
    private static func Reduce(_ h: FieldElement) -> FieldElement {
        var q = (19 * h.X9 + (1 << 24)) >> 25
        q = (h.X0 + q) >> 26
        q = (h.X1 + q) >> 25
        q = (h.X2 + q) >> 26
        q = (h.X3 + q) >> 25
        q = (h.X4 + q) >> 26
        q = (h.X5 + q) >> 25
        q = (h.X6 + q) >> 26
        q = (h.X7 + q) >> 25
        q = (h.X8 + q) >> 26
        q = (h.X9 + q) >> 25
        
        var h0 = h
        
        /* Goal: Output h-(2^255-19)q, which is between 0 and 2^255-20. */
        h0.X0 += 19 * q
        
        /* Goal: Output h-2^255 q, which is between 0 and 2^255-20. */
        let carry0 = h.X0 >> 26
        h0.X1 += carry0
        h0.X0 -= carry0 << 26
        
        let carry1 = h.X1 >> 25
        h0.X2 += carry1
        h0.X1 -= carry1 << 25
        
        let carry2 = h.X2 >> 26
        h0.X3 += carry2
        h0.X2 -= carry2 << 26
        
        let carry3 = h.X3 >> 25
        h0.X4 += carry3
        h0.X3 -= carry3 << 25
        
        let carry4 = h.X4 >> 26
        h0.X5 += carry4
        h0.X4 -= carry4 << 26
        
        let carry5 = h.X5 >> 25
        h0.X6 += carry5
        h0.X5 -= carry5 << 25
        
        let carry6 = h.X6 >> 26
        h0.X7 += carry6
        h0.X6 -= carry6 << 26
        
        let carry7 = h.X7 >> 25
        h0.X8 += carry7
        h0.X7 -= carry7 << 25
        
        let carry8 = h.X8 >> 26
        h0.X9 += carry8
        h0.X8 -= carry8 << 26
        
        let carry9 = h.X9 >> 25
        h0.X9 -= carry9 << 25
        
        /* h10 = carry9 */
        
        return h0
    }
}

