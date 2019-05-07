//
//  AlgorithmCurve25519Tests.swift
//  ECDH-Curve25519Tests
//
//  Created by Francesco Piraneo G. on 05.05.19.
//  Copyright © 2019 Francesco Piraneo G. All rights reserved.
//

import XCTest
@testable import ECDH_Curve25519

class AlgorithmCurve25519Tests: XCTestCase {

    func testGetPublicKeyAlice() {
        let AlicePublicKey = try? AlgorithmService.GetPublicKey(NaCL_Curve25519TestVectors.AlicePrivateKey)
        XCTAssertEqual(NaCL_Curve25519TestVectors.AlicePublicKey, AlicePublicKey)
    }
    
    func testGetPublicKeyBob() {
        let BobPublicKey = try? AlgorithmService.GetPublicKey(NaCL_Curve25519TestVectors.BobPrivateKey)
        XCTAssertEqual(NaCL_Curve25519TestVectors.BobPublicKey, BobPublicKey)
    }

    func testGetSharedKeyAliceBob() {
        let sharedKey = try? AlgorithmService.GetSharedSecretKey(peerPublicKey: NaCL_Curve25519TestVectors.BobPublicKey, privateKey: NaCL_Curve25519TestVectors.AlicePrivateKey)
        XCTAssertEqual(NaCL_Curve25519TestVectors.AliceBobSharedKey, sharedKey)
    }
    
    func testGetSharedKeyAliceFrank0() {
        let sharedKey = try? AlgorithmService.GetSharedSecretKey(peerPublicKey: NaCL_Curve25519TestVectors.FrankPublicKey0, privateKey: NaCL_Curve25519TestVectors.AlicePrivateKey)
        XCTAssertEqual(NaCL_Curve25519TestVectors.AliceFrankSharedKey, sharedKey)
    }
    
    func testGetSharedKeyAliceFrank() {
        let sharedKey = try? AlgorithmService.GetSharedSecretKey(peerPublicKey: NaCL_Curve25519TestVectors.FrankPublicKey, privateKey: NaCL_Curve25519TestVectors.AlicePrivateKey)
        XCTAssertEqual(NaCL_Curve25519TestVectors.AliceFrankSharedKey, sharedKey)
    }
    
    func testGetSharedKeyBobAlice() {
        let sharedKey = try? AlgorithmService.GetSharedSecretKey(peerPublicKey: NaCL_Curve25519TestVectors.AlicePublicKey, privateKey: NaCL_Curve25519TestVectors.BobPrivateKey)
        XCTAssertEqual(NaCL_Curve25519TestVectors.AliceBobSharedKey, sharedKey)
    }
    
    func testGetSharedKeyBobFrank() {
        let sharedKey = try? AlgorithmService.GetSharedSecretKey(peerPublicKey: NaCL_Curve25519TestVectors.FrankPublicKey, privateKey: NaCL_Curve25519TestVectors.BobPrivateKey)
        XCTAssertEqual(NaCL_Curve25519TestVectors.BobFrankSharedKey, sharedKey)
    }
    
    func testGetSharedKeyBobAlice2() {
        let sharedKey = try? AlgorithmService.GetSharedSecretKey(peerPublicKey: NaCL_Curve25519TestVectors.AlicePublicKey2, privateKey: NaCL_Curve25519TestVectors.BobPrivateKey)
        XCTAssertEqual(NaCL_Curve25519TestVectors.AliceBobSharedKey, sharedKey)
    }
}
