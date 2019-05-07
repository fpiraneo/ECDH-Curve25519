//
//  ECDH_Curve25519Tests.swift
//  ECDH-Curve25519Tests
//
//  Created by Francesco Piraneo G. on 30.04.19.
//  Copyright © 2019 Francesco Piraneo G. All rights reserved.
//

import XCTest
@testable import ECDH_Curve25519

class ECDH_Curve25519Tests: XCTestCase {
    func testDiffieHellmanImpl_Success() {
        let alicePrivate = SecretKey()
        let alicePublic = alicePrivate.publicKey

        let bobPrivate = SecretKey()
        let bobPublic = bobPrivate.publicKey

        let aliceShared = try! alicePrivate.GetSharedSecretKey(bobPublic)
        let bobShared = try! bobPrivate.GetSharedSecretKey(alicePublic)

        XCTAssertEqual(aliceShared.KeyValue, bobShared.KeyValue)
    }
    
    func testDiffieHellmanImpl_Fail() {
        let alicePrivate = SecretKey()
        let alicePublic = alicePrivate.publicKey

        let bobPrivate = SecretKey()
        let bobPublic = bobPrivate.publicKey

        alicePublic.KeyValue = TestHelpers.ToggleBitInKey(buffer: alicePublic.KeyValue)

        let aliceShared = try! alicePrivate.GetSharedSecretKey(bobPublic)
        let bobShared = try! bobPrivate.GetSharedSecretKey(alicePublic)

        XCTAssertNotEqual(aliceShared.KeyValue, bobShared.KeyValue)
    }
    
    func testxDiffieHellmanImpl_Success_Timing() {
        measure {
            let alicePrivate = SecretKey()
            let alicePublic = alicePrivate.publicKey
            
            let bobPrivate = SecretKey()
            let bobPublic = bobPrivate.publicKey
            
            let _ = try! alicePrivate.GetSharedSecretKey(bobPublic)
            let _ = try! bobPrivate.GetSharedSecretKey(alicePublic)
        }
    }
}
