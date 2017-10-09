//
//  QuadTreeTests.swift
//  GoogleMapClusteringExampleTests
//
//  Created by Roman Furman on 10/2/17.
//  Copyright © 2017 Roman Furman. All rights reserved.
//

import XCTest
@testable import GoogleMapClusteringExample

class QuadTreeTests: XCTestCase {

  var quadTree: QuadTree!
  var items = [
    QuadTreeItem(point: QuadTreePoint(x: 1.0, y: 6.0)),
    QuadTreeItem(point: QuadTreePoint(x: 2.0, y: 5.0)),
    QuadTreeItem(point: QuadTreePoint(x: 3.0, y: 4.0)),
    QuadTreeItem(point: QuadTreePoint(x: 4.0, y: 3.0)),
    QuadTreeItem(point: QuadTreePoint(x: 5.0, y: 2.0)),
    QuadTreeItem(point: QuadTreePoint(x: 6.0, y: 1.0)),
    ]

  override func setUp() {
    super.setUp()
    let quadTreeBounds = QuadTreeBounds(maxX: 5.0, maxY: 5.0, minX: 0.0, minY: 0.0)
    quadTree = QuadTree(bounds: quadTreeBounds)
  }

  func testCount() {
    addItems()
    XCTAssertEqual(quadTree.count, 4)
  }

  func testSearchItem() {
    addItems()
    let testBounds = QuadTreeBounds(maxX: 5.0, maxY: 5.0, minX: 2.0, minY: 2.0)
    let searchItems = quadTree.searchItems(with: testBounds)
    let correctItems = [items[1],items[2],items[3],items[4]]
    XCTAssertEqual(correctItems, searchItems)
  }

  func testAdd() {
    var result = [Bool]()
    let correctResult = [false, true, true, true, true, false]
    for index in 0..<items.count {
      let value = quadTree.add(items[index])
      result.append(value)
    }

    XCTAssertEqual(result, correctResult)

  }

  func testRemove() {
    var result = [Bool]()
    let correctResult = [false, true, true, true, true, false]
    addItems()

    for item in items {
      let value = quadTree.remove(item)
      result.append(value)
    }

    XCTAssertEqual(result, correctResult)
  }

  func testClear() {
    addItems()
    XCTAssertEqual(items.count - 2, Int(quadTree.count))
    _ = quadTree.clear()
    XCTAssertEqual(0, quadTree.count)
  }

  private func addItems() {
    for item in items {
      _ = quadTree.add(item)
    }
  }

}

