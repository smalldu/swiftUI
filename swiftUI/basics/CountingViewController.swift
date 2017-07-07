//
//  CountingViewController.swift
//  swiftUI
//
//  Created by duzhe on 2017/7/7.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

class CountingViewController: UIViewController {
  
  
  @IBOutlet weak var countDownBtn: CountdownButton!
  override func viewDidLoad() {
    super.viewDidLoad()
    countDownBtn.totalTimes = 20
    
  }
  
  @IBAction func start(_ sender: Any) {
    countDownBtn.start()
  }
  
  @IBAction func stop(_ sender: Any) {
    countDownBtn.stop()
  }
}
