//
//  SZNavigationController.swift
//  swiftUI
//
//  Created by duzhe on 2017/7/8.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

private let _sw: CGFloat = UIScreen.main.bounds.width
private let _sh: CGFloat = UIScreen.main.bounds.height
private let kDefaultAlpha:CGFloat = 0.6
private let kTargetTranslateScale:CGFloat = 0.75
class SZNavigationController: UINavigationController , UINavigationControllerDelegate{
  
  private lazy var animateController: SZAnimationController = SZAnimationController()
  var  panGestureRec:UIScreenEdgePanGestureRecognizer!
  
  private var screenshotImgView:UIImageView!
  private var coverView:UIView!
  private var screenshotImgs: [UIImage?] = []
  private var nextVCScreenShotImg: UIImage?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.delegate = self
    self.view.layer.shadowColor = UIColor.black.cgColor
    self.view.layer.shadowOffset = CGSize(width: -0.8, height: 0)
    self.view.layer.shadowOpacity = 0.6
    
    panGestureRec = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(panGestureRecognizer(_:)))
    panGestureRec.edges = .left
    // 为导航控制器的view添加Pan手势识别器
    self.view.addGestureRecognizer(panGestureRec)
    
    // 2.创建截图的ImageView
    screenshotImgView = UIImageView()
    // app的frame是包括了状态栏高度的frame
    screenshotImgView.frame = CGRect(x: 0, y: 0, width: _sw , height: _sh)
    
    // 3.创建截图上面的黑色半透明遮罩
    coverView = UIView()
    // 遮罩的frame就是截图的frame
    coverView.frame = screenshotImgView.frame
    // 遮罩为黑色
    coverView.backgroundColor = UIColor.black
  }
  
  override func pushViewController(_ viewController: UIViewController, animated: Bool) {
    // 只有在导航控制器里面有子控制器的时候才需要截图
    if self.viewControllers.count >= 1{
      // 调用自定义方法,使用上下文截图
      self.screenShot()
    }
    super.pushViewController(viewController, animated: animated)
  }
  
  
  func screenShot(){
    // 将要被截图的view,即窗口的根控制器的view(必须不含状态栏,默认ios7中控制器是包含了状态栏的)
    guard let beyondVC = self.view.window?.rootViewController else {return }
    // 背景图片 总的大小
    let size = beyondVC.view.frame.size
    // 开启上下文,使用参数之后,截出来的是原图（true  0.0 质量高）
    UIGraphicsBeginImageContextWithOptions(size, true, 0.0);
    // 要裁剪的矩形范围
    let rect = CGRect(x: 0, y: 0, width: _sw, height: _sh)
    //注：iOS7以后renderInContext：由drawViewHierarchyInRect：afterScreenUpdates：替代
    //判读是导航栏是否有上层的Tabbar  决定截图的对象
    if self.tabBarController == beyondVC {
      beyondVC.view.drawHierarchy(in: rect, afterScreenUpdates: false)
    }else{
      self.view.drawHierarchy(in: rect, afterScreenUpdates: false)
    }
    // 从上下文中,取出UIImage
    let snapshot = UIGraphicsGetImageFromCurrentImageContext()
    // 添加截取好的图片到图片数组
    if snapshot != nil {
      self.screenshotImgs.append(snapshot)
    }
    // 千万记得,结束上下文(移除栈顶的基于当前位图的图形上下文)
    UIGraphicsEndImageContext()
  }
  
  
  override func popViewController(animated: Bool) -> UIViewController? {
    let index = self.viewControllers.count
//    var className: String = ""
//    if index>=2 {
//      className = NSStringFromClass(self.viewControllers[index-2].classForCoder)
//    }
    if screenshotImgs.count>index-1{
      screenshotImgs.removeLast()
    }
    return super.popViewController(animated: animated)
  }
  
  override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
    var removeCount = 0
    let arr:[UIViewController] = self.viewControllers.reversed()
    for i in 0..<self.viewControllers.count {
      if viewController == arr[i] {
        break
      }
      screenshotImgs.removeLast()
      removeCount += 1
    }
    animateController.removeCount = removeCount
    return super.popToViewController(viewController, animated: animated)
  }
  
  func panGestureRecognizer(_ panGestureRec: UIScreenEdgePanGestureRecognizer ){
    // 如果当前显示的控制器已经是根控制器了，不需要做任何切换动画,直接返回
    if self.visibleViewController == self.viewControllers.first {
      return
    }
    switch panGestureRec.state {
    case .began:
      dragBegin()
    case .cancelled,.failed,.ended:
      dragEnd()
    default:
      dragging(panGestureRec)
    }
  }
  
  func dragBegin(){
    // 重点,每次开始Pan手势时,都要添加截图imageview 和 遮盖cover到window中
    self.view.window?.insertSubview(screenshotImgView, at: 0)
    self.view.window?.insertSubview(coverView, aboveSubview: screenshotImgView)
    
    // 并且,让imgView显示截图数组中的最后(最新)一张截图
    if screenshotImgs.count > 0 {
      screenshotImgView.image = screenshotImgs.last!
    }
  }
  
  func dragging(_ pan:UIPanGestureRecognizer){
    // 得到手指拖动的位置
    let offsetX = pan.translation(in: self.view).x
    // 让整个view都平移     // 挪动整个导航view
    if offsetX > 0{
      self.view.transform = CGAffineTransform.identity.translatedBy(x: offsetX, y: 0)
    }
    // 计算目前手指拖动位移占屏幕总的宽高的比例,当这个比例达到3/4时, 就让imageview完全显示，遮盖完全消失
    let currentTranslateScaleX = offsetX/self.view.frame.width
    if offsetX < _sw {
      self.screenshotImgView.transform = CGAffineTransform.identity.translatedBy(x: (offsetX - _sw) * 0.6, y: 0)
    }
    // 让遮盖透明度改变,直到减为0,让遮罩完全透明,默认的比例-(当前平衡比例/目标平衡比例)*默认的比例
    let alpha = kDefaultAlpha - (currentTranslateScaleX/kTargetTranslateScale) * kDefaultAlpha
    coverView.alpha = alpha
  }
    
  ///结束拖动,判断结束时拖动的距离作相应的处理,并将图片和遮罩从父控件上移除
  func dragEnd(){
    // 取出挪动的距离
    let translateX = self.view.transform.tx
    // 取出宽度
    let width = self.view.frame.size.width
    
    if translateX <= 40 {
      // 如果手指移动的距离还不到屏幕的一半,往左边挪 (弹回)
      UIView.animate(withDuration: 0.3, animations: {
        self.view.transform = CGAffineTransform.identity
        // 重要~~让被右移的view弹回归位,只要清空transform即可办到
        self.screenshotImgView.transform = CGAffineTransform.identity.translatedBy(x: -_sw, y: 0)
        // 让遮盖的透明度恢复默认的alpha 1.0
        self.coverView.alpha = kDefaultAlpha
        
      }, completion: { _ in
        // 重要,动画完成之后,每次都要记得 移除两个view,下次开始拖动时,再添加进来
        self.screenshotImgView.removeFromSuperview()
        self.coverView.removeFromSuperview()
      })
    }else{
      // 如果手指移动的距离还超过了屏幕的一半,往右边挪
      UIView.animate(withDuration: 0.3, animations: { 
        // 让被右移的view完全挪到屏幕的最右边,结束之后,还要记得清空view的transform
        self.view.transform = CGAffineTransform.identity.translatedBy(x: width, y: 0)
        // 让imageView位移还原
        self.screenshotImgView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 0)
        // 让遮盖alpha变为0,变得完全透明
        self.coverView.alpha = 0
      }, completion: { _ in
        // 重要~~让被右移的view完全挪到屏幕的最右边,结束之后,还要记得清空view的transform,不然下次再次开始drag时会出问题,因为view的transform没有归零
        self.view.transform = CGAffineTransform.identity
        // 移除两个view,下次开始拖动时,再加回来
        self.screenshotImgView.removeFromSuperview()
        self.coverView.removeFromSuperview()
        // 执行正常的Pop操作:移除栈顶控制器,让真正的前一个控制器成为导航控制器的栈顶控制器
        _ = self.popViewController(animated: false)
        
        // 重要~记得这时候,可以移除截图数组里面最后一张没用的截图了
        // [_screenshotImgs removeLastObject];
        self.animateController.removeAllScreenShot()
      })
    }
  }
  
  
  func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
    animateController.navigationOperator = operation
    animateController.navigationController = navigationController
    
    return animateController
  }
}


class SZAnimationController: NSObject , UIViewControllerAnimatedTransitioning {
  var navigationOperator: UINavigationControllerOperation = .none
  var isTabbarExist: Bool = false
  var removeCount: Int = 0
  private var screenShotArray: [UIImage?] = []
  
  var navigationController: UINavigationController! {
    didSet{
      let beyoundVC = self.navigationController.view.window?.rootViewController
      if self.navigationController.tabBarController == beyoundVC {
        isTabbarExist = true
      }else{
        isTabbarExist = false
      }
      
    }
  }
  
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.4
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    // from 表示即将消失的视图控制器 to 表示将要展示的视图控制器
    guard let fromViewController = transitionContext.viewController(forKey: .from) else {
      return
    }
    guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
    guard let toView = transitionContext.view(forKey: .to) else{ return }
    
    // 截图
    let screentImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: _sw , height: _sh))
    let screenImg = self.screenShot()
    screentImgView.image = screenImg
    
    
    
    var fromViewEndFrame = transitionContext.finalFrame(for: fromViewController)
    fromViewEndFrame.origin.x = _sw
    
    var fromViewStartFrame = fromViewEndFrame
    let toViewEndFrame = transitionContext.finalFrame(for: toViewController)
    let toViewStartFrame = toViewEndFrame
    
    let containerView = transitionContext.containerView
    
    if navigationOperator == .push {
      screenShotArray.append(screenImg)
      //这句非常重要，没有这句，就无法正常Push和Pop出对应的界面
      containerView.addSubview(toView)
      toView.frame = toViewStartFrame
      
      let nextVC = UIView(frame: CGRect(x: _sw, y: 0, width: _sw, height: _sh))
      //将截图添加到导航栏的View所属的window上
      self.navigationController.view.window?.insertSubview(screentImgView, at: 0)
      
      nextVC.layer.shadowColor = UIColor.black.cgColor
      nextVC.layer.shadowOffset = CGSize(width: -0.8, height: 0)
      nextVC.layer.shadowOpacity = 0.6
      
      self.navigationController.view.transform = CGAffineTransform.identity.translatedBy(x: _sw, y: 0)
      
      UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { 
        self.navigationController.view.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 0)
        screentImgView.center = CGPoint(x: -_sw/2, y: _sh/2)
      }, completion: { _ in
        nextVC.removeFromSuperview()
        screentImgView.removeFromSuperview()
        transitionContext.completeTransition(true)
      })
    }
    if navigationOperator == .pop {
      
      fromViewStartFrame.origin.x = 0
      containerView.addSubview(toView)
      
      let lastVcImgView = UIImageView(frame: CGRect(x: -_sw , y: 0, width: _sw , height: _sh))
      //若removeCount大于0  则说明Pop了不止一个控制器
      if removeCount > 0 {
        for i in 0..<removeCount{
          if i == removeCount - 1 {
            //当删除到要跳转页面的截图时，不再删除，并将该截图作为ToVC的截图展示
            lastVcImgView.image = self.screenShotArray.last!
            removeCount = 0
            break
          }else{
            screenShotArray.removeLast()
          }
        }
      }else{
        lastVcImgView.image = screenShotArray.last!
      }
      screentImgView.layer.shadowColor = UIColor.black.cgColor
      screentImgView.layer.shadowOffset = CGSize(width: -0.8, height: 0)
      screentImgView.layer.shadowOpacity = 0.6
      self.navigationController.view.window?.addSubview(lastVcImgView)
      self.navigationController.view.addSubview(screentImgView)

      UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { 
        screentImgView.center = CGPoint(x: _sw*3/2, y: _sh/2)
        lastVcImgView.center = CGPoint(x: _sw/2, y: _sh/2)
      }, completion: { _ in
        lastVcImgView.removeFromSuperview()
        screentImgView.removeFromSuperview()
        self.screenShotArray.removeLast()
        transitionContext.completeTransition(true)
      })
    }
  }
  
  func removeLastScreenShot(){
    self.screenShotArray.removeLast()
  }
  
  func removeAllScreenShot(){
    self.screenShotArray.removeAll()
  }
  
  func removeLast(of number:Int){
    for _ in 0..<number{
      self.screenShotArray.removeLast()
    }
  }
  
  /// 截图
  ///
  /// - Returns:
  func screenShot()->UIImage?{
    // 将要被截图的view,即窗口的根控制器的view
    guard let beyondVC = self.navigationController?.view.window?.rootViewController else { return nil }
    // 背景图片 总的大小
    let size = beyondVC.view.frame.size
    // 开启上下文,使用参数之后,截出来的是原图（true  0.0 质量高）
    UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
    
    // 要裁剪的矩形范围
    let rect = CGRect(x: 0, y: 0, width: _sw, height: _sh)
    //注：iOS7以后renderInContext：由drawViewHierarchyInRect：afterScreenUpdates：替代
    
    //判读是导航栏是否有上层的Tabbar  决定截图的对象
    if isTabbarExist {
      beyondVC.view.drawHierarchy(in: rect, afterScreenUpdates: false)
    }else{
      self.navigationController.view.drawHierarchy(in: rect, afterScreenUpdates: false)
    }
    // 从上下文中,取出UIImage
    let snapshot = UIGraphicsGetImageFromCurrentImageContext()
    
    // 千万记得,结束上下文(移除栈顶的基于当前位图的图形上下文)
    UIGraphicsEndImageContext()
    // 返回截取好的图片
    return snapshot
  }
  
  
}

