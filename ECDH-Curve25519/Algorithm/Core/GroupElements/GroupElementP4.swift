//
//  GroupElementP4.swift
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
///     (Duif): (y+x,y-x,2dxy)
struct GroupElementP4 {
    var YplusX: FieldElement
    var YminusX: FieldElement
    var XY2D: FieldElement
    
    init(YplusX: FieldElement, YminusX: FieldElement, XY2D: FieldElement) {
        self.YplusX = YplusX
        self.YminusX = YminusX
        self.XY2D = XY2D
    }
}
