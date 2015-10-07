//
//  BadgeButton.swift
//  SuWB
//
//  Created by 王文臻 on 15/8/24.
//  Copyright © 2015年 王文臻. All rights reserved.
//  提示数字的按钮

import UIKit

class BadgeButton: UIButton {

  /// tabbar按钮的提醒消息
  var badgeValue:String?  = "0" {
    didSet{
      if self.badgeValue != "0"{
        
        self.hidden = false
        self.setTitle(badgeValue, forState: UIControlState.Normal)
        var frame = self.frame
        var badgeW:CGFloat = (self.currentBackgroundImage?.size.width)!
        let badgeH:CGFloat = (self.currentBackgroundImage?.size.height)!
        if badgeValue?.characters.count > 1 {
          let badgeSize = (badgeValue! as NSString).boundingRectWithSize(CGSizeMake(CGFloat(MAXFLOAT), CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: self.titleLabel!.font], context: nil)
          badgeW = badgeSize.size.width + 10
        }
        frame.size.height = badgeH
        frame.size.width  = badgeW
        
        self.frame = frame
        
      }else if self.badgeValue == "0" || self.badgeValue == nil {
        self.hidden = true
      }
    }
  }
  
  //MARK: - init
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    //设置提醒按钮的样式，字体，背景图片
    self.hidden = true
    self.userInteractionEnabled = false
    let newBackageImage = UIImage.resizableImageWithName("main_badge_os7")
    self.setBackgroundImage(newBackageImage, forState: UIControlState.Normal)
    self.titleLabel?.font = UIFont.systemFontOfSize(11)
    
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

  

}
