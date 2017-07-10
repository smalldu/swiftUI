//
//  LinkableTextView.swift
//  swiftUI
//
//  Created by duzhe on 2017/7/8.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

class LinkableTextView: UITextView , UITextViewDelegate {

  override init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame,textContainer:textContainer)
    DispatchQueue.main.async {
      self.prepareView()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    DispatchQueue.main.async {
      self.prepareView()
    }
  }
  
  // 布局
  func prepareView(){
    isEditable = false
    isSelectable = true
    delegate = self
    dataDetectorTypes = .all
    linkTextAttributes = [ NSForegroundColorAttributeName:UIColor.red ]
    text = "测试连接 https://www.baidu.com 自动识别 13100203949 以及 021-98929384"
  }
  
  func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
    print(URL.absoluteString)
    return true
  }

}
