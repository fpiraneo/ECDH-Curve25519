//
//  AlgorithmService.swift
//  ECDH-Curve25519
//
//  Created by Francesco Piraneo G. on 04.05.19.
//  Copyright © 2019 Francesco Piraneo G. All rights reserved.
//

import Foundation

/// This class is mainly for compatibility with NaCl's Curve25519 implementation
class AlgorithmService {
    private static let PrivateKeySizeInBytes: Int = 32
    private static let PublicKeySizeInBytes: Int = 32
    private static let SharedKeySizeInBytes: Int = 32

    /// Creates a random private key
    ///
    /// - Returns: 32 random bytes that are clamped to a suitable private key
    public static func GetRandomPrivateKey() -> [UInt8] {
        var privateKey = [UInt8]()

        for _ in 0..<PrivateKeySizeInBytes {
            privateKey.append(UInt8.random(in: 0...255))
        }
        
        ClampOperation.Clamp(&privateKey, offset: 0)
        return privateKey
    }

    /// Get a Public Key for my Private Key
    ///
    /// - Parameter privateKey: Private key
    /// - Returns: The public key for private key
    /// - Throws: ArgumentExceptions - Bad array length for the private key
    public static func GetPublicKey(_ privateKey: [UInt8]) throws -> [UInt8] {
        if privateKey.count != PrivateKeySizeInBytes {
            throw Exceptions.ArgumentException(message: "Secret key must be \(PrivateKeySizeInBytes) bytes long")
        }
        
        var publicKey = privateKey
        
        ClampOperation.Clamp(&publicKey)
        
        let a = GroupElementsOperations.ScalarMultiplicationBase(a: publicKey)      // To MontgomeryX
        
        let tempX = FieldElementOperations.Add(a.Z, a.Y)                            // Get X
        var tempZ = FieldElementOperations.Sub(a.Z, a.Y)
        tempZ = FieldElementOperations.Invert(tempZ)                                // Get Z
        
        // Obtains the Public Key
        let publicKeyFieldElement = FieldElementOperations.Multiplication(tempX, tempZ) // X*Z
        FieldElementOperations.ToBytes(&publicKey, publicKeyFieldElement)
        
        return publicKey
    }

    /// Get a SharedSecret Key for this pair (my Private Key - your Public Key)
    ///
    /// - Parameters:
    ///   - peerPublicKey: Peer's public key as array of bytes
    ///   - privateKey: My own private key as array of bytes
    /// - Returns: A shared secret computed with the provided keys
    /// - Throws: ArgumentExceptions - Bad array length for one (or both) the provided key(s)
    public static func GetSharedSecretKey(peerPublicKey: [UInt8], privateKey: [UInt8]) throws -> [UInt8] {
        if peerPublicKey.count != PublicKeySizeInBytes {
            throw Exceptions.ArgumentException(message: "Public key must be \(PublicKeySizeInBytes) bytes long")
        }

        if privateKey.count != PrivateKeySizeInBytes {
            throw Exceptions.ArgumentException(message: "Secret key must be \(PrivateKeySizeInBytes) bytes long")
        }
    
        // Resolve SharedSecret Key using the Montgomery Elliptical Curve Operations...
        let sharedSecretKey = MontgomeryOperations.ScalarMultiplication(privateKey, peerPublicKey, SharedKeySizeInBytes)
        
        // Hashes like the NaCl paper says instead i.e. HSalsa(x,0)
        return Salsa20.HSalsa20(key: sharedSecretKey)
    }
}

