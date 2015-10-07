//
//  NewfeatureViewController.swift
//  SuWB
//
//  Created by 王文臻 on 15/8/26.
//  Copyright © 2015年 王文臻. All rights reserved.
//

import UIKit

class NewfeatureViewController: UIViewController {
  
  let newFeatureImageCount:Int = 3
  private var pageControl:UIPageControl?

    override func viewDidLoad() {
        
    UIApplication.sharedApplication().statusBarHidden = true
      super.viewDidLoad()
      //设置滚动照片scrollerView
      setupScrollerView()
      //设置提醒第几页小按钮 PageControl
      setupPageControl()
    }
  
  /**
  设置提醒第几页小按钮 PageControl
  */
  private func setupPageControl() {
    let pageControl = UIPageControl()
    pageControl.numberOfPages = newFeatureImageCount
    pageControl.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 30)
    pageControl.currentPageIndicatorTintColor = UIColor(red: 253/255, green: 98/255, blue: 42/255, alpha: 1)
    pageControl.pageIndicatorTintColor = UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1)
    self.pageControl = pageControl
    self.view.addSubview(pageControl)
  }
  
  /**
  //设置滚动照片scrollerView
  */
  private func setupScrollerView() {
    
    let scrollView = UIScrollView()
    scrollView.delegate = self
    scrollView.frame = self.view.frame
    scrollView.pagingEnabled = true
    scrollView.bounces = true
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.contentSize = CGSizeMake(view.frame.size.width * CGFloat(newFeatureImageCount), self.view.frame.size.height)
    self.view.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
    
    self.view.addSubview(scrollView)
    
    for index in 0 ..< newFeatureImageCount {
      let imageView = UIImageView()
        if kScreenHeight >= 568 {
            imageView.image = UIImage(named: "new_feature_\(index+1)-568h")
        }else{
            imageView.image = UIImage(named: "new_feature_\(index+1)")
        }
        
      let imageW:CGFloat = self.view.frame.size.width
      let imageH:CGFloat = self.view.frame.size.height
      let imageX:CGFloat = imageW * CGFloat(index)
      let imageY:CGFloat = 0
      imageView.frame = CGRectMake(imageX, imageY, imageW, imageH)
      
      if index == newFeatureImageCount - 1 {
        setupLastImage(imageView)
      }
      
      scrollView.addSubview(imageView)
    }

  }

  /**
  初始化最后一张照片上的子控件
  
  :param: imageView 那个页面的imageView上需要设置
  */
  
  private func setupLastImage(imageView:UIImageView) {
    //设置imageView上的空间可以点击互动
    imageView.userInteractionEnabled = true
    
    //添加开始按钮
    let startButton = UIButton(type: .Custom)
    startButton.setBackgroundImage(UIImage.Asset.NewFeatureButton.image, forState: .Normal)
    startButton.setBackgroundImage(UIImage.Asset.NewFeatureButtonHighlighted.image, forState: UIControlState.Highlighted)
    startButton.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height * 0.6)
    startButton.bounds = CGRectMake(0, 0, startButton.currentBackgroundImage!.size.width, startButton.currentBackgroundImage!.size.height)
    startButton.addTarget(self, action: "start", forControlEvents: .TouchUpInside)
    print(startButton.frame)
    
    imageView.addSubview(startButton)
    
    //添加是否发微博的按钮
    let chechBox = UIButton.checkBox(title: "分享给大家",target: self, action: "shared:")
    chechBox.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*0.52)
    imageView.addSubview(chechBox)
    
  }
  
  func shared(button:UIButton) {
    button.selected = !button.selected
  }
  
  /**
  开始进入微博的按钮
  */
  func start() {

    self.view.window?.rootViewController = TabBarViewController()
    
  }
  
  //验证start以后，newfeatureViewController已经注销掉了
  deinit {
    myPrint("deinit ---- ")
  }

}

extension NewfeatureViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(scrollView: UIScrollView) {
    let currentDouble:CGFloat = scrollView.contentOffset.x / self.view.frame.size.width
    let currentInt:Int = Int(currentDouble + 0.5)
    self.pageControl?.currentPage = currentInt

  }
}