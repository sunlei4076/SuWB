//
//  PhotosView.swift
//  SuWB
//
//  Created by 王文臻 on 15/9/8.
//  Copyright © 2015年 王文臻. All rights reserved.
//

import UIKit

class PhotosView: UIImageView {
    
    /// 额外上下拉多少距离关闭（80）
    private let swipeDistanceToClose:CGFloat = 80
    /// 提醒按钮离屏幕上下边的距离（40）
    private let showMessageLabelLocation:CGFloat = 40
    
    /// 滑动多少距离时alpha透明度刚好为0
    private var kDistanceChangeAlphaToZero:CGFloat = 300
    /// 滑动多少距离退出照片预览
    private var kDistacnceToExitPhoto:CGFloat = 170
    /// 记录之前frame的位置，方便退出照片预览时可以回到原来的位置
    private var lastFrame:CGRect?
    
    private var imageView:UIImageView?
    
    /// 下拉scrollView时的提醒
    private var topShowMessageLabelOfScrollView:UILabel?
    private var bottomShowMessageLabelOfScrollView:UILabel?
    private let scrollViewShowMessageLabelFont:UIFont = UIFont.systemFontOfSize(18)
    
    /// cover的背景view的原先背景透明度
    private let alphaOfBackgroudView:CGFloat = 0.8
    
    /// 在scrollView背后的view主要用于显示背景，动态设置alpha慢慢颜色变淡的效果
    private var backgroundView: UIView?
    
    /// 当前展示的照片imageView
    private var currentImageView:UIImageView?

    private static let columnMaxCount = 3
    private let columnMaxCount = 3
    var photos:[Photo] {
        didSet{
            if self.photos != oldValue {
                //遍历photos里的照片
                for index in 0 ..< photos.count {
                    var i = index
                    let photoView = self.subviews[i] as! PhotoView
                    
                    if photos.count == 4 {
                        if index > 1 {i += 1}
                        let photoView = self.subviews[i] as! PhotoView
                        photoView.photo = photos[index]
                    }else{
                        photoView.photo = photos[index]
                    }
                    
                    for i in 0 ..< self.subviews.count { //超出部分的没有照片的imageView设置为隐藏
                        let photoView = self.subviews[i]
                        if photos.count == 4 {
                            photoView.hidden = (i > photos.count) ? true : false
                        }else{
                            photoView.hidden = (i > photos.count - 1) ? true : false
                        }
                    }
                    
                }
            }
        }
    }
    
    //MARK: - 初始化
    override init(frame: CGRect) {
        self.photos = [Photo]()
        super.init(frame: frame)
        self.clipsToBounds = true
        self.userInteractionEnabled = true
        for index in 0..<9 {
            let photoView = PhotoView(frame: CGRectZero)
            photoView.tag = index
            photoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapPhotot:"))
            self.addSubview(photoView)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
    单击photoView显示大图
    
    - parameter recognizer: 手势通知
    */
    func tapPhotot(recognizer: UIGestureRecognizer) {
        let tag = recognizer.view!.tag
        var selectedIndex = tag
        if photos.count == 4 {
            if tag > 2 {
                selectedIndex -= 1
            }
        }
        let imageView = UIImageView()
        self.imageView = imageView
        let photoView = recognizer.view as! PhotoView

        let downloadProgress = DownLoadProgress(topView: photoView)
        
        //下载图片
        imageView.sd_setImageWithURL(NSURL(string: photos[selectedIndex].bmiddle!), placeholderImage: photoView.image, options: SDWebImageOptions.ProgressiveDownload, progress: { (receivedSize: Int, expectedSize: Int) -> Void in //显示下载进度
            dispatch_async(dispatch_get_main_queue(), { () -> Void in //先主线程中显示下载进度
                downloadProgress.expectedSize = CGFloat(expectedSize)
                downloadProgress.receivedSize = CGFloat(receivedSize)
            })
            }) { (image: UIImage!, error: NSError!, _, _) -> Void in
                //TODO: - 没有网络的时候imageSize没有值，会crash
                let imageSize = image.size
                downloadProgress.removeFromSuperview()
                //添加cover的背景效果
                let backgroundView = UIView(frame: kScreenBounds)
                UIApplication.sharedApplication().keyWindow?.addSubview(backgroundView)
                backgroundView.alpha = self.alphaOfBackgroudView
                self.backgroundView = backgroundView
                
                //扩大后原来的image高度
                let afterEnlargeImageHeight = (imageSize.height / imageSize.width) * kScreenWidth
                backgroundView.alpha = self.imageIsNeedScroll(afterEnlargeImageHeight) ? 1 : self.alphaOfBackgroudView
                backgroundView.backgroundColor = self.imageIsNeedScroll(afterEnlargeImageHeight) ? UIColor.grayColor() : UIColor.blackColor()
                
                //1.添加cover遮盖幕
                let cover = self.setupCover(afterEnlargeImageHeight)
                self.topShowMessageLabelOfScrollView?.hidden = self.imageIsNeedScroll(afterEnlargeImageHeight) ? false : true
                self.bottomShowMessageLabelOfScrollView?.hidden = self.imageIsNeedScroll(afterEnlargeImageHeight) ? false : true
                
                
                //2.将照片添加到cover上
                
                imageView.frame = cover.convertRect(photoView.frame, fromView: self)
                imageView.userInteractionEnabled = true
                self.currentImageView = imageView
                let pan = UIPanGestureRecognizer(target: self, action: "pan:")
                imageView.addGestureRecognizer(pan)
                //imageView.frame = self.convertRect(photoView.frame, toView: cover)
                
                self.lastFrame = imageView.frame
                
                cover.addSubview(imageView)
                
                //3.放大图片
                UIView.animateWithDuration(0.25) { () -> Void in
                    
                    var frame = imageView.frame
                    frame.origin.x = 0
                    frame.size.width = cover.frame.size.width
                    frame.size.height = afterEnlargeImageHeight
                    if self.imageIsNeedScroll(frame) { //图片过长调整其frame位置，设置可以滚动
                        frame.origin.y = 0
                        cover.gestureRecognizers?.last
                        cover.scrollEnabled = true
                        imageView.userInteractionEnabled = false
                    }else{
                        frame.origin.y = (cover.frame.height - frame.size.height)/2
                        print("cover:\(cover.frame.height),imageFrame:\(frame.size.height),y:\(frame.origin.y)")
                        cover.scrollEnabled = false
                        cover.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "swipeCover:"))
                        imageView.userInteractionEnabled = true
                    }
                    imageView.frame = frame
                }
                
        }
        }
    
    /**
    添加cover遮盖幕
    
    - parameter contentHeight: 最终照片的高度
    
    - returns: cover的实体
    */
    private func setupCover(contentHeight: CGFloat) -> UIScrollView {
        //图片的容器（长图时可以滚动）
        let cover = UIScrollView(frame: kScreenBounds)
        cover.backgroundColor = UIColor.clearColor()
        cover.contentSize = CGSizeMake(0, contentHeight)
        cover.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        cover.showsHorizontalScrollIndicator = false
        cover.showsVerticalScrollIndicator = true
        cover.maximumZoomScale = 2.0
        cover.minimumZoomScale = 1.0
        cover.bouncesZoom = true
        cover.bounces = true
        cover.delegate = self
        cover.scrollsToTop = true
        cover.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapCover:"))
        UIApplication.sharedApplication().keyWindow?.addSubview(cover)
        
        //在scrollView中添加提醒Label，提醒下拉关闭和松手关闭
        let topLabel = setupShowMessageLabel(cover,text: "下拉关闭")
        topLabel?.center = CGPointMake(kScreenWidth/2, -showMessageLabelLocation)
        self.topShowMessageLabelOfScrollView = topLabel
        
        let bottomLabel = setupShowMessageLabel(cover, text: "上拉关闭")
        bottomLabel?.center = CGPointMake(kScreenWidth/2, cover.contentSize.height+showMessageLabelLocation)
        self.bottomShowMessageLabelOfScrollView = bottomLabel
        
        return cover
    }
    
    /**
    在scrollView中添加提醒Label，提醒下拉关闭和松手关闭
    
    - parameter toCover: 将Label添加到哪个view上
    - parameter text:    label的内容
    
    - returns: 返回设置好的label
    */
    private func setupShowMessageLabel(toCover: UIView, text: String) -> UILabel? {
        let scrollViewShowMessageLabel = UILabel()
        scrollViewShowMessageLabel.text = text
        scrollViewShowMessageLabel.textColor = UIColor.blackColor()
        scrollViewShowMessageLabel.font = scrollViewShowMessageLabelFont
        let size = scrollViewShowMessageLabel.text!.size(font: scrollViewShowMessageLabelFont)
        scrollViewShowMessageLabel.bounds.size = CGSizeMake(size.width, size.height)
        toCover.addSubview(scrollViewShowMessageLabel)
        return scrollViewShowMessageLabel
    }
    
    /**
    pan手势
    
    - parameter regonizer: 手势
    */
    func swipeCover(regonizer: UIPanGestureRecognizer) {
        let scroller = regonizer.view as? UIScrollView
        swipePhoto(regonizer, cover: scroller!)
    }
    
    /**
    pan手势
    
    - parameter regonizer: 手势
    */
    func pan(regonizer: UIPanGestureRecognizer) {
        let scroller = regonizer.view?.superview as? UIScrollView
        let cover = regonizer.view?.superview
        if  scroller?.scrollEnabled == false { //动作响应类是UIScrollView,短图
            swipePhoto(regonizer, cover: cover!)
        }
        
    }
    
    /**
    滑动图片退出预览模式
    
    - parameter regonizer: 退出的手势
    - parameter cover:     退出哪个view
    */
    private func swipePhoto(regonizer: UIPanGestureRecognizer, cover: UIView) {
        let point = regonizer.translationInView(regonizer.view)
        self.currentImageView?.center.y += point.y
        //每次滑动以后将其归零
        regonizer.setTranslation(CGPointZero, inView: regonizer.view)
        let distance = kScreenHeight/2 - currentImageView!.center.y
        if distance > 0 { //上滑 83 -> 255 RGB
            self.backgroundView?.alpha = self.alphaOfBackgroudView - distance / kDistanceChangeAlphaToZero
        }else{ //下滑
            self.backgroundView?.alpha = self.alphaOfBackgroudView + distance / kDistanceChangeAlphaToZero
        }
        
        /**
        *  当滑动结束时
        */
        if regonizer.state == UIGestureRecognizerState.Ended { //滑动结束
            let imageHeight = cover.subviews.first?.frame.height
            
            //滑动到一定距离退出图片预览
            if distance > kDistacnceToExitPhoto || distance < -kDistacnceToExitPhoto { //动画自动退出效果
                let moveHeight = distance > 0 ? -kScreenHeight/2 - imageHeight!/2: kScreenHeight/2 + imageHeight!/2
                UIView.animateWithDuration(0.35, animations: { () -> Void in
                    self.backgroundView?.alpha = 0.01
                    regonizer.view!.transform = CGAffineTransformTranslate(regonizer.view!.transform, 0, moveHeight)
                    }, completion: { (_) -> Void in
                        cover.removeFromSuperview()
                        self.backgroundView?.removeFromSuperview()
                })
            }
            //滑动距离没有达到要求的距离时动画返回原来的位置（UIScreen的中间center）
            if imageView?.center.y > kScreenHeight/2-kDistacnceToExitPhoto && imageView?.center.y < kScreenHeight/2+kDistacnceToExitPhoto
            {
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.imageView?.center.y = kScreenHeight/2
                    self.backgroundView?.alpha = self.alphaOfBackgroudView
                })
            }
        }
    }
    
    
    /**
    根据照片的尺寸判断是否滚动
    
    - parameter frame: 照片的尺寸
    
    - returns: TRUE 需要滚动 ；FALSE 不需要滚动
    */
    private func imageIsNeedScroll(frame: CGRect) -> Bool {
        return imageIsNeedScroll(frame.height)
    }
    private func imageIsNeedScroll(height: CGFloat) -> Bool {
        if height > kScreenHeight {
            return true
        }
        return false
    }
    
    /**
    滑动结束
    
    - parameter scrollView: 滑动的scrollView
    */
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset
        if contentOffset.y < -swipeDistanceToClose || contentOffset.y > scrollView.contentSize.height - kScreenHeight + swipeDistanceToClose {
                self.topShowMessageLabelOfScrollView?.text = "松手关闭"
                self.bottomShowMessageLabelOfScrollView?.text = "松手关闭"
        }else{
            self.topShowMessageLabelOfScrollView?.text = "下拉关闭"
            self.bottomShowMessageLabelOfScrollView?.text = "上拉关闭"
        }
        
    }
    
    
    /**
    scrollView的滚动监听
    
    - parameter scrollView: 滚动的scrollView
    - parameter decelerate: 是否减速
    */
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let contentOffset = scrollView.contentOffset
        if contentOffset.y < -swipeDistanceToClose || contentOffset.y > scrollView.contentSize.height - kScreenHeight + swipeDistanceToClose { //自动滑动退出
            var distanceTransform = -kScreenHeight
            if contentOffset.y < -swipeDistanceToClose {
                distanceTransform = kScreenHeight
            }
            UIView.animateWithDuration(0.35, animations: { () -> Void in
                self.backgroundView?.alpha = 0.01
                scrollView.transform = CGAffineTransformTranslate(scrollView.transform, 0, distanceTransform)
                }, completion: { (_) -> Void in
                    scrollView.removeFromSuperview()
                    self.backgroundView?.removeFromSuperview()
            })
            
        }

    }
    
    /**
    点击遮盖cover
    
    - parameter recognizer: 点击的手势通知
    */
    func tapCover(recognizer: UITapGestureRecognizer) {
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            let cover = recognizer.view!
            
            cover.subviews.last?.frame = self.lastFrame!
            cover.alpha = 0.01
            self.backgroundView?.alpha = 0.01
            
            }) { (_) -> Void in
                recognizer.view?.removeFromSuperview()
                self.backgroundView?.removeFromSuperview()
        }
        
    }

    
    /**
    最大列数为columnMaxCount时，个数为count时的整体imageView的size
    
    - parameter count:          需要显示的照片个数
    - parameter columnMaxCount: 一行最大的个数
    
    - returns: 返回count个数时的整体Size
    */
    class func sizeWithImageCount(count: Int?, var columnMaxCount: Int = columnMaxCount) -> CGSize? {
        guard let count = count else {return nil}
        if count == 4 {columnMaxCount = 2}
        let eachWH:CGFloat = 70
        let margin:CGFloat = 10
        let row = (count + columnMaxCount - 1) / columnMaxCount
        let column = count < (columnMaxCount-1) ? count : columnMaxCount
        
        let x:CGFloat = CGFloat(column) * (eachWH + margin) - margin
        let y: CGFloat = CGFloat(row) * (eachWH + margin) - margin
        return CGSizeMake(x, y)
    }
    
    /**
    预先设置九宫格照片的位置
    */
    override func layoutSubviews() {
        super.layoutSubviews()
        for index in 0 ..< self.subviews.count {
            let margin:CGFloat = 10
            let imageView = self.subviews[index]
            var frame = imageView.frame
            frame.origin.x = CGFloat(index % columnMaxCount) * (frame.size.width + margin)
            frame.origin.y = CGFloat(index / columnMaxCount) * (frame.size.height + margin)
            imageView.frame = frame
        }
    }
    
}

typealias scrollViewDelegate = PhotosView
extension scrollViewDelegate: UIScrollViewDelegate {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
