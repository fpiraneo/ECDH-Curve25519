//
//  ClampOperation.swift
//  ECDH-Curve25519
//
//  Created by Francesco Piraneo G. on 03.05.19.
//  Copyright © 2019 Francesco Piraneo G. All rights reserved.
//

import Foundation

class ClampOperation {
    internal static func Clamp(_ s: inout [UInt8], offset : Int = 0) {
        s[offset + 0] &= 248;
        s[offset + 31] &= 127;
        s[offset + 31] |= 64;
    }
}
