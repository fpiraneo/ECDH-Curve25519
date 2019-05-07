//
//  Salsa20.swift
//  ECDH-Curve25519
//
//  Created by Francesco Piraneo G. on 30.04.19.
//  Copyright © 2019 Francesco Piraneo G. All rights reserved.
//

import Foundation

class Salsa20 {
    static let SalsaConst0: UInt32 = 0x61707865
    static let SalsaConst1: UInt32 = 0x3320646e
    static let SalsaConst2: UInt32 = 0x79622d32
    static let SalsaConst3: UInt32 = 0x6b206574

    internal static func HSalsa20(key: [UInt8]) -> [UInt8] {
        var result = key;
    
        var state = LoadLittleEndian(result)
        SalsaCore.Salsa20(state: &state, doubleRounds: 10)
        StoreLittleEndian(result: &result, state: state)
    
        return result
    }
    
    static func LoadLittleEndian(_ result: [UInt8]) -> Array16<UInt32> {
        let nonce = [UInt8].init(repeating: 0, count: 16)
        
        return Array16<UInt32>(X0: SalsaConst0,
                             X1: LoadLittleEndian32(result, 0),
                             X2: LoadLittleEndian32(result, 4),
                             X3: LoadLittleEndian32(result, 8),
                             X4: LoadLittleEndian32(result, 12),
                             X5: SalsaConst1,
                             X6: LoadLittleEndian32(nonce, 0),
                             X7: LoadLittleEndian32(nonce, 4),
                             X8: LoadLittleEndian32(nonce, 8),
                             X9: LoadLittleEndian32(nonce, 12),
                             X10: SalsaConst2,
                             X11: LoadLittleEndian32(result, 16),
                             X12: LoadLittleEndian32(result, 20),
                             X13: LoadLittleEndian32(result, 24),
                             X14: LoadLittleEndian32(result, 28),
                             X15: SalsaConst3)
        
    }
    
    private static func LoadLittleEndian32(_ buf: [UInt8], _ offset: Int = 0) -> UInt32 {
        return UInt32(buf[offset + 0]) | (UInt32(buf[offset + 1]) << 8) | (UInt32(buf[offset + 2]) << 16) | (UInt32(buf[offset + 3]) << 24)
    }
    
    private static func StoreLittleEndian(result: inout [UInt8], state: Array16<UInt32>) {
        StoreLittleEndian32(buf: &result, value: state.X0, offset: 0)
        StoreLittleEndian32(buf: &result, value: state.X5, offset: 4)
        StoreLittleEndian32(buf: &result, value: state.X10, offset: 8)
        StoreLittleEndian32(buf: &result, value: state.X15, offset: 12)
        StoreLittleEndian32(buf: &result, value: state.X6, offset: 16)
        StoreLittleEndian32(buf: &result, value: state.X7, offset: 20)
        StoreLittleEndian32(buf: &result, value: state.X8, offset: 24)
        StoreLittleEndian32(buf: &result, value: state.X9, offset: 28)
    }
    
    private static func StoreLittleEndian32(buf: inout [UInt8], value: UInt32, offset: Int = 0) {
        buf[offset + 0] = UInt8(value & 0xff)
        buf[offset + 1] = UInt8((value >> 8) & 0xff)
        buf[offset + 2] = UInt8((value >> 16) & 0xff)
        buf[offset + 3] = UInt8((value >> 24) & 0xff)
    }
}
