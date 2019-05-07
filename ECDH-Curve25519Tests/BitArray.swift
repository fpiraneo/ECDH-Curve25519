//
//  BitArray.swift
//  ECDH-Curve25519Tests
//
//  Created by Francesco Piraneo G. on 05.05.19.
//  Copyright © 2019 Francesco Piraneo G. All rights reserved.
//

import Foundation

class BitArray {
    var array = [Bool]()
    
    init(byte: UInt8) {
        array.append(contentsOf: bits(fromByte: byte))
    }
    
    init(byteArray: [UInt8]) {
        for index in 0..<byteArray.count {
            array.append(contentsOf: bits(fromByte: byteArray[index]))
        }
    }
    
    public func toggleBit(bitNum: Int) {
        if bitNum <= array.count {
            array[bitNum - 1] = !array[bitNum - 1]
        }
    }
    
    public func toByteArray() -> [UInt8] {
        var powers: [UInt8] = [128, 64, 32, 16, 8, 4, 2, 1]
        var result = [UInt8]()
        
        for index in stride(from: 0, to: array.count, by: 8) {
            var byte: UInt8 = 0
            
            for bits in 0...7 {
                byte = byte + (array[index + bits] ? powers[bits] : 0)
            }
            
            result.append(byte)
        }
        
        return result
    }
    
    public func toString() -> String {
        var result: String = ""
        
        for index in 0..<array.count {
            if array[index] {
                result = result + "true "
            } else {
                result = result + "false "
            }
        }
        
        return result.trimmingCharacters(in: CharacterSet(charactersIn: " "))
    }
    
    private func bits(fromByte byte: UInt8) -> [Bool] {
        var byte = byte
        var bits = [Bool](repeating: false, count: 8)
        
        for i in stride(from: 7, through: 0, by: -1) {
            let currentBit = byte & 0x01
            if currentBit != 0 {
                bits[i] = true
            }
            
            byte >>= 1
        }
        
        return bits
    }
}
