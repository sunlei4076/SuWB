//
//  OAuthViewController.swift
//  SuWB
//
//  Created by 王文臻 on 15/8/28.
//  Copyright © 2015年 王文臻. All rights reserved.
//

import UIKit

class OAuthViewController: UIViewController {

    override func viewDidLoad() {
      super.viewDidLoad()
      
      UIApplication.sharedApplication().statusBarHidden = true
      
      let webView = UIWebView()
      webView.frame = self.view.bounds
      webView.delegate = self
      self.view.addSubview(webView)
      
      let url = NSURL(string: "https://api.weibo.com/oauth2/authorize?client_id=\(AppKey)&redirect_uri=\(RedirectURL)")
      let request = NSURLRequest(URL: url!)
      webView.loadRequest(request)
      
    }

  
  

}
/*
client_id	true	string	申请应用时分配的AppKey。 2074771011
client_secret	true	string	申请应用时分配的AppSecret。  Secret：c629b86d320619fc98bb66f16942518d
grant_type	true	string	请求的类型，填写authorization_code

grant_type为authorization_code时
必选	类型及范围	说明
code	true	string	调用authorize获得的code值。
redirect_uri	true	string	回调地址，需需与注册应用里的回调地址一致。   https://api.weibo.com/oauth2/default.html

*/

typealias webViewDelegate = OAuthViewController

extension webViewDelegate: UIWebViewDelegate {
  
  /**
  每次网络请求都会掉用这个方法，我们在这里获取返回的code
  
  :param: request        url请求
  */
  func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
    //获取URL的绝对路径
    let url = request.URL?.absoluteString
    let range = url?.rangeOfString("code=")
    if range != nil {
      //截取链接后面的code码
      let code = url!.substringFromIndex(range!.endIndex)
      //利用截取的code获取accessToken
      accessTokenWithCode(code)
      //避免获取到code以后还进入回调页面
      return false
    }
    return true
  }
  
  /**
  每次webView开始加载网页前都会调用这个方法
  */
  
  func webViewDidStartLoad(webView: UIWebView) {
//    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    MBProgressHUD.showMessage("登陆页面加载中。。。")
  }
  
  /**
  每次webView加载网页完成时都会调用这个方法
  */
  func webViewDidFinishLoad(webView: UIWebView) {
    MBProgressHUD.hideHUD()
  }
  
  /**
  加载webView网页失败时调用这个方法
  */
  func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
    MBProgressHUD.hideHUD()
  }
  
  /**
  通过code获取accessToken
  
  :param: code 需要的code
  */
  
  func accessTokenWithCode(code: String) {
    
    let paramDict = AccountParam()
    paramDict.code = code
    
    AccountTool.OAuthWithParam(paramDict, success: { (result) -> () in
        //储存账户信息
        AccountTool.saveAccount(result)
        
        //新特性／去首页
        AccountTool.chooseRootViewController()
        MBProgressHUD.hideHUD()
        }) { (error) -> () in
             MBProgressHUD.hideHUD()
    }
    
//    HttpTool.postWithURL("https://api.weibo.com/oauth2/access_token", params: paramters, success: { (json) -> () in
//        //将字典转成模型
//        let dict = json as? [String : AnyObject]
//        let account = Account.accountWithDict(dict!)
//        //储存账户信息
//        AccountTool.saveAccount(account)
//        
//        //新特性／去首页
//        AccountTool.chooseRootViewController()
//        MBProgressHUD.hideHUD()
//        }) { (error) -> () in
//            MBProgressHUD.hideHUD()
//    }
    
  }
  
}
