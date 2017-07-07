//
//  Set+basics.swift
//  swiftUI
//
//  Created by duzhe on 2017/7/3.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import Foundation


extension Set{
  
  
}

extension Sequence where Iterator.Element: Hashable {
  
  /// 利用Set写的一个数组去重复的方法
  ///
  /// - Returns: 数组
  func unique() -> [Iterator.Element] {
    var seen: Set<Iterator.Element> = []
    return self.filter{
      if seen.contains($0) {
        return false
      }else{
        seen.insert($0)
        return true
      }
    }
  }
}
