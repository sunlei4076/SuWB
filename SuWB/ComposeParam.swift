//
//  ComposeParam.swift
//  SuWB
//
//  Created by 王文臻 on 15/9/29.
//  Copyright © 2015年 王文臻. All rights reserved.
// 发微博的参数

import UIKit

class ComposeParam: BaseParam {

 /// 微博内容（正文）
    var status: String?
 /// 上传的文件
    var datas:[FormData]?
    
    override static func objectClassInArray() -> [NSObject : AnyObject]! {
        return ["datas": FormData.classForCoder()]
    }
}
