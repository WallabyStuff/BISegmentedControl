//
//  BISegmentedControl
//  UIView+Metrics.swift
//
//  Created by Wallaby
//  Copyright © 2022 Wallaby. All rights reserved. 2022/11/01
//


import UIKit

extension UIView {
  func isInBound(point: CGPoint) -> Bool {
    return isInWidthBound(point: point) && isInHeightBound(point: point)
  }
  
  func isInWidthBound(point: CGPoint) -> Bool {
    return self.leftX <= point.x && point.x <= self.rightX
  }
  
  func isInHeightBound(point: CGPoint) -> Bool {
    return self.topY <= point.y && point.y <= self.bottomY
  }
  
  var topY: CGFloat {
    return self.frame.origin.y
  }
  
  var leftX: CGFloat {
    return self.frame.origin.x
  }
  
  var rightX: CGFloat {
    return self.frame.origin.x + self.frame.width
  }
  
  var bottomY: CGFloat {
    return self.frame.origin.y + self.frame.height
  }
}
