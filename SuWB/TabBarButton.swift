//
//  TabBarButton.swift
//  SuWB
//
//  Created by 王文臻 on 15/8/23.
//  Copyright © 2015年 王文臻. All rights reserved.
//  底部栏的按钮

import UIKit

let imageRectHeightRatio:CGFloat = 0.7
class TabBarButton: UIButton {
  
   var badgeButton: BadgeButton!
  
  var item:UITabBarItem? {
    didSet{
      if self.item != nil {
        item?.addObserver(self, forKeyPath: "title", options: NSKeyValueObservingOptions.New, context: nil)
        item?.addObserver(self, forKeyPath: "image", options: NSKeyValueObservingOptions.New, context: nil)
        item?.addObserver(self, forKeyPath: "selectedImage", options: NSKeyValueObservingOptions.New, context: nil)
        item?.addObserver(self, forKeyPath: "badgeValue", options: NSKeyValueObservingOptions.New, context: nil)
      }
    }
  }

  override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
    
    let imageW:CGFloat = contentRect.size.width
    let imageH:CGFloat = contentRect.size.height * imageRectHeightRatio
    return CGRectMake(0, 0, imageW, imageH)
    
  }
  
  override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
    let titleW:CGFloat = contentRect.size.width
    let titleY:CGFloat = contentRect.size.height * imageRectHeightRatio
    let titleH:CGFloat = contentRect.size.height * CGFloat(1 - imageRectHeightRatio)
    return CGRectMake(0, titleY, titleW, titleH)
  }
  
  /// 重写高亮状态，使按下时高亮状态取消
  override var highlighted:Bool {
    didSet{
      super.highlighted = false
    }
  }
  
  override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
    //设置文字
    self.setTitle(item!.title, forState: UIControlState.Normal)
    self.setTitle(item!.title, forState: UIControlState.Selected)
    //设置图片
    self.setImage(item!.image, forState: UIControlState.Normal)
    self.setImage(item!.selectedImage, forState: UIControlState.Selected)
    //设置提醒数字
//    if badgeButton.badgeValue == nil {
      self.badgeButton.badgeValue = self.item?.badgeValue
//    }
    //设置提醒数字位置
    let badgeY:CGFloat = 5
    let badgeX:CGFloat = self.frame.size.width - self.badgeButton!.frame.size.width - 10
    var badgeF = badgeButton?.frame.origin
    badgeF?.x = badgeX
    badgeF?.y = badgeY
    self.badgeButton?.frame.origin = badgeF!
    
  }

  //MARK: - init
  override init(frame: CGRect) {
    super.init(frame: frame)
    //设置按钮图片和文字的样式位置
    self.imageView?.contentMode = UIViewContentMode.Center
    self.titleLabel?.textAlignment = NSTextAlignment.Center
    self.titleLabel?.font = UIFont.systemFontOfSize(13)
    //设置按钮文字颜色
    self.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
    self.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Selected)
    //设置按钮背景的图片
//    self.setBackgroundImage(UIImage(named: "tabbar_slider")!, forState: UIControlState.Selected)
    
    //添加提醒数字
    self.badgeButton = {
        let badgeButton = BadgeButton()
        //由于我们在badgeValue的set属性时，设置了她的位置X，但是在这时badgeButton才刚初始化完，frame还没有值，所以计算得到的X值会出差错，设置为负数，所以我们使用了autoresuzubgmask方法来约束badgeButton的位置
        badgeButton.autoresizingMask = [.FlexibleBottomMargin, .FlexibleLeftMargin]
        //    badgeButton.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin
        self.addSubview(badgeButton)
        return badgeButton
    }()
    
  }
  

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    self.item?.removeObserver(self, forKeyPath: "title")
    self.item?.removeObserver(self, forKeyPath: "image")
    self.item?.removeObserver(self, forKeyPath: "selectedImage")
    self.item?.removeObserver(self, forKeyPath: "badgeValue")
    
  }
  
}
