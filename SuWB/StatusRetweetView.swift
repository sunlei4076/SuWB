//
//  StatusRetweetView.swift
//  SuWB
//
//  Created by 王文臻 on 15/9/6.
//  Copyright © 2015年 王文臻. All rights reserved.
//

import UIKit

class StatusRetweetView: UIImageView {
    
    /// 被转发微博的用户昵称
    var retweetNameLabel: UILabel?
    /// 被转发微博的正文
    var retweetContentLabel: UILabel?
    /// 被转发微博的照片
    var retweetPhotoView: PhotosView?
    
    var statusFrame:StatusFrame? {
        didSet{
            if self.statusFrame != oldValue {
                let status = self.statusFrame?.status
                
                self.retweetNameLabel?.text = "@\(status!.retweeted_status!.user!.name!)"
                self.retweetNameLabel?.frame = statusFrame!.retweetNameLabelF!
                
                self.retweetContentLabel?.text = status?.retweeted_status?.text
                self.retweetContentLabel?.frame = statusFrame!.retweetContentLabelF!
                
                if status?.retweeted_status?.pic_urls?.count != 0 { // 如果有转发的照片
                    let photos = status!.retweeted_status!.pic_urls! as! [Photo]
                    //有转发的照片
                    self.retweetPhotoView?.hidden = false
                    self.retweetPhotoView?.frame = statusFrame!.retweetPhotoViewF!
                    self.retweetPhotoView?.photos = photos
//                    self.retweetPhotoView?.sd_setImageWithURL(NSURL(string: photos[0].thumbnail_pic!))
                }else{ //没有转发的照片
                    self.retweetPhotoView?.hidden = true
                }
                
            }
        }
    }
    
    //MARK: - 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.userInteractionEnabled = true
        
        self.image = UIImage.resizableImageWithName("timeline_retweet_background", left: 0.9, top: 0.5)
        
        //1. 添加被转发微博用户的昵称
        self.retweetNameLabel = {
            let retweetNameLabel = UILabel()
            retweetNameLabel.textColor = UIColor.purpleColor()
            self.addSubview(retweetNameLabel)
            return retweetNameLabel
        }()
        
        //2. 添加被转发微博的照片
        self.retweetPhotoView = {
            let retweetPhotoView = PhotosView(frame: CGRectZero)
            self.addSubview(retweetPhotoView)
            return retweetPhotoView
        }()
        
        //3. 添加被转发微博的正文
        self.retweetContentLabel = {
            let retweetContentLabel = UILabel()
            retweetContentLabel.textColor = UIColor.colorWithRGB(90, g: 90, b: 90)
            retweetContentLabel.font = StatusContentFont
            retweetContentLabel.numberOfLines = 0
            self.addSubview(retweetContentLabel)
            return retweetContentLabel
        }()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
