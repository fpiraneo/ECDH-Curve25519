//
//  TestHelpers.swift
//  ECDH-Curve25519Tests
//
//  Created by Francesco Piraneo G. on 05.05.19.
//  Copyright © 2019 Francesco Piraneo G. All rights reserved.
//

import Foundation

class TestHelpers {
    public static func ToggleBitInKey(buffer: [UInt8]) -> [UInt8] {
        let bitArray = BitArray(byteArray: buffer)
        let bitToToggle = Int.random(in: 0...bitArray.array.count)
        
        bitArray.toggleBit(bitNum: bitToToggle)
        
        return bitArray.toByteArray()
    }
}
