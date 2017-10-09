//
//  ClusterItem.swift
//  GoogleMapClusteringExample
//
//  Created by Roman Furman on 10/9/17.
//  Copyright © 2017 Roman Furman. All rights reserved.
//

import Foundation

protocol ClusterItem: class {
  var position: Coordinate { get }
  var image: UIImage { get }
}
