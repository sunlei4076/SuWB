//
//  CustomTabBar.swift
//  SuWB
//
//  Created by 王文臻 on 15/8/23.
//  Copyright © 2015年 王文臻. All rights reserved.
//  自定义底部的栏

import UIKit

@objc protocol  CustomTarBarDelegate {
    optional func tabBar(tabBar:CustomTabBar,didSelectedButtonFrom:Int,to:Int)
    optional func tabBar(tabBar:CustomTabBar,didClickedAddButton:UIButton)
}

class CustomTabBar: UIView {
  
  weak var delegate:CustomTarBarDelegate?
  /// 当前选中的按钮
  var selectedButton:TabBarButton! = TabBarButton()
  /// 加号按钮
  var addButton:UIButton!
  /// tabBar上的四个按钮
  lazy var tabBarButtons: [TabBarButton] = [TabBarButton]()
  
  /**
  给自定义tabbar添加按钮item
  
  :param: item 按钮的模型
  */
  func addTabBarButtonWithItem(item:UITabBarItem) {
    
    //创建按钮
    let button = TabBarButton()
    self.addSubview(button)
    self.tabBarButtons.append(button)
    
    //设置按钮数据
    button.item = item
    
    //监听按钮时间
    button.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchDown)
    
    //默认选中第一个按钮
    if self.tabBarButtons.count == 1 {
        buttonClicked(button)
    }
    
  }
  
  /**
  按钮点击
  */
  func buttonClicked(button:TabBarButton) {

    delegate?.tabBar?(self, didSelectedButtonFrom: selectedButton.tag, to: button.tag)
    
    selectedButton.selected = false
    button.selected = true
    selectedButton  = button
  }
    
    /**
    加号按钮的点击监听
    
    - parameter button: 按钮
    */
    func addButtonClicked(button: UIButton) {
        delegate?.tabBar?(self, didClickedAddButton: button)
    }
  
  override func layoutSubviews() {
    
    addButton.center = CGPointMake(self.center.x, self.center.y)
    addButton.bounds = CGRectMake(0, 0, self.addButton.currentBackgroundImage!.size.width, self.addButton.currentBackgroundImage!.size.height)
    
    //设置tabbar上button的frane
    let buttonY:CGFloat = 0
    let buttonH:CGFloat = self.frame.size.height
    let buttonW:CGFloat = self.frame.size.width / CGFloat(self.subviews.count)
    
    //tabbar上的四个按钮
    for index in 0..<self.tabBarButtons.count {
      let button = tabBarButtons[index]

      var buttonX:CGFloat = buttonW * CGFloat(index)
      if index > 1{
        buttonX += buttonW
      }

      button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH)
      
      //绑定按钮的tag
      button.tag = index

    }
  }

  //MARK: init
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    //添加加号按钮
    let addButton = UIButton(type: .Custom)
    addButton.addTarget(self, action: "addButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
    addButton.setBackgroundImage(UIImage.Asset.TabbarComposeButtonOs7.image, forState: .Normal)
    addButton.setBackgroundImage(UIImage.Asset.TabbarComposeButtonHighlightedOs7.image, forState: .Highlighted)
    
    addButton.setImage(UIImage.Asset.TabbarComposeIconAddOs7.image, forState: .Normal)
    addButton.setImage(UIImage.Asset.TabbarComposeIconAddHighlightedOs7.image, forState: .Highlighted)
    
    
    self.addSubview(addButton)
    self.addButton = addButton
    
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  
}
