//
//  ClusterManager.swift
//  GoogleMapClusteringExample
//
//  Created by Roman Furman on 10/9/17.
//  Copyright © 2017 Roman Furman. All rights reserved.
//

import Foundation
import GoogleMaps

protocol ClusterManager {
  var delegate: GMUClusterManagerDelegate { get set }
  // mapDelegate = 'GoogleMapView'.delegate
  var mapDelegate: GMSMapViewDelegate { get set }
  init(mapView: GMSMapView, algorithm: GMUClusterAlgorithm, renderer: GMUClusterRenderer)
  func add(_ item: ClusterItem)
  func add(_ items: [ClusterItem])
  func removeItem(_ item: ClusterItem)
  func clear()
  func cluster()
}
