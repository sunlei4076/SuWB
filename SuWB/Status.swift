//
//  Status.swift
//  SuWB
//
//  Created by 王文臻 on 15/9/1.
//  Copyright © 2015年 王文臻. All rights reserved.
//

import UIKit

class Status: NSObject {
    
    /// 创建微博时间
    var created_at:String? {
        didSet{
            if self.created_at != oldValue {
                // _created_at == Fri May 09 16:30:34 +0800 2014
                let fmt = NSDateFormatter()
                
                fmt.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
                fmt.locale = NSLocale(localeIdentifier: "en_US")
                
                let createdDate = fmt.dateFromString(self.created_at!) //真机中这句话会崩溃需要设置local 代码如上
                
                if createdDate!.isToday() { //如果是今天
                    
                    if createdDate!.deltaWithNow().hour >= 1 {
                        created_at = "\(createdDate!.deltaWithNow().hour)小时以前"
                    }else if createdDate!.deltaWithNow().minute >= 1 {
                        created_at = "\(createdDate!.deltaWithNow().minute)分钟以前"
                    } else{
                        created_at = "刚刚"
                    }
                }else if createdDate!.isYesterday() {//昨天
                    
                    fmt.dateFormat = "昨天 HH:mm"
                    created_at = fmt.stringFromDate(createdDate!)
                }else if createdDate!.isThisYear() {//今年
                    fmt.dateFormat = "MM-dd HH:mm"
                    created_at = fmt.stringFromDate(createdDate!)
                }else {//非今年
                    fmt.dateFormat = "yyyy-MM-dd HH:mm"
                    created_at = fmt.stringFromDate(createdDate!)
                }

            }
        }
        
        
    }
    
    //"<a href=\"http://weibo.com/\" rel=\"nofollow\">微博 weibo.com</a>"
    /// 微博的来源
    var source:String? {
        didSet{
            if self.source != oldValue {
                if source != nil && source != "" { //如果昵称不为nil
                    let range = self.source?.rangeOfString(">")
                    let lastRange = self.source?.rangeOfString("</")
                    let newStr = self.source?.substringWithRange(Range(start: range!.endIndex, end: lastRange!.first!))
                    self.source = "来自 \(newStr!)"
                }
        }
        
      }
    }
    
    /// 微博ID
    var idstr:String?
    /// 微博内容
    var text:String?
    /// 微博转发数
    var reposts_count:String?
    /// 微博评论数
    var comments_count:String?
    /// 微博的点赞数
    var attitudes_count:String?
    
    
    /// 发微博的用户
    var user:User?
    /// 照片地址
    var thumbnail_pic:String?
    /// 照片的地址合集（数组）
    var pic_urls: NSArray?
    /// 被转发的微博
    var retweeted_status:Status?
    
    //提醒转化为模型时数组中的模型类型
    override static func objectClassInArray() -> [NSObject : AnyObject]! {
        return ["pic_urls": Photo.classForCoder()]
    }
    

}

//extension Status: CustomDebugStringConvertible {
//    override var description: String {
//        return "照片地址\(self.pic_urls)"
//    }
//}
