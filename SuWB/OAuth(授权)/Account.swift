//
//  Account.swift
//  SuWB
//
//  Created by 王文臻 on 15/8/30.
//  Copyright © 2015年 王文臻. All rights reserved.
//  用户账号信息

/*

"access_token" = "2.00yY_rQDZiW6QC014f876084Hu2FdC";
"expires_in" = 157679999;
"remind_in" = 157679999;
uid = 2997526460;
*/

/*
client_id	true	string	申请应用时分配的AppKey。 2074771011
client_secret	true	string	申请应用时分配的AppSecret。  Secret：c629b86d320619fc98bb66f16942518d
grant_type	true	string	请求的类型，填写authorization_code

grant_type为authorization_code时
必选	类型及范围	说明
code	true	string	调用authorize获得的code值。
redirect_uri	true	string	回调地址，需需与注册应用里的回调地址一致。   https://api.weibo.com/oauth2/default.html

*/

import UIKit

class Account: NSObject,NSCoding {
  
    /**
    令牌
    */
    var access_token:String?
    /**
    令牌到期时间
    */
    var expires_in:NSNumber?
    /**
    提醒
    */
    var remind_in:String?
    /**
    登陆用户ID
    */
    var uid:String?
    /**
    过期时间
    */
    var expires_time:NSDate?
    /**
    用户的昵称
    */
    var name:String?
  
    /// 创建account账户模型
    class func accountWithDict(dict: [String: AnyObject]) -> Account {
        return Account(dict: dict)
    }
  
  /**
  创建account账户模型
  
  :param: dict 需要转成账户模型的字典
  */
  convenience init(dict:[String: AnyObject]) {
    self.init()
    self.access_token = dict["access_token"] as? String
    self.expires_in = dict["expires_in"] as? NSNumber
    self.remind_in = dict["remind_in"] as? String
    self.uid = dict["uid"] as? String
    self.expires_time = dict["expires_time"] as? NSDate
    self.name = dict["name"] as? String
  }
  
  override init() {
    super.init()
  }
  
  /**
  从文件中解析账户的时候掉用
  */
  
  required init?(coder decoder: NSCoder) {
    super.init()
    
    self.access_token = decoder.decodeObjectForKey("access_token") as? String
    self.expires_in = decoder.decodeObjectForKey("expires_in") as? NSNumber
    self.remind_in = decoder.decodeObjectForKey("remind_in") as? String
    self.uid = decoder.decodeObjectForKey("uid") as? String
    self.expires_time = decoder.decodeObjectForKey("expires_time") as? NSDate
    self.name = decoder.decodeObjectForKey("name") as? String
  }
  
  /**
  将账户信息写入文件的时候掉用
  */
  func encodeWithCoder(enCoder: NSCoder) {
    
    enCoder.encodeObject(self.access_token, forKey: "access_token")
    enCoder.encodeObject(self.expires_in!, forKey: "expires_in")
    enCoder.encodeObject(self.uid, forKey: "uid")
    enCoder.encodeObject(self.remind_in, forKey: "remind_in")
    enCoder.encodeObject(self.expires_time, forKey: "expires_time")
    enCoder.encodeObject(self.name, forKey: "name")
    
  }
  
}


  

  
  
