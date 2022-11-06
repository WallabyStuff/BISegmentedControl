//
//  BISegmentedControl
//  ViewController.swift
//
//  Created by Wallaby
//  Copyright © 2022 Wallaby. All rights reserved. 2022/11/01
//

import UIKit
import BISegmentedControl

class ViewController: UIViewController {
  
  
  // MARK: - Properties
  
  
  // MARK: - UI
  
  var segmentedControl: BISegmentedControl = {
    let segmentedControl = BISegmentedControl()
    segmentedControl.spacing = 4
    segmentedControl.barIndicatorWidthProportion = 0.7
    segmentedControl.focusedFontSize = 24
    
    segmentedControl.addItem(title: "title1")
    segmentedControl.addItem(title: "title2 with some description")
    
    return segmentedControl
  }()
  
  
  // MARK: - LifeCycles
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    segmentedControl.addItem(title: "🦘wallaby")
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  
  // MARK: - Setups
  
  private func setup() {
    setupView()
  }
  
  private func setupView() {
    setupSegmentedControl()
  }
  
  private func setupSegmentedControl() {
    view.addSubview(segmentedControl)
    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      segmentedControl.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }
}

