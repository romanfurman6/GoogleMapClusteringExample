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
  func add(
    _ item: QuadTreeItem,
    with bounds: QuadTreeBounds,
    at depth: UInt
  )
  func remove(_ item: QuadTreeItem, with bounds: QuadTreeBounds) -> Bool
  func search(
    with searchBounds: QuadTreeBounds,
    and ownBounds: QuadTreeBounds,
    result: inout [QuadTreeItem]
  )
  func split(with bounds: QuadTreeBounds, at depth: UInt)
}

class QuadTreeChild: QuadTreeChildProtocol {

  private var topRight: QuadTreeChild? = nil
  private var topLeft: QuadTreeChild? = nil
  private var bottomRight: QuadTreeChild? = nil
  private var bottomLeft: QuadTreeChild? = nil
  private var items = [QuadTreeItem]()
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

  private func addTo(childPosition: ChildPosition, item: QuadTreeItem, bounds: QuadTreeBounds, depth: UInt) {
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

  private func remove(from position: ChildPosition, item: QuadTreeItem, with bounds: QuadTreeBounds) -> Bool {
    guard
      let topRight = topRight,
      let topLeft = topLeft,
      let bottomRight = bottomRight,
      let bottomLeft = bottomLeft
    else { return false }

    switch position {
    case let .topRight(parentBounds):
      return topRight.remove(item, with: parentBounds)
    case let .topLeft(parentBounds):
      return topLeft.remove(item, with: parentBounds)
    case let .bottomRight(parentBounds):
      return bottomRight.remove(item, with: parentBounds)
    case let .bottomLeft(parentBounds):
      return bottomLeft.remove(item, with: parentBounds)
    }
  }

  func remove(_ item: QuadTreeItem, with bounds: QuadTreeBounds) -> Bool {
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
      return remove(from: childPosition, item: item, with: bounds)
    }
    let index = items.index(where: { return $0 == item })
    if let index = index {
      items.remove(at: index)
      return true
    }
    return false
  }

  func search(with searchBounds: QuadTreeBounds, and ownBounds: QuadTreeBounds, result: inout [QuadTreeItem]) {
    if topRight != nil {
      let topRightBounds = getBounds(of: ChildPosition.topRight(parentBounds: ownBounds))
      let topLeftBounds = getBounds(of: ChildPosition.topLeft(parentBounds: ownBounds))
      let bottomRightBounds = getBounds(of: ChildPosition.bottomRight(parentBounds: ownBounds))
      let bottomLeftBounds = getBounds(of: ChildPosition.bottomLeft(parentBounds: ownBounds))
      
      if boundsIntersects(firstBounds: topRightBounds, secondBounds: searchBounds) {
        topRight?.search(with: searchBounds, and: topRightBounds, result: &result)
      }
      if boundsIntersects(firstBounds: topLeftBounds, secondBounds: searchBounds) {
        topLeft?.search(with: searchBounds, and: topLeftBounds, result: &result)
      }
      if boundsIntersects(firstBounds: bottomRightBounds, secondBounds: searchBounds) {
        bottomRight?.search(with: searchBounds, and: bottomRightBounds, result: &result)
      }
      if boundsIntersects(firstBounds: bottomLeftBounds, secondBounds: searchBounds) {
        bottomLeft?.search(with: searchBounds, and: bottomLeftBounds, result: &result)
      }
    } else {
      for item in items {
        let point = item.point
        if (point.x <= searchBounds.maxX &&
          point.x >= searchBounds.minX &&
          point.y <= searchBounds.maxY &&
          point.y >= searchBounds.minY) {
          result.append(item)
        }
      }
    }
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
