//
//  String+Extensions.swift
//  ECDH-Curve25519
//
//  Created by Francesco Piraneo G. on 04.05.19.
//  Copyright © 2019 Francesco Piraneo G. All rights reserved.
//

import Foundation

extension String {
    /// Takes an array of bytes and returns an hexadecimal representation
    /// Resulting string is not spaced: All bytes are contigous
    ///
    /// - Parameter byteArray: Array of bytes to be converted
    /// - Returns: String with hexadecimal values
    static func bytesConvertToHexString(_ byteArray: [UInt8]) -> String {
        var string = ""
        
        for val in byteArray {
            string = string + String(format: "%02X", val)
        }
        
        return string
    }
}
