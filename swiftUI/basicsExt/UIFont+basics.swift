//
//  UIFont+basics.swift
//  swiftUI
//
//  Created by duzhe on 2017/7/7.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit


extension UIFont {

  static func pingFangSC(ofSize size:CGFloat) -> UIFont{
    if let font = UIFont(name: "PingFang SC", size: size) {
      return font
    }else {
      return UIFont.systemFont(ofSize:size)
    }
  }
  
}




