//
//  StatusCell.swift
//  SuWB
//
//  Created by 王文臻 on 15/9/4.
//  Copyright © 2015年 王文臻. All rights reserved.
//

import UIKit

class StatusCell: UITableViewCell {
    
    /// 顶部View
    var topView: StatusTopView!
    
    ///微博的工具条
    var statusToolbar: StatusToolbarView!
    
    //调整cell的整体位置
    override var frame: CGRect {
        didSet{
            super.frame.origin.x = StatusCellBorder
            super.frame.origin.y += StatusCellBorder
            super.frame.size.width -= 2 * StatusCellBorder
            super.frame.size.height -= StatusCellBorder
        }
    }
    
    
    var statusFrame: StatusFrame? {
        didSet{
            if self.statusFrame != oldValue {
                //初始化原创微博的data
                setupTopViewData()
                
                //初始化微博的工具条data
                setupStatusToolbarData()
            }
        }
    }
    
    //MARK: - data
    /**
    初始化原创微博的data
    */
    private func setupTopViewData() {
        
        self.topView.frame = statusFrame!.topViewF
        self.topView.statusFrame = statusFrame
        
    }
    
    /**
    初始化微博的工具条data
    */
    private func setupStatusToolbarData() {
        
        self.statusToolbar.frame = statusFrame!.statusToolbarF
        self.statusToolbar.status = statusFrame!.status
        
    }
    
    
    //MARK: 快速创建一个statusCell
    /// 快速创建一个statusCell
    class func statusCellWithTableView(tableView: UITableView) -> StatusCell {
        let id = "status"
        var cell = tableView.dequeueReusableCellWithIdentifier(id) as? StatusCell
        if cell == nil {
            cell = StatusCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: id)
        }
        return cell!
    }
    
    //MARK: - SubViews
    /**
    初始化原创微博的控件
    */
    private func setupTopViewSubviews() {
        
        //去除cell选中是的自带背景效果
        self.selectedBackgroundView = UIView()
        
        // 添加topView
        let topView = StatusTopView(frame: CGRectZero)
        self.contentView.addSubview(topView)
        self.topView = topView
        
    }
    
    
    
    /**
    初始化微博的工具条控件
    */
    private func setupStatusToolbarSubviews() {
        
        // 添加微博的工具条
        let statusToolbar = StatusToolbarView(frame: CGRectZero)
        self.contentView.addSubview(statusToolbar)
        self.statusToolbar = statusToolbar
        
    }
    

    
    //MARK: -init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //初始化原创微博的控件
        setupTopViewSubviews()
        
        //初始化微博的工具条控件
        setupStatusToolbarSubviews()
        
        self.backgroundColor = UIColor.clearColor()
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
