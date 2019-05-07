//
//  FieldElement.swift
//  ECDH-Curve25519
//
//  Created by Francesco Piraneo G. on 30.04.19.
//  Copyright © 2019 Francesco Piraneo G. All rights reserved.
//

import Foundation

struct FieldElement {
    var X0: Int
    var X1: Int
    var X2: Int
    var X3: Int
    var X4: Int
    var X5: Int
    var X6: Int
    var X7: Int
    var X8: Int
    var X9: Int
    
    init() {
        try! self.init(elements: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
    }
    
    init(elements: [Int]) throws {
        if elements.count != 10 {
            throw Exceptions.ArgumentException(message: "elements array must have 10 elements")
        }
    
        X0 = elements[0]
        X1 = elements[1]
        X2 = elements[2]
        X3 = elements[3]
        X4 = elements[4]
        X5 = elements[5]
        X6 = elements[6]
        X7 = elements[7]
        X8 = elements[8]
        X9 = elements[9]
    }
    
    init(_ x0: Int, _ x1: Int, _ x2: Int, _ x3: Int, _ x4: Int, _ x5: Int, _ x6: Int, _ x7: Int, _ x8: Int, _ x9: Int) {
        X0 = x0
        X1 = x1
        X2 = x2
        X3 = x3
        X4 = x4
        X5 = x5
        X6 = x6
        X7 = x7
        X8 = x8
        X9 = x9
    }
}
