//
//  AccountParam.swift
//  SuWB
//
//  Created by 王文臻 on 15/9/29.
//  Copyright © 2015年 王文臻. All rights reserved.
//

import UIKit

class AccountParam: NSObject {
    
    var client_id: String! = AppKey
    var client_secret: String! = AppSecret
    var grant_type: String! = "authorization_code"
    var redirect_uri: String! = RedirectURL
    
    var code:String?
}
