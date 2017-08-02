//
//  CountdownButton.swift
//  swiftUI
//  自定义倒计时 按钮
//  Created by duzhe on 2017/7/7.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

public class CountdownButton: UIButton {
  typealias Task = (_ cancel : Bool) -> ()
  var task:Task?
  
  public var countTextColor: UIColor = UIColor.lightGray {
    didSet{
      countLabel.textColor = countTextColor
    }
  }
  public var countFont: UIFont = UIFont.pingFangSC(ofSize: 14){
    didSet{
      countLabel.font = countFont
    }
  }
  public var totalTimes:Int = 60   // 总数 倒计时用
  {
    didSet{
      currentTime = totalTimes
    }
  }
  
  public var step: Int = 1 // 步长 默认为 1
  public var insteadString: String = "%s秒后重新获取"  // 必须包含 ‘%s’
  
  private var currentTime: Int = 0
  public var attributeText: NSMutableAttributedString? {
    didSet{
      self.setAttributedTitle(attributeText, for: .normal)
    }
  }
  private lazy var countLabel: UILabel = {
    let label = UILabel()
    label.textColor = self.countTextColor
    label.font = self.countFont
    label.textAlignment = .center
    return label
  }()
  
  private var countDidStop: ((Void)->Void)?
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    prepareView()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    prepareView()
  }
  
  override public func layoutSubviews() {
    super.layoutSubviews()
    countLabel.frame = bounds
  }
  
  // 布局
  func prepareView(){
    self.titleLabel?.text = ""
    self.setTitle("", for: .normal)
    currentTime = totalTimes
    countLabel.text = insteadString.replacingOccurrences(of: "%s", with: "\(self.currentTime)")
    addSubview(countLabel)
    countLabel.isHidden = true
  }
  
  public func start(){
    
    self.setAttributedTitle(NSMutableAttributedString(), for: .normal)
    countLabel.text = insteadString.replacingOccurrences(of: "%s", with: "\(self.currentTime)")
    countLabel.isHidden = false
    countingTask()
  }
  
  public func handleCountDidStop(countDidStop: ((Void)->Void)?){
    self.countDidStop = countDidStop
  }
  
  
  private func countingTask(){
    // 每一秒 执行一次
    self.cancel(self.task)
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
  
  
  public func stop() {
    self.cancel(self.task)
    if let attributeText = attributeText {
      self.setAttributedTitle(attributeText, for: .normal)
    }
    countLabel.isHidden = true
    currentTime = totalTimes
    self.countDidStop?()
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


