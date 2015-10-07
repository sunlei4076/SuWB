//
//  StatusTool.swift
//  SuWB
//
//  Created by 王文臻 on 15/9/29.
//  Copyright © 2015年 王文臻. All rights reserved.
//

import UIKit

class StatusTool: NSObject {
    
    
    /**
    首页加载网络请求
    
    - parameter param:   请求参数
    - parameter success: 请求成功时回调
    - parameter failure: 请求失败时回调
    */
    class func homeStatusWithParam(param:StatusParam, success:(result:StatusResult)->(), failure:(error:NSError)->()) {
        //封装参数
        guard let paramsDict = (param.keyValues() as NSDictionary) as? [String:String] else {
            print("上传参数出错")
            return
        }
        //分装返回结果
        
        HttpTool.getWithURL("https://api.weibo.com/2/statuses/home_timeline.json", params: paramsDict, success: { (json) -> () in
            guard let result = StatusResult(keyValues: json) else {
                print("没有返回结果")
                return
            }
            success(result: result)
            }) { (error) -> () in
                failure(error: error)
        }
    }

}



