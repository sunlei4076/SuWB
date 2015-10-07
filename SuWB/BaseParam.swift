//
//  BaseParam.swift
//  SuWB
//
//  Created by 王文臻 on 15/9/29.
//  Copyright © 2015年 王文臻. All rights reserved.
// 上传的基本参数

import UIKit

class BaseParam: NSObject {
    
 /// 采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
    var access_token: String! {
        guard let token = AccountTool.account()?.access_token else{
            print("access_token过期了")
            return nil
        }
        return token
    }

}
