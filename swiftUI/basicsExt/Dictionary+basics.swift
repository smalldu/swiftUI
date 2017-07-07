//
//  Dictionary+basics.swift
//  swiftUI
//
//  Created by duzhe on 2017/7/3.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import Foundation

extension Dictionary{
  
  /// 合并两个，键值对类型相同的字典。类似git的merge
  ///
  /// - Parameter other: 这里传入的参数必须是实现Sequence协议 ， Iterator.Element必须是（Key,Value） 。 也可以直接指定为字典类型
  mutating func merge<S>(_ other: S)
    where S:Sequence,S.Iterator.Element == (key:Key,value:Value) {
      for (k,v) in other{
        self[k] = v
      }
  }
  
  /// 使用 Sequence 方式进行初始化
  init<S:Sequence>(_ sequence:S)
    where S.Iterator.Element == (key:Key,value:Value) {
      self = [:]
      self.merge(sequence)
  }
  
  /// key不变只转换Value
  /// 刚好用到上面的初始化方法
  /// - Parameter transform: 转换闭包
  /// - Returns: 返回还是字典类型
  func mapValues<NewValue>(_ transform:(Value)->NewValue)->[Key:NewValue]{
    return Dictionary<Key,NewValue>(
      self.map{ (key,value) in
        return (key,transform(value))
      }
    )
  }
  

}


