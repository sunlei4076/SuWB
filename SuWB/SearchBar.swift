//
//  SearchBar.swift
//  SuWB
//
//  Created by 王文臻 on 15/8/26.
//  Copyright © 2015年 王文臻. All rights reserved.
//

import UIKit

class SearchBar: UITextField {
  let leftViewRectWithWith:CGFloat = 30
  
  class func searchBar() -> SearchBar {
    
    return SearchBar()
    
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.leftView?.frame = CGRectMake(0, 0, leftViewRectWithWith, self.frame.size.height)

  }
  
  //MARK: - init
  override init(frame: CGRect) {
    
    super.init(frame: frame)
    //设置searchBar的背景
    self.background = UIImage.resizableImageWithName("searchbar_textfield_background_os7")
    self.placeholder = "搜索"
    //设置左边view
    let leftView = UIImageView(image: UIImage.Asset.SearchbarTextfieldSearchIcon.image)
    self.leftView = leftView
    self.leftView?.contentMode = UIViewContentMode.Center
    self.leftViewMode = UITextFieldViewMode.Always
    //设置 代理
    self.delegate = self
    //设置字体
    self.font = UIFont.systemFontOfSize(13)
    //设置右边的清除按钮
    self.clearButtonMode = UITextFieldViewMode.Always
    //设置提醒文字
//    self.attributedPlaceholder = NSAttributedString(string: "搜索", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
    //设置返回按钮的样式
    self.returnKeyType = UIReturnKeyType.Search
    self.enablesReturnKeyAutomatically = true
    
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

  //重写leftView的rect ，不设置的话，一开始left会和放大镜的图标重叠
  override func leftViewRectForBounds(bounds: CGRect) -> CGRect {
    return CGRectMake(0, 0, leftViewRectWithWith, self.frame.size.width)
  }
  
}


extension SearchBar: UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" { //如果输入回车键，结束输入，取消键盘
            textField.resignFirstResponder()
            return false
        }
        
        
        if string == " " { //禁止输入空格
            return false
        }
        return true
    }
}
