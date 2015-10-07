//
//  ComposeViewController.swift
//  SuWB
//
//  Created by 王文臻 on 15/9/27.
//  Copyright © 2015年 王文臻. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate, ComposeToolbarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// TextView（滚动文本）
    private var textView:TextView!
    /// 发微博工具条
    private var composeToolbar:ComposeToolbar!
    /// 照片显示区域
    private var composePhotosView:ComposePhotosView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置导航栏
        setupNavBar()
        //设置TextView（滚动文本）
        setupTextView()
        //设置发微博的工具条
        setupToolBar()
        
        //添加键盘动作的监听
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        //添加照片显示区域
        setupPhotosView()
    }
    
    /**
    添加照片显示区域
    */
    private func setupPhotosView() {
        let photosView = ComposePhotosView()
        photosView.delegate = self
        photosView.frame = CGRectMake(0, 120, kScreenWidth, kScreenHeight-120)
        self.textView.addSubview(photosView)
        self.composePhotosView = photosView
    }
    
    /**
    设置发微博的工具条
    */
    private func setupToolBar() {
        let composeToolbar = ComposeToolbar(frame: CGRectZero)
        composeToolbar.delegate = self
        composeToolbar.frame = CGRectMake(0, kScreenHeight - 44, kScreenWidth, 44)
        self.view.addSubview(composeToolbar)
        self.composeToolbar = composeToolbar
    }
    
    /**
    设置TextView（滚动文本）
    */
    private func setupTextView() {
        let textView = TextView()
        textView.alwaysBounceVertical = true
        textView.delegate = self
        textView.placeholder = "分享新鲜事..."
//        textView.placeholderColor = UIColor.lightGrayColor()
        textView.backgroundColor = UIColor.clearColor()
        textView.font = UIFont.systemFontOfSize(18)
        textView.frame = self.view.bounds
        self.view.addSubview(textView)
        self.textView = textView
    }

    /**
    设置导航栏
    */
    private func setupNavBar() {
        self.title = "发微博"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Done, target: self, action: "cancel")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Done, target: self, action: "send")
        
    }
    
    
    //MARK: - 通知
    /**
    键盘即将显示
    
    - parameter notification: 通知
    */
    func keyboardWillShow(notification: NSNotification){
        let endFrame = notification.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
        UIView.animateWithDuration(duration!) { () -> Void in
            self.composeToolbar.transform = CGAffineTransformMakeTranslation(0, -endFrame.height)
        }
    }
    
    /**
    键盘即将隐藏
    
    - parameter notification: 通知
    */
    func keyboardWillHide(notification: NSNotification){
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
        UIView.animateWithDuration(duration!) { () -> Void in
            self.composeToolbar.transform = CGAffineTransformIdentity
        }
    }
    
    /**
    键盘文字输入监听
    */
    func textViewDidChanged() {
        navigationItem.rightBarButtonItem?.enabled = self.textView.text != ""
    }
    
    //MARK: - ScrollViewDelegate
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.textView.becomeFirstResponder()
        navigationItem.rightBarButtonItem?.enabled = false
    }
    
    
    //MARK: - 导航栏上两个按钮的监听
    func cancel() {
        self.textView.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //发微博
    func send() {
        if composePhotosView.allPhotos().count == 0 {
            sendWithOutImage()
        }else{
            sendWithImage()
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
    发送没有照片的微博
    */
    private func sendWithOutImage(){
//        let params = ["access_token": AccountTool.account()!.access_token!,"status": textView.text!]
        let params = ComposeParam()
        params.status = textView.text!
        ComposeTool.sendStatusWithParam(params, success: { (result) -> () in
            MBProgressHUD.showSuccess("发送成功")
            }) { (error) -> () in
                MBProgressHUD.showError("发送失败")
        }
    }
    
    /**
    发送照片的微博
    */
    private func sendWithImage(){
        //封装请求参数
        let formDatas = composePhotosView.allPhotos().map({
            FormData(data: UIImageJPEGRepresentation($0, 0.0001)!, name: "pic", fileName: "", mimeType: "image/jpeg") })
        let params = ComposeParam()
        params.status = textView.text!
        params.datas = formDatas
        //发送请求
        ComposeTool.sendStatusWithParam(params, success: { (result) -> () in
            MBProgressHUD.showSuccess("发送成功")
            }) { (error) -> () in
                MBProgressHUD.showError("发送失败")
        }
    }
    
    
    
    //MARK: - ComposeToolbarDelegate
    func composeToolbar(composeToolbar: ComposeToolbar, didClickedButton buttonType: ComposeToolbarButtonType) {
        switch buttonType {
        case .Camera:
            openCamera()
        case .Picture:
            openPhotoLibrary()
        default: return
        }
    }
    
    /**
    打开相册
    */
    private func openCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    /**
    打开相机
    */
    private func openPhotoLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        composePhotosView.addPhoto(image)
        picker.dismissViewControllerAnimated(true) { () -> Void in
            //修复选择照片完成回到发送页面以后，有文字内容但是发送按钮不能点击的bug
            if self.textView.text != "" {
                self.navigationItem.rightBarButtonItem?.enabled = true
            }
        }
    }
    
    //MARK: - 初始化
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.view.backgroundColor = UIColor.whiteColor()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textViewDidChanged", name: UITextViewTextDidChangeNotification, object: textView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - deinit
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}

extension ComposeViewController: ComposePhotosViewDelegate {
    /**
    点击照片浏览器
    
    - parameter composePhotosView: 发送微博的浏览器的控制器
    - parameter photosView:        照片浏览器
    */
    func composePhotosView(composePhotosView: ComposePhotosView, photosViewDidClicked photosView: UIView) {
        if textView.isFirstResponder() {
            textView.resignFirstResponder()
        }else{
            textView.becomeFirstResponder()
        }
    }

}

