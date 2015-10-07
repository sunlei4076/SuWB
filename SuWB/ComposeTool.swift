//
//  ComposeTool.swift
//  SuWB
//
//  Created by 王文臻 on 15/9/29.
//  Copyright © 2015年 王文臻. All rights reserved.
// 发微博的工具类

import UIKit

class ComposeTool: NSObject {

    /**
    发送微博
    
    - parameter param:   请求的参数
    - parameter success: 请求成功时调用
    - parameter failure: 请求失败时调用
    */
    class func sendStatusWithParam(param: ComposeParam, success: (result: ComposeResult)->(), failure:(error: NSError)->()) {
        guard var paramDict = (param.keyValues() as NSDictionary) as? [String: AnyObject] else {
            print("发送微博的请求参数，模型转字典失败")
            return
        }
        //如果有照片的话将这个删去，在下面直接食用。datas
        paramDict.removeValueForKey("datas")
        if param.datas != nil {
            HttpTool.postWithURL("https://upload.api.weibo.com/2/statuses/upload.json", params: paramDict as! [String:String], formDataArray: param.datas!, success: { (json) -> () in
                success(result: ComposeResult(keyValues: json))
                }) { (error) -> () in
                    failure(error: error)
            }
        }else{
            HttpTool.postWithURL("https://api.weibo.com/2/statuses/update.json", params: paramDict as! [String:String], success: { (json) -> () in
                success(result: ComposeResult(keyValues: json))
                }) { (error) -> () in
                    failure(error: error)
            }
        }
        //如果发有照片的微博
//        if let paramDatas = paramDict.removeValueForKey("datas") as? [FormData] {
//            HttpTool.postWithURL("https://upload.api.weibo.com/2/statuses/upload.json", params: paramDict as! [String:String], formDataArray: paramDatas, success: { (json) -> () in
//                success(result: ComposeResult(keyValues: json))
//                print(paramDict.count)
//                print(paramDatas.count)
//                }) { (error) -> () in
//                    failure(error: error)
//            }
//        }else { //发送文字微博
//                HttpTool.postWithURL("https://api.weibo.com/2/statuses/update.json", params: paramDict as! [String:String], success: { (json) -> () in
//                    success(result: ComposeResult(keyValues: json))
//                    }) { (error) -> () in
//                        failure(error: error)
//                }
//            }
        
       
    }
    
}
