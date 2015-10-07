//
//  UserTool.swift
//  SuWB
//
//  Created by 王文臻 on 15/9/29.
//  Copyright © 2015年 王文臻. All rights reserved.
//

import UIKit

class UserTool: NSObject {


    /**
    获取用户信息
    
    - parameter param:   请求参数
    - parameter success: 请求成功时调用
    - parameter failure: 请求失败时调用
    */
    class func userInfoWithParam(param:UserParam, success:(result:UserResult)->(),failure:(error:NSError)->()) {
        guard let paramDict = (param.keyValues() as NSDictionary) as? [String:String] else {
            print("获取当前用户昵称的请求参数出错")
            return
        }
        HttpTool.getWithURL("https://api.weibo.com/2/users/show.json", params: paramDict, success: { (json) -> () in
            guard let user = UserResult(keyValues: json) else {
                print("no user status")
                return
            }
            success(result: user)
            }) { (error) -> () in
                failure(error: error)
        }
        
    }
    
    /**
    获取用户微博的未读数
    
    - parameter param:   请求参数
    - parameter success: 请求成功时调用
    - parameter failure: 请求失败时调用
    */
    class func userUnreadCount(param: UnreadCountParam, success:(result:UnreadCountResult)->(), failure:(error:NSError)->()) {
        guard let paramDict = (param.keyValues() as NSDictionary) as? [String:String] else {
            print("获取当前用户未读数的请求参数出错")
            return
        }
        HttpTool.getWithURL("https://rm.api.weibo.com/2/remind/unread_count.json", params: paramDict, success: { (json) -> () in
            guard let user = UnreadCountResult(keyValues: json) else {
                print("no user status")
                return
            }
            success(result: user)
            }) { (error) -> () in
                failure(error: error)
        }
        
    }
}
