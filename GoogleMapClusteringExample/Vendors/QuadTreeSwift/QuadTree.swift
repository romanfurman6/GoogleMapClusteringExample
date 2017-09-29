//
//  QuadTree.swift
//  GoogleMapClusteringExample
//
//  Created by Roman Furman on 9/29/17.
//  Copyright © 2017 Roman Furman. All rights reserved.
//

import Foundation

protocol QuadTreeProtocol {
  var count: UInt { get }
  func searchItem(with bounds: QuadTreeBounds) -> [QuadTreeItem]
  func add(_ item: QuadTreeItem) -> Bool
  func remove(_ item: QuadTreeItem) -> Bool
  func clear()
}

class QuadTree: QuadTreeProtocol {

  var count: UInt {
    return root.count
  }
  private let bounds: QuadTreeBounds
  private var root: QuadTreeChild = QuadTreeChild()

  init(bounds: QuadTreeBounds = QuadTreeBounds() ) {
    self.bounds = bounds
  }

  func add(_ item: QuadTreeItem) -> Bool {
    if beyoundBounds(item) { return false }
    root.add(item, with: bounds, at: 0)
    return true
  }

  func searchItem(with bounds: QuadTreeBounds) -> [QuadTreeItem] {
    return []
  }

  func remove(_ item: QuadTreeItem) -> Bool {
    if beyoundBounds(item) { return false }
    return root.remove(item, with: bounds)
  }

  func clear() {
    root = QuadTreeChild()
  }

  private func beyoundBounds(_ item: QuadTreeItem) -> Bool {
    let point = item.point

    let beyondBoundsX = point.x > bounds.maxX || point.x < bounds.minX

    let beyondBoundsY = point.y > bounds.maxY || point.y < bounds.minY

    return beyondBoundsX || beyondBoundsY
  }

}
