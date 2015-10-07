//
//  StatusResult.swift
//  SuWB
//
//  Created by 王文臻 on 15/9/29.
//  Copyright © 2015年 王文臻. All rights reserved.
//

import UIKit

class StatusResult: NSObject {

 /// 加载到的所有微博
    var statuses: [Status]?

    var previous_cursor: String?
    var next_cursor: String?
 /// 微博总数
    var total_number: String?
    
    /**
    将微博模型装进数组
    */
    override static func objectClassInArray() -> [NSObject : AnyObject]! {
        return ["statuses": Status.classForCoder()]
    }
    
}
