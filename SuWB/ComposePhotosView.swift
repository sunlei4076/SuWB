//
//  ComposePhotosView.swift
//  SuWB
//
//  Created by 王文臻 on 15/9/28.
//  Copyright © 2015年 王文臻. All rights reserved.
//

import UIKit

@objc protocol ComposePhotosViewDelegate {
    optional func composePhotosView(composePhotosView: ComposePhotosView, imageViewDidClicked imageView: UIImageView)
    optional func composePhotosView(composePhotosView: ComposePhotosView, photosViewDidClicked photosView: UIView)
}

class ComposePhotosView: UIView {
    
    private let imageH:CGFloat = 100
    private let imageW:CGFloat = 100
    private let closeBtnWH:CGFloat = 20
    
    /// 照片美行的数量（默认为3列）
    var maxColumns:Int = 3 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    weak var delegate: ComposePhotosViewDelegate?

    /**
    添加照片
    
    - parameter image: 要添加的照片
    */
    func addPhoto(image:UIImage) {
        let imageView = UIImageView()
        imageView.userInteractionEnabled = true
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = image
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "imageViewDidClicked:"))
        self.addSubview(imageView)
        
        //添加删除照片的按钮
        let closeBtn = UIButton()
        closeBtn.alpha = 0.7
        closeBtn.setBackgroundImage(UIImage.Asset.Close.image, forState: .Normal)
        closeBtn.addTarget(self, action: "removeImage:", forControlEvents: UIControlEvents.TouchUpInside)
        closeBtn.frame = CGRectMake(imageW - closeBtnWH, 0, closeBtnWH, closeBtnWH)
        imageView.addSubview(closeBtn)
        
    }
    
    //MARK: - 按钮的点击
    
    func removeImage(button: UIButton) {
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            button.superview!.alpha = 0.01
            }) { (_) -> Void in
                button.superview!.removeFromSuperview()
        }
    }
    /**
    照片的点击
    
    - parameter recognizer: 手势
    */
    func imageViewDidClicked(recognizer:UIPanGestureRecognizer) {
        let imageView = recognizer.view as! UIImageView
        delegate?.composePhotosView?(self, imageViewDidClicked: imageView)
    }
    
    /**
    照片浏览器的点击
    
    - parameter recognizer: 手势
    */
    func photosViewDidClicked(recognizer:UIPanGestureRecognizer) {
        let view = recognizer.view!
        delegate?.composePhotosView?(self, photosViewDidClicked: view)
    }
    
    /**
    获取所有照片
    
    - returns: 返回获取到的照片
    */
    func allPhotos() -> [UIImage] {
        let imageViews = subviews as! [UIImageView]
        return imageViews.map({ $0.image! })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margin:CGFloat = (kScreenWidth - CGFloat(maxColumns) * imageW) / CGFloat(maxColumns+1)
        for index in 0 ..< subviews.count {
            let imageView = subviews[index]
            let imageX:CGFloat = CGFloat(index % maxColumns) * (imageW + margin) + margin
            let imageY:CGFloat = CGFloat(index / maxColumns) * (imageH + margin)
            imageView.frame = CGRectMake(imageX, imageY, imageW, imageH)
        }

    }
    
    //MARK: - 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.userInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "photosViewDidClicked:"))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
