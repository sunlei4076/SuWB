//
//  TitleButton.swift
//  SuWB
//
//  Created by 王文臻 on 15/8/30.
//  Copyright © 2015年 王文臻. All rights reserved.
//

import UIKit
import FontBlaster

class TitleButton: UIButton {
    
    let titleButtonImageW:CGFloat = 20
    let titleButtonImageH:CGFloat = 40
    let titleButtonTitleLeftMargin:CGFloat = 5
    let titleFont:UIFont = UIFont(name: "OpenSans", size: 20)!
    
    private var title: String?
    
  
  /**
  子类空间frame变化以后掉用
  */
  override func layoutSubviews() {
    super.layoutSubviews()
//    self.setTitle(title, forState: UIControlState.Normal)
//    let titleBtnW:CGFloat = title!.size(font: titleFont).width
//    self.bounds = CGRectMake(0, 0, titleBtnW + titleButtonImageW + titleButtonTitleLeftMargin, titleButtonImageH)
    self.imageView?.contentMode = UIViewContentMode.Center
  }
  
  //MARK: - init
  convenience init(title: String) {
    self.init()
    self.title = title
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    //关闭高亮调整图像功能
    self.adjustsImageWhenHighlighted = false
    self.titleLabel?.font = titleFont
    
    self.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
    self.setBackgroundImage(UIImage.resizableImageWithName("navigationbar_filter_background_highlighted_os7"), forState: UIControlState.Highlighted)
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
    
    override func setTitle(title: String?, forState state: UIControlState) {
        guard let title = title else{ return }
        
        var frame = self.frame
        frame.size.width = title.size(font: titleFont).width + titleButtonImageW + titleButtonTitleLeftMargin
        self.frame = frame
        
        super.setTitle(title, forState: state)
    }
  
 
    /**
    调整button中内部空间imageView的位置
    
    - parameter contentRect: button的尺寸rect
    
    - returns: imageView在button的位置
    */
  override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
    super.imageRectForContentRect(contentRect)
    let imageW:CGFloat = titleButtonImageW
    let imageX:CGFloat = contentRect.size.width - imageW
    let imageY:CGFloat = 0
    let imageH:CGFloat = contentRect.size.height
    
    return CGRectMake(imageX, imageY, imageW, imageH)
  }
  
    /**
    调整button中内部空间title的位置
    
    - parameter contentRect: button的尺寸rect
    
    - returns: title在button的位置
    */
  override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
    super.titleRectForContentRect(contentRect)
    let titleX:CGFloat = titleButtonTitleLeftMargin
    let titleY:CGFloat = 0
    let titleW:CGFloat = contentRect.size.width - titleButtonImageW - titleButtonTitleLeftMargin
    let titleH:CGFloat = contentRect.size.height
    return CGRectMake(titleX, titleY, titleW, titleH)
  }
  
  

}
