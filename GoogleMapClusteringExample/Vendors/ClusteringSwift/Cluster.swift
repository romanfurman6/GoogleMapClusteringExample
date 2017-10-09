//
//  Cluster.swift
//  GoogleMapClusteringExample
//
//  Created by Roman Furman on 10/9/17.
//  Copyright © 2017 Roman Furman. All rights reserved.
//

import Foundation
typealias Coordinate = CLLocationCoordinate2D

protocol Cluster: class {
  var position: Coordinate { get }
  var items: [ClusterItem] { get }
  var count: Int { get }
}
