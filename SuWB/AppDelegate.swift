//
//  AppDelegate.swift
//  SuWB
//
//  Created by 王文臻 on 15/8/22.
//  Copyright © 2015年 王文臻. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    application.statusBarHidden = false
    application.statusBarStyle = UIStatusBarStyle.Default
    
    self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
    //创建主窗口并且可见（只有这句代码运行后才有主窗口）
    self.window?.makeKeyAndVisible()
    
    let account = AccountTool.account()
    if account == nil {
      self.window?.rootViewController = OAuthViewController()
    }else{
      AccountTool.chooseRootViewController()
    }
    
    return true
  }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    application.beginBackgroundTaskWithExpirationHandler { () -> Void in
        print("进入后台任务")
    }
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }

    func applicationDidReceiveMemoryWarning(application: UIApplication) {
        //内存警告时清除内存的照片缓存
        SDWebImageManager().cancelAll()
        SDWebImageManager().imageCache.clearMemory()

    }

}

