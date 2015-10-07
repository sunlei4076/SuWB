//
//  DownLoadProgress.swift
//  小黄人
//
//  Created by 王文臻 on 15/9/9.
//  Copyright © 2015年 susnm. All rights reserved.
//

import UIKit

class DownLoadProgress: UIView {
    
    /// 已下载数据
    var receivedSize: CGFloat? {
        didSet{
            setNeedsDisplay()
        }
    }
    /// 图片总数据
    var expectedSize: CGFloat?
    
    
    private var radius:CGFloat = 32
    private let outsideCircleWidth:CGFloat = 3.5
    private let margin:CGFloat = 2
    private var insideRadius:CGFloat = 32 - 3.5 - 2

    override func drawRect(rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        drawOutsideCircle(ctx,rect: rect)
        if receivedSize != nil {
            drawInsideCircle(ctx, rect: rect, hasData: receivedSize!, allData: expectedSize!)
        }
    }
    
    /**
    画最外围的圆圈
    
    :param: ctx 当前图形上下文
    */
    func drawOutsideCircle(ctx: CGContextRef?, rect: CGRect) {
        
        CGContextAddArc(ctx, rect.size.width/2, rect.size.height/2, CGFloat(radius), CGFloat(0), CGFloat(M_PI * 2), 1)
        UIColor.grayColor().set()
        self.alpha = 0.8
        CGContextSetLineWidth(ctx, outsideCircleWidth)
        CGContextStrokePath(ctx)
        
    }
    
    func drawInsideCircle(ctx: CGContextRef?,rect: CGRect,hasData: CGFloat,allData: CGFloat) {
        
        let hasDownloadPercentage:CGFloat = (hasData / allData) * CGFloat(M_PI) * 2
        
        CGContextMoveToPoint(ctx, rect.size.width/2, rect.size.height/2)
//        CGContextAddLineToPoint(ctx, rect.size.width/2, rect.size.height/2+insideRadius)
        CGContextAddArc(ctx, rect.size.width/2, rect.size.height/2, CGFloat(insideRadius), CGFloat(-M_PI_2), hasDownloadPercentage - CGFloat(M_PI/2), 0)
        CGContextAddLineToPoint(ctx, rect.size.width/2, rect.size.height/2)
        UIColor.grayColor().set()
        CGContextSetLineWidth(ctx, outsideCircleWidth)
        CGContextFillPath(ctx)
        
    }
    
    
    /**
    设置下载进度到topView上
    
    - parameter topView: 需要添加进度条的View
    
    - returns: 初始化完成
    */
    convenience init(topView: PhotoView) {
        self.init()
        self.backgroundColor = UIColor.clearColor()
        self.frame = topView.bounds
        topView.addSubview(self)
        
        self.radius = topView.frame.size.width/2 - 5
        self.insideRadius = radius - outsideCircleWidth - margin
        
    }
    
    init() {
        super.init(frame: CGRectZero)
        self.backgroundColor = UIColor.clearColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//    }
    
}
