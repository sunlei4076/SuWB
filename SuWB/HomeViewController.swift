//
//  HomeViewController.swift
//  SuWB
//
//  Created by 王文臻 on 15/8/22.
//  Copyright © 2015年 王文臻. All rights reserved.
//  首页

import UIKit
import MJRefresh

class HomeViewController: UITableViewController {
  
    /// 所有的微博数据
    var statusesFrame: [StatusFrame] = [StatusFrame]()
    /// 显示昵称的按钮
    private var titleButton: TitleButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置tableView的分割线为none
        self.tableView.separatorStyle = .None
        
        //设置刷行view
        self.SetupRefreshView()
        
        //设置NavigationBar
        setupNavigationBar()
        
        //显示当前登陆人的昵称
        showUserName()
        
    }
    
    
    /**
    刷新数据的控件
    */
    private func SetupRefreshView() {
        self.tableView.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "refreshStateChange:")
        self.tableView.header.beginRefreshing()
        
        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "refreshStateChange:")
        footer.automaticallyRefresh = false
        footer.triggerAutomaticallyRefreshPercent = 20
        self.tableView.footer = footer
    }
    
    func refresh() {
     self.tableView.header.beginRefreshing()
    }
    
    
    /**
    显示新微博的数量
    
    - parameter count: 微博的数量
    */
    private func showNewStatusCount(count: Int?) {
        let btn = UIButton()
        btn.userInteractionEnabled = false
        let btnX:CGFloat = 0
        let btnY:CGFloat = 20
        let btnW:CGFloat = kScreenWidth
        let btnH:CGFloat = 64 - btnY
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH)
        btn.setBackgroundImage(UIImage.Asset.TimelineNewStatusBackgroundOs7.image, forState: UIControlState.Normal)
        self.navigationController!.view.insertSubview(btn, belowSubview: self.navigationController!.navigationBar)
        btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        if count == 0 {
            btn.setTitle("没有新的微博内容", forState: UIControlState.Normal)
        }else if count == nil {
            btn.setTitle("网络出错，微博数据加载失败", forState: UIControlState.Normal)
        }else {
            btn.setTitle("有\(count!)条新的微博内容", forState: UIControlState.Normal)
            
        }
        
        //animation
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            btn.transform = CGAffineTransformMakeTranslation(0, btnH+1)
            }) { (finish) -> Void in
                UIView.animateWithDuration(0.5, delay: 1.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    btn.transform = CGAffineTransformIdentity
                    }, completion: { (_) -> Void in
                        btn.removeFromSuperview()
                })
        }
    }
    
    /**
    加载当前用户的昵称
    */
    private func showUserName() {
        guard let uid = AccountTool.account()?.uid else {
            print("uid 过期了")
            return
        }
        let param = UserParam()
        param.uid = uid
        
        UserTool.userInfoWithParam(param, success: { (result) -> () in
            
            self.titleButton?.setTitle(result.name!, forState: UIControlState.Normal)
            //将昵称保存到账户信息中
            let account = AccountTool.account()
            account?.name = result.name
            AccountTool.saveAccount(account!, isNeedUpdateExpiresTime: false)
            
            }) { (error) -> () in
                print("加载昵称失败")
        }
        

    }
  
    
    /**
    刷新微博数据
    
    - parameter refreshControl: 刷新的控件
    */
    func refreshStateChange(refreshControl: MJRefreshComponent) {
    
        let param = StatusParam()
        //根据不同的需求设置不同的paramters
        if refreshControl.classForCoder == MJRefreshNormalHeader.classForCoder() { //下拉刷行
            if statusesFrame.count != 0 {
                param.since_id = statusesFrame[0].status!.idstr!
            }
        }else if refreshControl.classForCoder == MJRefreshAutoNormalFooter.classForCoder() { //上拉刷新
            param.max_id = "\(Int(statusesFrame.last!.status!.idstr!)! - 1)"
        }
        
        StatusTool.homeStatusWithParam(param, success: { [unowned self] (result) -> () in
            guard let statuses = result.statuses else {
                print("返回结果中，微博数组为nil")
                return
            }
            let newStatusesFrame = statuses.map({
                (status) -> StatusFrame in
                let statusFrame = StatusFrame()
                statusFrame.status = status
                return statusFrame
            })
            if refreshControl.classForCoder == MJRefreshNormalHeader.classForCoder() {
                self.statusesFrame = newStatusesFrame + self.statusesFrame
                //TODO: 显示微博的倒序阅读功能
                //                if self.statusesFrame.count > 20 {
                //                    self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: newStatusesFrame.count-1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
                //                }else{
                //                    self.tableView.reloadData()
                //                }
            }else if refreshControl.classForCoder == MJRefreshAutoNormalFooter.classForCoder(){
                self.statusesFrame += newStatusesFrame
            }
            
            //刷新数据
            self.tableView.reloadData()
            
            refreshControl.endRefreshing()
            self.tabBarItem.badgeValue = "0"
            
            //显示新微博的数量
            if refreshControl.classForCoder == MJRefreshNormalHeader.classForCoder() {
                self.showNewStatusCount(newStatusesFrame.count)
            }

            }) { (error) -> () in
                self.showNewStatusCount(nil)
                refreshControl.endRefreshing()
        }
        
  }
  
  /**
  初始化NavigationBar
  */
  private func setupNavigationBar() {
    //设置左边的按钮
    self.navigationItem.leftBarButtonItem = UIBarButtonItem.itemWithIcon("navigationbar_friendsearch_os7", highIcon: "navigationbar_friendsearch_highlighted_os7", target: self, action: "friendsearch")
    //设置右边的按钮
    self.navigationItem.rightBarButtonItem = UIBarButtonItem.itemWithIcon("navigationbar_pop_os7", highIcon: "navigationbar_pop_highlighted_os7", target: self, action: "pop")
    //设置中间的title按钮
    let titleButton = TitleButton()
    titleButton.bounds = CGRectMake(0, 0, 0, 40)
    
    if AccountTool.account()!.name != nil { //已有保存的账户昵称
        titleButton.setTitle(AccountTool.account()!.name!, forState: UIControlState.Normal)
    }else{
        titleButton.setTitle("首页", forState: UIControlState.Normal)
    }
    self.titleButton = titleButton
    
    titleButton.setImage(UIImage.Asset.NavigationbarArrowDownOs7.image, forState: UIControlState.Normal)
    titleButton.addTarget(self, action: "titleBtnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
    self.navigationItem.titleView = titleButton
    
    self.tableView.backgroundColor = UIColor.colorWithRGB(226, g: 226, b: 226)
    self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: StatusCellBorder, right: 0)
    self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
  }
  
  /**
  标题按钮的点击时间
  */
  func titleBtnClicked(button: TitleButton) {
    if button.currentImage == UIImage.Asset.NavigationbarArrowDownOs7.image {
      button.setImage(UIImage.Asset.NavigationbarArrowUpOs7.image, forState: UIControlState.Normal)
    }else {
      button.setImage(UIImage.Asset.NavigationbarArrowDownOs7.image, forState: UIControlState.Normal)
    }
  }
  
  func friendsearch() {
    self.tabBarItem.badgeValue = "haha"
    myPrint("friendsearch")
  }
  
  func pop() {
    self.tabBarItem.badgeValue = "123"
    myPrint("pop")
  }
  
  
  

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
      return statusesFrame.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = StatusCell.statusCellWithTableView(tableView)
        cell.statusFrame = self.statusesFrame[indexPath.row]
        
        return cell
    }


    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.statusesFrame[indexPath.row].cellHeight
    }

}
