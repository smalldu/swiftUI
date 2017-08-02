//
//  ViewController.swift
//  swiftUI
//
//  Created by duzhe on 2017/6/30.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let seq = stride(from: 0, to: 10, by: 2)
    for item in seq{
      print(item)
    }
  }
  
}
