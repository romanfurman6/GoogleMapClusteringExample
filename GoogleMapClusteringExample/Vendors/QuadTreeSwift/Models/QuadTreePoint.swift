//
//  QuadTreePoint.swift
//  GoogleMapClusteringExample
//
//  Created by Roman Furman on 9/29/17.
//  Copyright © 2017 Roman Furman. All rights reserved.
//

import Foundation

struct QuadTreePoint {
  let x: Double
  let y: Double
}

extension QuadTreePoint: Equatable {
  static func == (lhs: QuadTreePoint, rhs: QuadTreePoint) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
  }
}
