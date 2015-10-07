//
//  StatusTopView.swift
//  SuWB
//
//  Created by 王文臻 on 15/9/7.
//  Copyright © 2015年 王文臻. All rights reserved.
//

import UIKit

class StatusTopView: UIImageView {
    
    
    /// 头像View
    var iconView: UIImageView?
    /// vip的图标
    var vipView: UIImageView?
    /// 照片View
    var photoView: PhotosView?
    /// 用户昵称
    var nameLabel: UILabel?
    /// 微博时间
    var timeLabel: UILabel?
    /// 微博来源
    var sourceLabel: UILabel?
    /// 微博正文
    var contentLabel: UILabel?
    
    
    ///转发的微博View
    var retweetView: StatusRetweetView!
    
    
    var statusFrame:StatusFrame? {
        didSet{
            if self.statusFrame != oldValue {
                let status = self.statusFrame?.status
                let user = status?.user
                
                self.iconView!.sd_setImageWithURL(NSURL(string: user!.profile_image_url!)!, placeholderImage: UIImage.Asset.AvatarDefaultSmall.image)
                self.iconView?.frame = statusFrame!.iconViewF!
                
                self.nameLabel?.text = user?.name
                self.nameLabel?.frame = statusFrame!.nameLabelF!
                
                
                if status?.user?.mbrank != "0" { //是会员
                    self.vipView?.hidden = false
                    self.vipView?.image = UIImage(named: "common_icon_membership_level\(status!.user!.mbrank!)")
                    self.nameLabel?.textColor = UIColor.orangeColor()
                    self.vipView?.frame = statusFrame!.vipViewF!
                }else {// 非会员
                    
                    self.vipView?.hidden = true
                    self.nameLabel?.textColor = UIColor.blackColor()
                    
                }
                
                
                self.timeLabel?.text = status?.created_at
                self.timeLabel?.frame = statusFrame!.timeLabelF!
                
                self.sourceLabel?.text = status?.source
                self.sourceLabel?.frame = statusFrame!.sourceLabelF!
                
                self.contentLabel?.text = status?.text
                self.contentLabel?.frame = statusFrame!.contentLabelF!
                
                if status?.pic_urls?.count != 0 { //有图片
                    let photos = status!.pic_urls! as! [Photo]
                    
                    self.photoView?.hidden = false
                    self.photoView?.photos = photos
//                    self.photoView?.sd_setImageWithURL(NSURL(string: photos[0].thumbnail_pic!))
                    self.photoView?.frame = statusFrame!.photoViewF!
                }else{
                    self.photoView?.hidden = true
                }
                
                //设置转发微博View的数据
                setupRetweetData()

            }
        }
    }

    
    //MARK: - 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.userInteractionEnabled = true
        
        //设置图片
        self.image = UIImage.resizableImageWithName("timeline_card_top_background")
        self.highlightedImage = UIImage.resizableImageWithName("timeline_card_top_background_highlighted")
        
        //1. 添加头像View
        let iconView = UIImageView()
        self.addSubview(iconView)
        self.iconView = iconView
        
        //3. 添加图片
        let photoView = PhotosView(frame: CGRectZero)
        self.addSubview(photoView)
        self.photoView = photoView
        
        //4. 添加昵称
        let nameLabel = UILabel()
        nameLabel.font = StatusNameFont
        self.addSubview(nameLabel)
        self.nameLabel = nameLabel
        
        //2. 添加vip图标
        let vipView = UIImageView()
        vipView.contentMode = UIViewContentMode.Center
        self.addSubview(vipView)
        self.vipView = vipView
        
        //5. 添加微博正文
        let contentLabel = UILabel()
        contentLabel.textColor = UIColor.colorWithRGB(39, g: 39, b: 39)
        contentLabel.font = StatusContentFont
        contentLabel.numberOfLines = 0
        self.addSubview(contentLabel)
        self.contentLabel = contentLabel
        
        //6. 添加发微博的时间
        let timeLabel = UILabel()
        timeLabel.textColor = UIColor.colorWithRGB(240, g: 140, b: 19)
        timeLabel.textColor = UIColor.orangeColor()
        timeLabel.font = StatusTimeFont
        self.addSubview(timeLabel)
        self.timeLabel = timeLabel
        
        //7. 添加微博来源
        let sourceLabel = UILabel()
        sourceLabel.textColor = UIColor.colorWithRGB(135, g: 135, b: 135)
        sourceLabel.font = StatusSourceFont
        self.addSubview(sourceLabel)
        self.sourceLabel = sourceLabel
        
        //添加转发微博的View到TopView上
        setupRetweetSubviews()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - retweetView的设置
    /**
    初始化转发微博的data
    */
    private func setupRetweetData() {
        let status = self.statusFrame?.status
        
        if status?.retweeted_status != nil {
            
            self.retweetView.hidden = false
            
            self.retweetView.frame = statusFrame!.retweetViewF!
            self.retweetView.statusFrame = statusFrame
            
        }else {
            self.retweetView.hidden = true
        }
    }
    
    /**
    初始化转发微博的控件
    */
    private func setupRetweetSubviews() {
        
        
        //添加转发微博View
        let retweetView = StatusRetweetView(frame: CGRectZero)
        
        self.addSubview(retweetView)
        self.retweetView = retweetView
        
    }

}
