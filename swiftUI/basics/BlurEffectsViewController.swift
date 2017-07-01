//
//  BlurEffectsViewController.swift
//  swiftUI
//
//  Created by duzhe on 2017/6/30.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

class BlurEffectsViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Blur Effects"
    
    /* 创建模糊特效  */
    let blurEffect = UIBlurEffect(style: .light)
    
    /* 创建模糊view */
    let blurView = UIVisualEffectView(effect: blurEffect)
    blurView.frame.size = CGSize(width: 200, height: 200)
    blurView.center = view.center
    
    view.addSubview(blurView)
  }
  
}
