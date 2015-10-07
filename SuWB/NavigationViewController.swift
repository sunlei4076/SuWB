//
//  NavigationViewController.swift
//  SuWB
//
//  Created by 王文臻 on 15/8/25.
//  Copyright © 2015年 王文臻. All rights reserved.
//

import UIKit
import FontBlaster

class NavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

  
  //每 第一次使用这个类的时候都会掉用这个方法（没有子类的话调用一次）
  override class func initialize() {
    //设置导航栏主题
    setupNarBarTheme()
    //设置导航栏按钮主题
    setupBarButtomItem()
  }
  
  class func setupNarBarTheme() {
    let navBar = UINavigationBar.appearance()
//    navBar.setBackgroundImage(UIImage(named: ""), forBarMetrics: .Default) //ios7 不设置背景
    let shadow = NSShadow()
    shadow.shadowOffset = CGSizeZero
//    FontBlaster.debugEnabled = true
    FontBlaster.blast()
    let themeFont = UIFont(name: "OpenSans", size: 20)
    navBar.titleTextAttributes = [NSFontAttributeName: themeFont!, NSShadowAttributeName: shadow]
    
  }
  
  class func setupBarButtomItem() {
    
    let item = UIBarButtonItem.appearance()
    let shadow = NSShadow()
    shadow.shadowOffset = CGSizeZero
    let attributes = [NSFontAttributeName: UIFont.systemFontOfSize(17),NSShadowAttributeName: shadow,NSForegroundColorAttributeName: UIColor.orangeColor()]
    item.setTitleTextAttributes(attributes, forState: .Normal)
    item.setTitleTextAttributes(attributes, forState: .Highlighted)
    
    let disabledShadow = NSShadow()
    disabledShadow.shadowOffset = CGSizeZero
    let disabledAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(17),NSShadowAttributeName: shadow,NSForegroundColorAttributeName: UIColor.lightGrayColor()]
    item.setTitleTextAttributes(disabledAttributes, forState: .Disabled)
  }
  
  //重写父类的push方法，使的每次push一个控制器的时不需要每次设置隐藏bottomBar
  override func pushViewController(viewController: UIViewController, animated: Bool) {
    self.hidesBottomBarWhenPushed = true
    super.pushViewController(viewController, animated: animated)
  }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
  

}
