//
//  StatusToolbarView.swift
//  SuWB
//
//  Created by 王文臻 on 15/9/6.
//  Copyright © 2015年 王文臻. All rights reserved.
// 微博工具条View

import UIKit

class StatusToolbarView: UIImageView {
    
    lazy var buttons = [UIButton]()
    lazy var dividers = [UIImageView]()
    private var retweetBtn = UIButton()
    private var commentBtn = UIButton()
    private var attitudeBtn = UIButton()
    
    var status:Status? {
        didSet{
            if self.status != oldValue {
                //设置相应的count
                self.setupStatusCountWithBtn(retweetBtn, originalTitle: "转发", count: status!.reposts_count!)
                self.setupStatusCountWithBtn(commentBtn, originalTitle: "评论", count: status!.comments_count!)
                self.setupStatusCountWithBtn(attitudeBtn, originalTitle: "赞", count: status!.attitudes_count!)
            }
        }
    }

    
    //MARK: - 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.userInteractionEnabled = true
        //设置照片
        self.image = UIImage.resizableImageWithName("timeline_card_bottom_background")
        self.highlightedImage = UIImage.resizableImageWithName("timeline_card_bottom_background_highlighted")
        
        //1.添加按钮
        self.retweetBtn = setupBtn("转发", image: "timeline_icon_retweet", bgImage: "timeline_card_leftbottom_highlighted")
        self.commentBtn = setupBtn("评论", image: "timeline_icon_comment", bgImage: "timeline_card_middlebottom_highlighted")
        self.attitudeBtn = setupBtn("赞", image: "timeline_icon_unlike", bgImage: "timeline_card_rightbottom_highlighted")
        
        //2.添加divider分割线
        self.setupDivider()
        self.setupDivider()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - 初始化控件subViews
    /**
    添加按钮
    
    :param: title   按钮原来的名字
    :param: image   按钮的图片
    :param: bgImage 按钮的高亮图片
    */
    private func setupBtn(title: String, image: String, bgImage: String) -> UIButton {
        let btn = UIButton()
        //取消高亮是自动切换默认的图片
        btn.adjustsImageWhenHighlighted = false
        btn.setImage(UIImage(named: image)!, forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: bgImage)!, forState: UIControlState.Highlighted)
        btn.setTitle(title, forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5)
        btn.titleLabel?.font = UIFont.systemFontOfSize(13)
        self.addSubview(btn)
        self.buttons.append(btn)
        return btn
    }
    
    /**
    初始化divider分割线
    */
    private func setupDivider() {
        let imageView = UIImageView()
        imageView.image = UIImage.Asset.TimelineCardBottomLineOs7.image
        self.addSubview(imageView)
        self.dividers.append(imageView)
    }
    
    /**
    设置子控件的frame
    */
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let dividerW:CGFloat = 2
        //buttonFrame
        let buttonY:CGFloat = 0
        let buttonW:CGFloat = (self.frame.size.width - dividerW * 2) / CGFloat(buttons.count)
        let buttonH:CGFloat = self.frame.size.height
        
        for index in 0..<buttons.count {
            let button = buttons[index]
            let buttonX:CGFloat = (buttonW + dividerW) * CGFloat(index)
            button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH)
        }
        //dividerFrame
        let dividerH:CGFloat = self.frame.size.height
        let dividerY:CGFloat = 0
        for index in 0..<dividers.count {
            let divider = dividers[index]
            let button = buttons[index]
            let dividerX:CGFloat = CGRectGetMaxX(button.frame)
            divider.frame = CGRectMake(dividerX, dividerY, dividerW, dividerH)
        }
        
    }
    
    /**
    设置按钮的正确数据
    
    :param: button        需要设置数据的按钮
    :param: originalTitle 原先的标题
    :param: count         正确真实的count
    */
    private func setupStatusCountWithBtn(button: UIButton, originalTitle: String, count: String) {
        let count:Int = Int(count)!
        
        if count == 0 {
            button.setTitle(originalTitle, forState: UIControlState.Normal)
        }else if count < 10000 { //数据<1W
            button.setTitle("\(count)", forState: UIControlState.Normal)
        }else{ // >1W
            let double:Double = Double(count) / 10000
            let double1 = NSString(format: "%.1f", double)
            let str = double1.stringByReplacingOccurrencesOfString(".0", withString: "")
            button.setTitle("\(str)万", forState: UIControlState.Normal)
        }
        
    }

}
