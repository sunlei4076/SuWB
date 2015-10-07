//
//  AccountTool.swift
//  SuWB
//
//  Created by 王文臻 on 15/8/30.
//  Copyright © 2015年 王文臻. All rights reserved.
//

import UIKit

class AccountTool: NSObject {
  /// 账户存放的路径
  private static var accountFile: String {
    let document = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last
    return (document! as NSString).stringByAppendingPathComponent("account.data")
  }
  
  /// 储存账户信息
    class func saveAccount(account: Account, isNeedUpdateExpiresTime:Bool = true) {
    //存储注册时间
        if isNeedUpdateExpiresTime {
            let now = NSDate()
            account.expires_time = now.dateByAddingTimeInterval(NSTimeInterval(account.expires_in!))
        }
    
    NSKeyedArchiver.archiveRootObject(account, toFile: accountFile)
  }
  
  /// 读取账户
  class func account() -> Account?  {
    let account = NSKeyedUnarchiver.unarchiveObjectWithFile(accountFile) as? Account
    let now = NSDate()
    /*
    . - (NSComparisonResult)compare:(NSDate *)anotherDate
    
    将当前对象与参数传递的对象进行比较，如果相同，返回0(NSOrderedSame)；对象时间早于参数时间，返回-1(NSOrderedAscending)；对象时间晚于参数时间，返回1(NSOrderedDescending)
    */
    if account != nil {//有已保存的账户
      if now.compare(account!.expires_time!) == NSComparisonResult.OrderedAscending {//未过期
        return account
      }else { //已过期
        return nil
      }
      
    }else {
      return nil
    }
    
  }
    /**
    根据情况确定进入哪一个rootViewController
    */
  class func chooseRootViewController() {
    
            let CFBundleVersion = "CFBundleVersion"
    
            let lastVersion = NSBundle.mainBundle().infoDictionary![CFBundleVersion] as! String
    
            let defaults = NSUserDefaults.standardUserDefaults()
    
    
            let currentVersion = defaults.stringForKey(CFBundleVersion)
    
    //    myPrint("lastVersion: \(lastVersion),currentVersion: \(currentVersion)")
    
            if currentVersion == lastVersion { //旧版本
                UIApplication.sharedApplication().statusBarHidden = false
                UIApplication.sharedApplication().keyWindow?.rootViewController = TabBarViewController()
            }else { //新版本
                UIApplication.sharedApplication().statusBarHidden = false
                UIApplication.sharedApplication().keyWindow?.rootViewController = NewfeatureViewController()
                defaults.setObject(lastVersion, forKey: CFBundleVersion)
                defaults.synchronize()
  }

  }
    
    /**
    发送获取当前用户的OAuth请求
    
    - parameter param:   请求参数
    - parameter success: 请求成功时调用
    - parameter failure: 请求失败时调用
    */
    class func OAuthWithParam(param: AccountParam,success: (result: AccountResult)->(),failure: (error: NSError)->()) {
        guard let paramDict = (param.keyValues() as NSDictionary) as? [String:String] else {
            print("OAuth模型转字典失败")
            return
        }
        HttpTool.postWithURL("https://api.weibo.com/oauth2/access_token", params: paramDict, success: { (json) -> () in
            success(result: AccountResult(keyValues: json))
            }) { (error) -> () in
                failure(error: error)
        }
    }
}


