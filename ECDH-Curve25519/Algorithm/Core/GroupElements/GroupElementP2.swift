//
//  GroupElementP2.swift
//  ECDH-Curve25519
//
//  Created by Francesco Piraneo G. on 30.04.19.
//  Copyright © 2019 Francesco Piraneo G. All rights reserved.
//

import Foundation

/// Here the group is the set of pairs (x,y) of field elements
/// satisfying -x^2 + y^2 = 1 + d x^2y^2
/// where d = -121665/121666.
///
/// Representations:
///     (projective): (X:Y:Z) satisfying x=X/Z, y=Y/Z
struct GroupElementP2 {
    var X: FieldElement
    var Y: FieldElement
    var Z: FieldElement
}
