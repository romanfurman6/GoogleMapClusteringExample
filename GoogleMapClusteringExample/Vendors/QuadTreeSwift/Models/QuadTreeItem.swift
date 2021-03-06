//
//  QuadTreeItem.swift
//  GoogleMapClusteringExample
//
//  Created by Roman Furman on 9/29/17.
//  Copyright © 2017 Roman Furman. All rights reserved.
//

import Foundation

struct QuadTreeItem {
  let point: QuadTreePoint
}

extension QuadTreeItem: Equatable {
  static func == (lhs: QuadTreeItem, rhs: QuadTreeItem) -> Bool {
    return lhs.point == rhs.point
  }
}
