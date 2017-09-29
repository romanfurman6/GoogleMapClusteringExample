//
//  QuadTreeChild.swift
//  GoogleMapClusteringExample
//
//  Created by Roman Furman on 9/29/17.
//  Copyright © 2017 Roman Furman. All rights reserved.
//

import Foundation

enum ChildPosition {
  case topRight(parentBounds: QuadTreeBounds)
  case topLeft(parentBounds: QuadTreeBounds)
  case bottomRight(parentBounds: QuadTreeBounds)
  case bottomLeft(parentBounds: QuadTreeBounds)
}

protocol QuadTreeChildProtocol {
  var count: UInt { get }
  func add(
    _ item: QuadTreeItem,
    with bounds: QuadTreeBounds,
    at depth: UInt
  )
  func remove(_ item: QuadTreeItem, with bounds: QuadTreeBounds) -> Bool
  func search(with bounds: QuadTreeBounds) -> [QuadTreeItem]
  func split(with bounds: QuadTreeBounds, at depth: UInt)
}

class QuadTreeChild: QuadTreeChildProtocol {

  private var topRight: QuadTreeChild? = nil
  private var topLeft: QuadTreeChild? = nil
  private var bottomRight: QuadTreeChild? = nil
  private var bottomLeft: QuadTreeChild? = nil
  private var items = [QuadTreeItem]()

  var count: UInt {
    return 0
  }
  private let maxElements: Int
  private let maxDepth: Int

  init(maxElements: Int = 64, maxDepth: Int = 30) {
    self.maxElements = maxElements
    self.maxDepth = maxDepth
  }

  func add(
    _ item: QuadTreeItem,
    with bounds: QuadTreeBounds,
    at depth: UInt
    ) {
    if items.count >= maxElements && depth < maxDepth {
      self.split(with: bounds, at: depth)
    }

    if topRight != nil {
      let itemPoint = item.point
      let midPoint = getMidPoint(from: bounds)
      var childPosition: ChildPosition!

      if itemPoint.y > midPoint.y {
        let value = itemPoint.x > midPoint.x
        childPosition = value ? .topRight(parentBounds: bounds) : .topLeft(parentBounds: bounds)
      } else {
        let value = itemPoint.x > midPoint.x
        childPosition = value ? .bottomRight(parentBounds: bounds) : .bottomLeft(parentBounds: bounds)
      }
      addTo(childPosition: childPosition, item: item, bounds: bounds, depth: depth)
    } else {
      items.append(item)
    }
  }

  func addTo(childPosition: ChildPosition, item: QuadTreeItem, bounds: QuadTreeBounds, depth: UInt) {
    let childBounds = getBounds(of: childPosition)
    let newDepth = depth + 1
    switch childPosition {
    case .topRight:
      topRight?.add(item, with: childBounds, at: newDepth)
    case .topLeft:
      topLeft?.add(item, with: childBounds, at: newDepth)
    case .bottomRight:
      bottomRight?.add(item, with: childBounds, at: newDepth)
    case .bottomLeft:
      bottomLeft?.add(item, with: childBounds, at: newDepth)
    }
  }

  private func addToTop(right: Bool, item: QuadTreeItem, bounds: QuadTreeBounds, depth: UInt) {
    if right {
      topRight?.add(item, with: bounds, at: depth + 1)
    } else {
      topLeft?.add(item, with: bounds, at: depth + 1)
    }
  }
  private func addToBottom(right: Bool, item: QuadTreeItem, bounds: QuadTreeBounds, depth: UInt) {
    if right {
      bottomRight?.add(item, with: bounds, at: depth + 1)
    } else {
      bottomLeft?.add(item, with: bounds, at: depth + 1)
    }
  }

  func remove(_ item: QuadTreeItem, with bounds: QuadTreeBounds) -> Bool {
//    if topRight != nil {
//      let itemPoint = item.point
//      let midPoint = getMidPoint(from: bounds)
//
//
//    }
    return true
  }
  func search(with bounds: QuadTreeBounds) -> [QuadTreeItem] {
    return []
  }
  func split(with bounds: QuadTreeBounds, at depth: UInt) {

    topRight = QuadTreeChild()
    topLeft = QuadTreeChild()
    bottomRight = QuadTreeChild()
    bottomLeft = QuadTreeChild()

    let items = self.items
    self.items.removeAll()
    for item in items {
      self.add(item, with: bounds, at: depth)
    }
  }

  private func getBounds(of childPosition: ChildPosition) -> QuadTreeBounds {
    switch childPosition {
    case let .topRight(bounds):
      let midPoint = getMidPoint(from: bounds)
      return QuadTreeBounds(
        maxX: midPoint.x,
        maxY: midPoint.y,
        minX: bounds.maxX,
        minY: bounds.maxY
      )
    case let .topLeft(bounds):
      let midPoint = getMidPoint(from: bounds)
      return QuadTreeBounds(
        maxX: bounds.minX,
        maxY: midPoint.y,
        minX: midPoint.x,
        minY: bounds.maxY
      )
    case let .bottomRight(bounds):
      let midPoint = getMidPoint(from: bounds)
      return QuadTreeBounds(
        maxX: midPoint.x,
        maxY: bounds.minY,
        minX: bounds.maxX,
        minY: midPoint.y
      )
    case let .bottomLeft(bounds):
      let midPoint = getMidPoint(from: bounds)
      return QuadTreeBounds(
        maxX: bounds.minX,
        maxY: bounds.minY,
        minX: midPoint.x,
        minY: midPoint.y
      )
    }
  }

  private func getMidPoint(from bounds: QuadTreeBounds) -> QuadTreePoint {
    return QuadTreePoint(
      x: (bounds.minX + bounds.maxX) / 2,
      y: (bounds.minY + bounds.maxY) / 2
    )
  }

  private func boundsIntersects(firstBounds: QuadTreeBounds, secondBounds: QuadTreeBounds) -> Bool {
    return (!(firstBounds.maxY < secondBounds.minY || secondBounds.maxY < firstBounds.minY) &&
      !(firstBounds.maxX < secondBounds.minX || secondBounds.maxX < firstBounds.minX))
  }
}
