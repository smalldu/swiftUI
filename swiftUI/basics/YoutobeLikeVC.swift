//
//  YoutobeLikeVC.swift
//  swiftUI
//
//  Created by duzhe on 2017/8/2.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit



class YoutobeLikeVC: UIViewController {

    override func viewDidLoad() {
      super.viewDidLoad()
      
      self.navigationController?.navigationBar.backgroundColor = UIColor.red
      
      let titleView = UIView()
      let titleLabel = UILabel()
      titleView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width , height: 44)
      titleView.addSubview(titleLabel)
      titleLabel.frame = CGRect(x: 15, y: 0, width: 50 , height: 44)
      titleLabel.font = UIFont.systemFont(ofSize: 25)
      titleLabel.textColor = UIColor.white
      titleLabel.text = "Youtobe"
      
      self.navigationItem.titleView = titleView
      
    }

}
