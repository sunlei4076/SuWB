//
//  User.swift
//  SuWB
//
//  Created by 王文臻 on 15/9/1.
//  Copyright © 2015年 王文臻. All rights reserved.
//

import UIKit

class User: NSObject {
    /**
    following	boolean	暂未支持
    allow_all_act_msg	boolean	是否允许所有人给我发私信，true：是，false：否
    geo_enabled	boolean	是否允许标识用户的地理位置，true：是，false：否
    verified	boolean	是否是微博认证用户，即加V用户，true：是，false：否
    verified_type	int	暂未支持
    remark	string	用户备注信息，只有在查询用户关系时才返回此字段
    status	object	用户的最近一条微博信息字段 详细
    allow_all_comment	boolean	是否允许所有人对我的微博进行评论，true：是，false：否
    avatar_large	string	用户头像地址（大图），180×180像素
    avatar_hd	string	用户头像地址（高清），高清头像原图
    verified_reason	string	认证原因
    follow_me	boolean	该用户是否关注当前登录用户，true：是，false：否
    online_status	int	用户的在线状态，0：不在线、1：在线
    bi_followers_count	int	用户的互粉数
    lang	string	用户当前的语言版本，zh-cn：简体中文，zh-tw：繁体中文，en：英语
    
    */
    
 /// 用户UID
    var id: Int?
 /// 字符串型的用户UID
    var idstr:String?
 /// 用户的昵称
    var name:String?
 /// 用户头像地址（中图），50×50像素
    var profile_image_url:String?
 /// 会员等级
    var mbrank:String?
 /// 用户昵称
    var screen_name:String?
 /// 用户所在省级ID
    var province: Int?
 /// 用户所在城市ID
    var city: Int?
 /// 用户所在地
    var location: String?
 /// 用户个人描述
    var descriptionStr: String?
 /// 用户博客地址
    var url: String?
 /// 用户的微博统一URL地址
    var profile_url: String?
 /// 用户的个性化域名
    var domain: String?
 /// 用户的微号
    var weihao: String?
 /// 性别，m：男、f：女、n：未知
    var gender: String?
 /// 粉丝数
    var followers_count: Int?
 /// 关注数
    var friends_count: Int?
 /// 收藏数
    var favourites_count: Int?
 /// 微博数
    var statuses_count: Int?
 /// 用户创建（注册）时间
    var created_at: String?
    
}

/**

*/
