//
//  UnreadCountResult.swift
//  SuWB
//
//  Created by 王文臻 on 15/10/1.
//  Copyright © 2015年 王文臻. All rights reserved.
//

import UIKit

class UnreadCountResult: NSObject {
    
    /// 新微博未读数
    var status: String!
    /// 新粉丝
    var follower: String!
    /// 新评论
    var cmt: String!
    /// 新私信
    var dm: String!
    /// 新提及我的评论数
    var mention_cmt: String!
    /// 新提及我的微博数
    var mention_status: String!
    /// 消息的总数
    var messageCount: String! {
        return "\(Int(cmt)! + Int(mention_status)! + Int(mention_cmt)!)"
    }
    /// 总数
    var count: String! {
        return "\(Int(messageCount)! + Int(status)! + Int(follower)!)"
    }
    

}

extension UnreadCountResult: CustomDebugStringConvertible {
    override var description: String {
        return "status:\(status),follower:\(follower),messageCount:\(messageCount),count:\(count)"
    }
}