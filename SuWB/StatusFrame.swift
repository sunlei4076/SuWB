//
//  StatusFrame.swift
//  SuWB
//
//  Created by 王文臻 on 15/9/4.
//  Copyright © 2015年 王文臻. All rights reserved.
//

import UIKit

let StatusCellBorder:CGFloat = 10
let StatusNameFont:UIFont = UIFont.systemFontOfSize(17)
let StatusTimeFont:UIFont = UIFont.systemFontOfSize(12)
let StatusSourceFont:UIFont = StatusTimeFont
let StatusContentFont:UIFont = UIFont.systemFontOfSize(18)

class StatusFrame: NSObject {
    
    /// 顶部View
    var topViewF:CGRect!
    /// 头像View
    var iconViewF:CGRect?
    /// vip的图标
    var vipViewF:CGRect?
    /// 照片View
    var photoViewF:CGRect?
    /// 用户昵称
    var nameLabelF:CGRect?
    /// 微博时间
    var timeLabelF:CGRect?
    /// 微博来源
    var sourceLabelF:CGRect?
    /// 微博正文
    var contentLabelF:CGRect?
    
    ///转发的微博View
    var retweetViewF:CGRect?
    /// 被转发微博的用户昵称
    var retweetNameLabelF:CGRect?
    /// 被转发微博的正文
    var retweetContentLabelF:CGRect?
    /// 被转发微博的照片
    var retweetPhotoViewF:CGRect?
    
    ///微博的工具条
    var statusToolbarF:CGRect! 
    
    /// cell的高度
    var cellHeight:CGFloat!
    
    
    //微博用户数据
    var status: Status?  {
        didSet{
            if self.status != oldValue {
                let cellW:CGFloat = UIScreen.mainScreen().bounds.size.width
                
                let topX:CGFloat = 0
                let topY:CGFloat = 0
                var topH:CGFloat = 0
                let topW:CGFloat = cellW - 2 * StatusCellBorder
                //1.头像尺寸
                let iconXY:CGFloat = StatusCellBorder
                let iconWH:CGFloat = 35
                self.iconViewF = CGRectMake(iconXY, iconXY, iconWH, iconWH)
                //2.昵称位置
                let nameX:CGFloat = CGRectGetMaxX(iconViewF!) + StatusCellBorder
                let nameY:CGFloat = iconXY
                let nameW:CGFloat = status!.user!.name!.size(font: StatusNameFont).width
                let nameH:CGFloat = status!.user!.name!.size(font: StatusNameFont).height
                self.nameLabelF = CGRectMake(nameX, nameY, nameW, nameH)
                //3.如果是会员的话
                if status!.user!.mbrank != "0" {
                    
                    let vipX:CGFloat = CGRectGetMaxX(nameLabelF!) + StatusCellBorder
                    let vipY:CGFloat = nameY
                    let vipW:CGFloat = 14
                    let vipH:CGFloat = nameH
                    self.vipViewF = CGRectMake(vipX, vipY, vipW, vipH)
                }
                //4.设置time
                let timeX:CGFloat = nameX
                let timeY:CGFloat = CGRectGetMaxY(nameLabelF!) + StatusCellBorder/2
                let timeSize:CGSize = status!.created_at!.size(font: StatusTimeFont)
                let timeW:CGFloat = timeSize.width
                let timeH:CGFloat = timeSize.height
                self.timeLabelF = CGRectMake(timeX, timeY, timeW, timeH)
                //5.设置微博来源
                let sourceX:CGFloat = CGRectGetMaxX(timeLabelF!) + StatusCellBorder
                let sourceY:CGFloat = timeY
                let sourceW:CGFloat = status!.source!.size(font: StatusSourceFont).width
                let sourceH:CGFloat = timeH
                self.sourceLabelF = CGRectMake(sourceX, sourceY, sourceW, sourceH)
                //6.微博正文
                let contentX:CGFloat = iconXY + StatusCellBorder / 2
                let contentY:CGFloat = CGRectGetMaxY(iconViewF!) > CGRectGetMaxY(timeLabelF!) ? CGRectGetMaxY(iconViewF!) + StatusCellBorder : CGRectGetMaxY(timeLabelF!) + StatusCellBorder
                let contentW:CGFloat = topW - 2 * StatusCellBorder
                let contentH:CGFloat = status!.text!.size(box: CGSizeMake(contentW, CGFloat(MAXFLOAT)), font: StatusContentFont).height
                self.contentLabelF = CGRectMake(contentX, contentY, contentW, contentH)
                
                
                //7.如果有微博照片
                if status?.pic_urls?.count != 0 && status?.pic_urls != nil {
                    guard let size = PhotosView.sizeWithImageCount(status?.pic_urls?.count) else {
                        return
                    }
                    let photoX:CGFloat = contentX
                    let photoY:CGFloat = CGRectGetMaxY(contentLabelF!) + StatusCellBorder
//                    let photoWH:CGFloat = 70
                    self.photoViewF = CGRectMake(photoX, photoY, size.width, size.height)
                    
                }
                
                //8.如果有转发微博
                if status?.retweeted_status != nil {
                    //转发微博
                    let retweetViewX:CGFloat = contentX - StatusCellBorder/2
                    let retweetViewY:CGFloat = CGRectGetMaxY(contentLabelF!) + StatusCellBorder / 2
                    let retweetViewW:CGFloat = contentW
                    var retweetViewH:CGFloat = 0
                    //9.昵称
                    let retweetNameX:CGFloat = StatusCellBorder/2
                    let retweetNameY:CGFloat = StatusCellBorder + 5
                    let retweetNameW:CGFloat = "@\(status!.retweeted_status!.user!.name!)".size(font: StatusNameFont).width
                    let retweetNameH:CGFloat = status!.retweeted_status!.user!.name!.size(font: StatusNameFont).height
                    self.retweetNameLabelF = CGRectMake(retweetNameX, retweetNameY, retweetNameW, retweetNameH)
                    //10.转发微博正文
                    let retweetContentX:CGFloat = retweetNameX
                    let retweetContentY:CGFloat = CGRectGetMaxY(retweetNameLabelF!) + StatusCellBorder / 2
                    let retweetContentW:CGFloat = contentW - StatusCellBorder
                    let retweetContentH:CGFloat = status!.retweeted_status!.text!.size(box: CGSizeMake(contentW, CGFloat(MAXFLOAT)), font: StatusContentFont).height
                    self.retweetContentLabelF = CGRectMake(retweetContentX, retweetContentY, retweetContentW, retweetContentH)
                    
                    retweetViewH = CGRectGetMaxY(retweetContentLabelF!) + StatusCellBorder
                    
                    
                    //11.如果转发微博有照片
                    if status?.retweeted_status?.pic_urls?.count != 0 {
                        var size:CGSize = CGSizeZero
                        if status?.retweeted_status?.pic_urls?.count != nil {
                            size = PhotosView.sizeWithImageCount(status?.retweeted_status?.pic_urls?.count)!
                        }
                        let retweetPhotoX:CGFloat = retweetContentX
                        let retweetPhotoY:CGFloat = CGRectGetMaxY(retweetContentLabelF!) + StatusCellBorder
//                        let retweetPhotoW:CGFloat = 70
//                        let retweetPhotoH:CGFloat = 70
                        self.retweetPhotoViewF = CGRectMake(retweetPhotoX, retweetPhotoY, size.width, size.height)
                        
                        retweetViewH = CGRectGetMaxY(retweetPhotoViewF!) + StatusCellBorder
                        
                    }
                    
                    self.retweetViewF = CGRectMake(retweetViewX, retweetViewY, retweetViewW, retweetViewH)
                    //如果有转发微博
                    topH += CGRectGetMaxY(retweetViewF!) + StatusCellBorder
                } else{
                    //没有转发的微博
                    if photoViewF != nil {
                        //有照片
                        topH = CGRectGetMaxY(photoViewF!) + StatusCellBorder
                    }else{
                        //没有照片
                        topH = CGRectGetMaxY(contentLabelF!) + StatusCellBorder
                    }
                }
                topViewF = CGRectMake(topX, topY, topW, topH)
                
                //设置工具条
                let toolbarX:CGFloat = 0
                let toolbarY:CGFloat = CGRectGetMaxY(topViewF)
                let toolbarW:CGFloat = topW
                let toolbarH:CGFloat = 40
                self.statusToolbarF = CGRectMake(toolbarX, toolbarY, toolbarW, toolbarH)
                
                cellHeight = CGRectGetMaxY(statusToolbarF!) + StatusCellBorder
                
            }
        }
    }
    
    
}
