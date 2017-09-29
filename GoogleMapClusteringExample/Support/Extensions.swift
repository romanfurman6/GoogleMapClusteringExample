//
//  Extensions.swift
//  GoogleMapClusteringExample
//
//  Created by Roman Furman on 9/28/17.
//  Copyright © 2017 Roman Furman. All rights reserved.
//

import UIKit

// MARK: - StoryboardInitializable

protocol StoryboardInitializable {
  static var storyboardName: String { get }
  static func initFromStoryboard() -> Self
}

extension StoryboardInitializable where Self: UIViewController {
  static var storyboardName: String {
    return String(describing: Self.self)
  }
  
  static func initFromStoryboard() -> Self {
    guard
      let viewController = UIStoryboard(name: storyboardName, bundle: nil).instantiateInitialViewController() as? Self
      else {
        fatalError("Could not instantiate initial view controller from \(storyboardName) storyboard.")
    }
    
    return viewController
  }
  
}

// MARK: - NibInitializable

protocol NibInitializable {
  static var nibName: String { get }
  static func initFromNib() -> Self
}

extension NibInitializable where Self: UIView {
  static var nibName: String {
    return String(describing: Self.self)
  }
  
  static var nib: UINib {
    return UINib(nibName: nibName, bundle: nil)
  }
  
  static func initFromNib() -> Self {
    guard let view = nib.instantiate(withOwner: nil, options: nil).first as? Self else {
      fatalError("Could not instantiate view from nib with name \(nibName).")
    }
    
    return view
  }
}


