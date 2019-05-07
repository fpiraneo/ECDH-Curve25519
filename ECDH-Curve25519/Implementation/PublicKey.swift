//
//  PublicKey.swift
//  ECDH-Curve25519
//
//  Created by Francesco Piraneo G. on 04.05.19.
//  Copyright © 2019 Francesco Piraneo G. All rights reserved.
//

import Foundation

public class PublicKey {
    public var KeyValue: [UInt8]
    internal let Uid = UUID()
    
    
    /// <summary>
    /// Generates the Public Key for this Private Key
    /// </summary>
    /// <param name="secretKey">My Private Key</param>
    internal init(_ secretKey: SecretKey) throws {
        KeyValue = try AlgorithmService.GetPublicKey(secretKey.KeyValue)
    }
    
    public func toString() -> String {
        return String.bytesConvertToHexString(KeyValue)
    }
}
