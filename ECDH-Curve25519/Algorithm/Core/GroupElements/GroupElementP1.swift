//
//  GroupElementP1.swift
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
///     (completed): ((X:Z),(Y:T)) satisfying x=X/Z, y=Y/T
struct GroupElementP1 {
    var X: FieldElement
    var Y: FieldElement
    var Z: FieldElement
    var T: FieldElement
}
