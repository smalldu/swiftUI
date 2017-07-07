//
//  FontsViewController.swift
//  swiftUI
//
//  Created by duzhe on 2017/7/7.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

class FontsViewController: UIViewController , UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  
  var fontNames:[String] = UIFont.familyNames
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.rowHeight = 50
    tableView.dataSource = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = fontNames[indexPath.row]
    cell.textLabel?.font = UIFont(name: fontNames[indexPath.row] , size: 17)
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return fontNames.count
  }
  
}
