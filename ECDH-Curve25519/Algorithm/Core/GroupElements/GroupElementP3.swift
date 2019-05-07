//
//  GroupElementP3.swift
//  ECDH-Curve25519
//
//  Created by Francesco Piraneo G. on 30.04.19.
//  Copyright © 2019 Francesco Piraneo G. All rights reserved.
//

import Foundation

/// Here the group is the set of pairs (x,y) of field elementsx
/// satisfying -x^2 + y^2 = 1 + d x^2y^2
/// where d = -121665/121666.
///
/// Representations:
///     (extended): (X:Y:Z:T) satisfying x=X/Z, y=Y/Z, XY=ZT
struct GroupElementP3 {
    var X: FieldElement
    var Y: FieldElement
    var Z: FieldElement
    var T: FieldElement
}
