//
//  PrivateKey.swift
//  ECDH-Curve25519
//
//  Created by Francesco Piraneo G. on 04.05.19.
//  Copyright © 2019 Francesco Piraneo G. All rights reserved.
//

import Foundation

public class SecretKey {
    private let secretKeyValue: [UInt8]
    public var KeyValue: [UInt8] {
        get {
            return secretKeyValue
        }
    }
    
    /// Obtains the Public Key out this Secret Key
    public var publicKey: PublicKey {
        get {
            return try! PublicKey(self)
        }
    }
    
    init() {
        secretKeyValue = AlgorithmService.GetRandomPrivateKey()
    }
    
        /// Obtains the Shared Secret Key for the pair My Secret Key <-> Your Public Key
    ///
    /// - Parameter peerPublicKey: Your public key
    /// - Returns: Shared Key for this pair
    /// - Throws: peerPublicKey can not be my own public key
    public func GetSharedSecretKey(_ peerPublicKey: PublicKey) throws -> SharedSecretKey {
        if peerPublicKey.Uid == publicKey.Uid {
            throw Exceptions.ArgumentException(message: "peerPublicKey can not be my own public key")
        }

        return try SharedSecretKey(secretKey: self, peerPublicKey: peerPublicKey)
    }
    
    public func toString() -> String {
        return String.bytesConvertToHexString(KeyValue)
    }
}

