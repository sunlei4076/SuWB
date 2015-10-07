//
//  TabBarViewController.swift
//  SuWB
//
//  Created by 王文臻 on 15/8/22.
//  Copyright © 2015年 王文臻. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
  
    var customTabBar:CustomTabBar?
    
    var home: HomeViewController?
    var me: MeViewController!
    var discover: DiscoverViewController!
    var message: MessageViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
  
        //初始化自定义的tabbar
        setupTabBar()
        //设置所有子控制器
        setupAllChildViewController()
    
        let timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "checkUnreadedCount", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    
    }
  
    /**
    请求检查微博未读数
    */
    func checkUnreadedCount() {
        guard let uid = AccountTool.account()?.uid else {
            print("uid 过期了")
            return
        }
        let param = UnreadCountParam()
        param.uid = uid
        UserTool.userUnreadCount(param, success: { [unowned self] (result: UnreadCountResult)  -> () in
            print(result)
            self.me.tabBarItem.badgeValue = result.follower!
            self.message.tabBarItem.badgeValue = result.messageCount!
            self.home!.tabBarItem.badgeValue = result.status!
            UIApplication.sharedApplication().applicationIconBadgeNumber = Int(result.count!)!
            }) { (error) -> () in
                print("获取未读信息失败")
        }
        
      
    }
    
    
    
    /**
    只有在view即将出现之前，tabbar上的子控件才存在
    */
  
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        for child in self.tabBar.subviews {
            if child is UIControl {
                child.removeFromSuperview()
            }
        }
    
    }
  
  
  /**
  初始化自定义的tabbar
  */
  private func setupTabBar() {
  
    let tabbar = CustomTabBar()
    tabbar.delegate = self
    tabbar.frame = self.tabBar.bounds
    self.tabBar.addSubview(tabbar)
    customTabBar = tabbar
    
  }
  /**
  初始化所有的子控制器
  */

  private func setupAllChildViewController() {
    
    self.home = {
        let home = HomeViewController()
        setupChildViewController(home, title: "首页", imageName: "tabbar_home_os7", selectedName: "tabbar_home_selected_os7")
        home.tabBarItem.badgeValue = "0"
        return home
    }()
    
    self.message = {
        let message = MessageViewController()
        setupChildViewController(message, title: "消息", imageName: "tabbar_message_center_os7", selectedName: "tabbar_message_center_selected_os7")
        message.tabBarItem.badgeValue = "0"
        return message
    }()
    
    self.discover = {
        let discover = DiscoverViewController()
        setupChildViewController(discover, title: "广场", imageName: "tabbar_discover_os7", selectedName: "tabbar_discover_selected_os7")
        //将提醒数设置nil确保隐藏提醒数字按钮
        discover.tabBarItem.badgeValue = "0"
        return discover
    }()
    
    self.me = {
        let me = MeViewController()
        setupChildViewController(me, title: "我", imageName: "tabbar_profile_os7", selectedName: "tabbar_profile_selected_os7")
        me.tabBarItem.badgeValue = "0"
        return me
    }()
  }
  
  
  /**
  初始化一个子控制器
  
  :param: viewController 需要初始化的控制器
  :param: title          标题
  :param: imageName      图标
  :param: selectedName   选中的图标
  */
  
  private func setupChildViewController(viewController:UIViewController,title:String,imageName:String,selectedName:String) {
    
    viewController.title = title
    viewController.tabBarItem.image = UIImage(named: imageName)
    viewController.tabBarItem.selectedImage = UIImage(named: selectedName)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
    let nav = NavigationViewController(rootViewController: viewController)
    self.addChildViewController(nav)
    
    customTabBar!.addTabBarButtonWithItem(viewController.tabBarItem)
    
  }

}
//MARK: - CustomTarBarDelegate
typealias customTarBarDelegate = TabBarViewController
extension customTarBarDelegate: CustomTarBarDelegate {
  /**
  监听tabbarButton按钮的改变
  
  :param: tabBar                那个tabBar
  :param: didSelectedButtonFrom 原先选中的按钮
  :param: to                    即将选中的按钮
  */
    func tabBar(tabBar: CustomTabBar, didSelectedButtonFrom from: Int, to: Int) {
        self.selectedIndex = to
        if to == 0 {
            if home?.tabBarItem.badgeValue != nil && home?.tabBarItem.badgeValue > "0" {
                home!.refresh()
            }
        }
    }
    
    func tabBar(tabBar: CustomTabBar, didClickedAddButton: UIButton) {
        
        let nav = NavigationViewController(rootViewController: ComposeViewController())
        presentViewController(nav, animated: true, completion: nil)
    }
  
}
