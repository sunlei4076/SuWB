//
//  HttpTool.swift
//  SuWB
//
//  Created by 王文臻 on 15/9/28.
//  Copyright © 2015年 王文臻. All rights reserved.
//

import UIKit

class FormData: NSObject {
    
    /// 需要上传的文件
    var data:NSData?
    /// 上传文件的参数名
    var name:String?
    /// 上传文件的名字
    var fileName:String?
    /// 文件类型
    var mimeType:String?
    
    init(data:NSData,name:String,fileName:String,mimeType:String) {
        self.data = data
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
    }
    
}

class HttpTool: NSObject {
    
    /**
    发送一个POST请求
    
    - parameter url:     请求路径
    - parameter params:  请求参数
    - parameter success: 请求成功后的回调
    - parameter failure: 请求失败后的回调
    */
    class func postWithURL(url:String,params:[String:String],success:(AnyObject)->(),failure:(NSError)->()) {
        
        let manager = AFHTTPRequestOperationManager()
        
        //返回的数据类型设置
        manager.responseSerializer = AFJSONResponseSerializer(readingOptions: NSJSONReadingOptions.MutableContainers)
        
        //提交POST请求获取证书
        manager.POST(url, parameters: params, success: { (operation: AFHTTPRequestOperation, responseObj) -> Void in
            //将字典转成模型
            success(responseObj)
            }) { (operation: AFHTTPRequestOperation, error: NSError) -> Void in
                failure(error)
        }

    }
    
    
    /**
    发送POST请求
    
    - parameter url:           请求路径
    - parameter params:        请求参数
    - parameter formDataArray: 发送携带的数据
    - parameter success:       发送成功时回调的闭包
    - parameter failure:       发送失败时回调的闭包
    */
    class func postWithURL(url:String,params:[String:String],formDataArray:[FormData], success:(AnyObject)->(),failure:(NSError)->()) {
        
        let manager = AFHTTPRequestOperationManager()
        
        //返回的数据类型设置
        manager.responseSerializer = AFJSONResponseSerializer(readingOptions: NSJSONReadingOptions.MutableContainers)
        
        //提交POST请求获取证书
        manager.POST(url, parameters: params, constructingBodyWithBlock: { (totalFormData: AFMultipartFormData) -> Void in
            for formData in formDataArray {
                totalFormData.appendPartWithFileData(formData.data!, name: formData.name!, fileName: formData.fileName!, mimeType: formData.mimeType!)
            }
            }, success: { (operation: AFHTTPRequestOperation, responseObj) -> Void in
                success(responseObj)
            }) { (operation: AFHTTPRequestOperation, error: NSError) -> Void in
                failure(error)
        }
        
    }
    
    /**
    发送一个GET请求
    
    - parameter url:     请求路径
    - parameter params:  请求参数
    - parameter success: 请求成功后的回调
    - parameter failure: 请求失败后的回调
    */
    class func getWithURL(url:String,params:[String:String],success:(AnyObject)->(),failure:(NSError)->()) {
        
        let manager = AFHTTPRequestOperationManager()
        
        //返回的数据类型设置
        manager.responseSerializer = AFJSONResponseSerializer(readingOptions: NSJSONReadingOptions.MutableContainers)
        
        //提交POST请求获取证书
        manager.GET(url, parameters: params, success: { (operation: AFHTTPRequestOperation, responseObj) -> Void in
            //将字典转成模型
            success(responseObj)
            }) { (operation: AFHTTPRequestOperation, error: NSError) -> Void in
                failure(error)
        }
        
    }

}
