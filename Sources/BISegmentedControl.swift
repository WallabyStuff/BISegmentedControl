//
//  BISegmentedControl
//  BISegmentedControl.swift
//
//  Created by Wallaby
//  Copyright © 2022 Wallaby. All rights reserved. 2022/11/01
//

import UIKit

@objc
protocol BISegmentedControlDelegate: AnyObject {
  @objc optional
  func BISegmentedControl(didSelectSegmentAt index: Int)
}

open class BISegmentedControl: UIControl {
  
  // MARK: - Properties
  
  weak var delegate: BISegmentedControlDelegate?
  private let stackView = UIStackView()
  private let barIndicator = UIView()
  
  /**
   Current focused item position
   */
  private(set) var currentPosition = 0
  
  /**
   The bar indicator background color
   */
  open var barIndicatorColor: UIColor = .systemBlue {
    didSet {
      barIndicator.backgroundColor = barIndicatorColor
    }
  }
  
  /**
   The bar indicator width proportion which depends on segmented control item size
   */
  open var barIndicatorWidthProportion: CGFloat = 1.0 {
    didSet {
      updateIndicatorPosition()
    }
  }
  
  /**
   The Bar indicator height
   */
  open var barIndicatorHeight: CGFloat = 4.0 {
    didSet {
      barIndicatorHeightConstraint?.constant = barIndicatorHeight
      barIndicator.layer.cornerRadius = barIndicatorHeight / 2
      layoutIfNeeded()
    }
  }
  
  /**
   The spacing between segmented control items
   */
  open var spacing: CGFloat = 0 {
    didSet {
      stackView.spacing = spacing
    }
  }
  
  /**
   The spacing between the bar indicator and the label.
   */
  open var barIndicatorSpacing: CGFloat = 0 {
    didSet {
      barIndicatorSpacingConstraint?.constant = barIndicatorSpacing
      layoutIfNeeded()
    }
  }
  
  /**
   The font size for focused item
   */
  open var focusedFontSize: CGFloat = 17 {
    didSet {
      focusedItem?.font = .systemFont(ofSize: focusedFontSize, weight: .bold)
    }
  }
  
  /**
   The text color for focused item
   */
  open var focusedTextColor: UIColor = .black {
    didSet {
      focusedItem?.textColor = focusedTextColor
    }
  }
  
  /**
   The font size for unfocused items
   */
  open var defaultFontSize: CGFloat = 17 {
    didSet {
      unfocusedItems.forEach { label in
        label.font = .systemFont(ofSize: defaultFontSize)
      }
    }
  }
  
  /**
   The text color for unfocused items
   */
  open var defaultTextColor: UIColor = .gray {
    didSet {
      unfocusedItems.forEach { label in
        label.textColor = defaultTextColor
      }
    }
  }
  
  // Constraints
  private var barIndicatorLeftConstraint: NSLayoutConstraint?
  private var barIndicatorWidthConstraint: NSLayoutConstraint?
  private var barIndicatorHeightConstraint: NSLayoutConstraint?
  private var barIndicatorSpacingConstraint: NSLayoutConstraint?
  
  
  // MARK: - Initializers
  
  public convenience init() {
    self.init(frame: .zero)
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
  
  
  // MARK: - Overrides
  
  open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    updateIndicatorPosition()
  }
  
  
  // MARK: - Setups
  
  private func setup() {
    setupBarIndicator()
    setupStackView()
    setupGestures()
    setupInitialPosition()
  }
  
  private func setupBarIndicator() {
    barIndicator.backgroundColor = barIndicatorColor
    barIndicator.layer.cornerRadius = barIndicatorHeight / 2
    
    addSubview(barIndicator)
    barIndicator.translatesAutoresizingMaskIntoConstraints = false
    barIndicatorWidthConstraint = barIndicator.widthAnchor.constraint(equalToConstant: 0)
    barIndicatorLeftConstraint = barIndicator.leftAnchor.constraint(equalTo: leftAnchor)
    barIndicatorHeightConstraint = barIndicator.heightAnchor.constraint(equalToConstant: barIndicatorHeight)
    
    barIndicator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    
    barIndicatorHeightConstraint!.isActive = true
    barIndicatorWidthConstraint!.isActive = true
    barIndicatorLeftConstraint!.isActive = true
  }
  
  private func setupStackView() {
    stackView.axis = .horizontal
    stackView.distribution = .fillProportionally
    stackView.backgroundColor = .clear
    stackView.spacing = spacing
    
    addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    stackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    stackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    barIndicatorSpacingConstraint = stackView.bottomAnchor.constraint(equalTo: barIndicator.topAnchor,
                                                                      constant: barIndicatorSpacing)
    
    barIndicatorSpacingConstraint!.isActive = true
  }
  
  private func setupGestures() {
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapSegmentedControl(_:))))
  }
  
  @objc
  private func didTapSegmentedControl(_ sender: UITapGestureRecognizer) {
    let tapPosition = sender.location(in: self)
    for (index, segment) in stackView.arrangedSubviews.enumerated() {
      if segment.isInBound(point: tapPosition) {
        setSelected(index: index)
        return
      }
    }
  }
  
  private func setupInitialPosition() {
    DispatchQueue.main.async {
      self.updateIndicatorPosition()
    }
  }
  
  
  // MARK: - Methods
  
  private func updateIndicatorPosition() {
    if stackView.arrangedSubviews.isEmpty { return }
    
    // Update focused text
    for (index, segmentLabel) in stackView.arrangedSubviews.enumerated() {
      guard let segmentLabel = segmentLabel as? UILabel else {
        return
      }
      
      if index == currentPosition {
        segmentLabel.textColor = focusedTextColor
        segmentLabel.font = UIFont.systemFont(ofSize: focusedFontSize, weight: .bold)
      } else {
        segmentLabel.textColor = defaultTextColor
        segmentLabel.font = UIFont.systemFont(ofSize: defaultFontSize, weight: .medium)
      }
    }
    
    // Update focused indicator bar
    UIView.animate(withDuration: 0.3, delay: 0,
                   usingSpringWithDamping: 1,
                   initialSpringVelocity: 1,
                   options: [.allowUserInteraction, .curveEaseInOut]) {
      // Call layoutIfNeeded to recalculate positions instantly
      self.layoutIfNeeded()
      
      let barIndicatorWidth = self.barIndicatorWidth(at: self.currentPosition)
      let barIndicatorXPosition = self.barIndicatorXPosition(at: self.currentPosition)
      self.barIndicatorWidthConstraint?.constant = barIndicatorWidth
      self.barIndicatorLeftConstraint?.constant = barIndicatorXPosition
      
      // Call layoutIfNeeded to apply updated constraints
      self.layoutIfNeeded()
    }
  }
  
  /**
   Calculated bar indicator width.
   */
  private func barIndicatorWidth(at index: Int) -> CGFloat {
    return stackView.arrangedSubviews[index].frame.width * barIndicatorWidthProportion
  }
  
  /**
    Calculated bar indicator X position.
   */
  private func barIndicatorXPosition(at index: Int) -> CGFloat {
    return stackView.arrangedSubviews[currentPosition].frame.origin.x
  }
  
  private var focusedItem: UILabel? {
    if stackView.arrangedSubviews.isEmpty { return nil }
    guard let focusedItem = stackView.arrangedSubviews[currentPosition] as? UILabel else {
      return nil
    }
    return focusedItem
  }
  
  private var unfocusedItems: [UILabel] {
    var items = [UILabel]()
    for (index, view) in stackView.arrangedSubviews.enumerated() {
      if index == currentPosition { continue }
      if let label = view as? UILabel {
        items.append(label)
      }
    }
    return items
  }
  
  /**
   Add item
   
   - Parameters:
    - title: The segmented control item label text
   */
  open func addItem(title: String) {
    let newItem = UILabel()
    newItem.text = title
    newItem.font = UIFont.systemFont(ofSize: defaultFontSize)
    stackView.addArrangedSubview(newItem)
  }
  
  /**
   Insert Item into particular position
   
   - Parameters:
    - title: The segmented control item label text
    - at: The insert position
   */
  open func insertItem(title: String, at index: Int) {
    if index >= stackView.arrangedSubviews.count {
      addItem(title: title)
    }
    
    let newItem = UILabel()
    newItem.text = title
    newItem.font = UIFont.systemFont(ofSize: defaultFontSize)
    stackView.insertSubview(newItem, at: index)
  }
  
  /**
   Update current position information and bar indicator's position.
   It notifies you where the position changed to through the delegate.
   
   - Parameters:
    - index: The position where you want to move to
   */
  open func setSelected(index: Int) {
    if index >= stackView.arrangedSubviews.count { return }
    currentPosition = index
    updateIndicatorPosition()
    delegate?.BISegmentedControl?(didSelectSegmentAt: index)
  }
}
