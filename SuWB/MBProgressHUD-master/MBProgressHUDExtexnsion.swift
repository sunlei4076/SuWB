//
//  MBProgressHUDExtexnsion.swift
//  SuWB
//
//  Created by 王文臻 on 15/8/30.
//  Copyright © 2015年 王文臻. All rights reserved.
//

import UIKit

extension MBProgressHUD {
  
  //显示成功信息
  class func showSuccess(success: String,toView view: UIView?) {
    self.show(success, icon: "success.png", view: view)
  }
  /// 显示错误信息
  class func showError(error: String, toView view: UIView?) {
    self.show(error, icon: "error.png", view: view)
  }
  
  //显示一些信息
  class func showMessage(message: String, var toView view: UIView?) -> MBProgressHUD {
    if view == nil {
      view = UIApplication.sharedApplication().windows.last
    }
    let hub = MBProgressHUD.showHUDAddedTo(view, animated: true)
    hub.labelText = message
    hub.removeFromSuperViewOnHide = true
    hub.dimBackground = true
    return hub
  }

  class func showSuccess(success: String) {
    self.showSuccess(success, toView: nil)
  }
  
  class func showError(error: String) {
    self.showError(error, toView: nil)
  }
  
  class func showMessage(message: String) -> MBProgressHUD {
    return self.showMessage(message, toView: nil)
  }
  
  class func hideHUDForView(var view: UIView?) {
    if view == nil {
      view = UIApplication.sharedApplication().windows.last
    }
    self.hideHUDForView(view, animated: true)
  }
  
  class func hideHUD() {
    self.hideHUDForView(nil)
  }
  
  //显示信息
  private class func show(text: String, icon: String, var view: UIView?) {
    
    if view == nil {
      //iOS中windows这个数组只有一个窗口window
      view = UIApplication.sharedApplication().windows.last
    }
    //快速显示一个提示信息
    let hub = MBProgressHUD.showHUDAddedTo(view!, animated: true)
    hub.labelText = text
    //设置照片
    hub.customView = UIImageView(image: UIImage(named: "MBProgressHUD.bundle/\(icon)"))
    //再设置模式
    hub.mode = MBProgressHUDMode.CustomView
    //隐藏是从父控件上移除
    hub.removeFromSuperViewOnHide = true
    //0.7秒后再消失
    hub.hide(true, afterDelay: 0.7)
  }
  
  
}
