//
//  AppDelegate.swift
//  GoogleMapClusteringExample
//
//  Created by Roman Furman on 9/27/17.
//  Copyright © 2017 Roman Furman. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    GMSServices.provideAPIKey(Constants.googleMapKey)
    self.window = UIWindow(frame: UIScreen.main.bounds)
    let mapViewController = MapViewController.initFromStoryboard()
    window?.rootViewController = mapViewController
    window?.makeKeyAndVisible()
    
    return true
  }

}

