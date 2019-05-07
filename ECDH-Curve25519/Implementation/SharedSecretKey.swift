//
//  SharedSecretKey.swift
//  ECDH-Curve25519
//
//  Created by Francesco Piraneo G. on 04.05.19.
//  Copyright © 2019 Francesco Piraneo G. All rights reserved.
//

import Foundation

public class SharedSecretKey {
    public var KeyValue: [UInt8]
    internal let Uid = UUID()
    
    /// Generates the Shared Key for this pair (My Secret Key - Your Public Key)
    internal init(secretKey: SecretKey, peerPublicKey: PublicKey) throws {
        KeyValue = try AlgorithmService.GetSharedSecretKey(
            peerPublicKey: peerPublicKey.KeyValue,
            privateKey: secretKey.KeyValue
        )
    }
    
    public func toString() -> String {
        return String.bytesConvertToHexString(KeyValue)
    }
}
