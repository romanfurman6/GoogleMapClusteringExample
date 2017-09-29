//
//  QuadTreeBounds.swift
//  GoogleMapClusteringExample
//
//  Created by Roman Furman on 9/29/17.
//  Copyright © 2017 Roman Furman. All rights reserved.
//

import Foundation

struct QuadTreeBounds {
  let maxX: Double
  let maxY: Double
  let minX: Double
  let minY: Double
}

extension QuadTreeBounds {
  init() {
    self.maxX = -1
    self.minX = -1
    self.maxY = -1
    self.minY = -1
  }
}
