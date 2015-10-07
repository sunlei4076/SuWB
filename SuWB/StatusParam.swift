//
//  StatusParam.swift
//  SuWB
//
//  Created by 王文臻 on 15/9/29.
//  Copyright © 2015年 王文臻. All rights reserved.
//

import UIKit

class StatusParam: BaseParam {

 /// 采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
    var source: String?
 /// 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
    var since_id: String?
 /// 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
    var max_id: String?
 /// 单页返回的记录条数，最大不超过100，默认为20。
    var count: String?
 /// 返回结果的页码，默认为1。
    var page: String?
 /// 是否只获取当前应用的数据。0为否（所有数据），1为是（仅当前应用），默认为0。
    var base_app: String?
 /// 过滤类型ID，0：全部、1：原创、2：图片、3：视频、4：音乐，默认为0。
    var feature: String?
 /// 返回值中user字段开关，0：返回完整user字段、1：user字段仅返回user_id，默认为0。
    var trim_user: String?
    
}
