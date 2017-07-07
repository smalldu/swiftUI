//
//  CountdownButton.swift
//  swiftUI
//  自定义倒计时 按钮
//  Created by duzhe on 2017/7/7.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

class CountdownButton: UIButton {
  typealias Task = (_ cancel : Bool) -> ()
  var task:Task?
  
  var countTextColor: UIColor = UIColor.lightGray {
    didSet{
      countLabel.textColor = countTextColor
    }
  }
  var totalTimes:Int = 60   // 总数 倒计时用
  {
    didSet{
      currentTime = totalTimes
    }
  }
  
  var step: Int = 1 // 步长 默认为 1
  var insteadString: String = "%s秒后重新获取"  // 必须包含 ‘%s’
  fileprivate var currentTime: Int = 0
  fileprivate var title: String?
  private lazy var countLabel: UILabel = {
    let label = UILabel()
    label.textColor = self.countTextColor
    label.font = self.titleLabel?.font
    label.textAlignment = .center
    return label
  }()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    prepareView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    prepareView()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    countLabel.frame = bounds
  }
  
  // 布局
  func prepareView(){
    currentTime = totalTimes
    countLabel.text = insteadString.replacingOccurrences(of: "%s", with: "\(self.currentTime)")
    title = self.titleLabel?.text
    addSubview(countLabel)
    countLabel.isHidden = true
  }
  
  func start(){
    setTitle("", for: .normal)
    countLabel.text = insteadString.replacingOccurrences(of: "%s", with: "\(self.currentTime)")
    countLabel.isHidden = false
    countingTask()
  }
  
  
  private func countingTask(){
    // 每一秒 执行一次
    self.task = delay(1, task: { [weak self] in
      guard let strongSelf = self else{ return }
      strongSelf.currentTime -= 1
      print(strongSelf.currentTime)
      DispatchQueue.main.async {
        strongSelf.countLabel.text = strongSelf.insteadString.replacingOccurrences(of: "%s", with: "\(strongSelf.currentTime)")
      }
      if strongSelf.currentTime == 0 {
        strongSelf.stop()
      }else{
        strongSelf.countingTask()
      }
    })
  }
  
  
  func stop() {
    self.cancel(self.task)
    
    setTitle(self.title ?? "", for: .normal)
    countLabel.isHidden = true
    currentTime = totalTimes
  }
  
  
  @discardableResult
  func delay(_ time:TimeInterval, task:@escaping ()->()) ->  Task? {
    
    func dispatch_later(_ block: (()->())?) {
      DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
        execute: block!)
    }
    var result: Task?
    let delayedClosure: Task = {
      cancel in
      if (cancel == false) {
        DispatchQueue.main.async(execute: task)
      }
      result = nil
    }
    result = delayedClosure
    dispatch_later {
      if let delayedClosure = result {
        delayedClosure(false)
      }
    }
    return result
  }
  func cancel(_ task:Task?) {
    task?(true)
  }
}


