//
//  MapViewController.swift
//  GoogleMapClusteringExample
//
//  Created by Roman Furman on 9/28/17.
//  Copyright © 2017 Roman Furman. All rights reserved.
//

import UIKit
import GoogleMaps
import RxSwift
import RxCocoa

final class MapViewController: UIViewController, StoryboardInitializable {

  @IBOutlet weak var mapView: GMSMapView!

  override var prefersStatusBarHidden: Bool { return true }

  override func viewDidLoad() {
    super.viewDidLoad()

  }
  
}

