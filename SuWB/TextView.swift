//
//  TextView.swift
//  SuWB
//
//  Created by 王文臻 on 15/9/27.
//  Copyright © 2015年 王文臻. All rights reserved.
//

import UIKit

class TextView: UITextView {

    /// 提醒的文字
    var placeholder: String? {
        willSet{
            self.placeholderLabel!.text = newValue
            if newValue != nil {
                placeholderLabel!.hidden = false
                let labelX:CGFloat = 5
                let labelY:CGFloat = 7
                let labelSize:CGSize = newValue!.size(box: CGSizeMake(kScreenWidth-2*labelX, kScreenHeight), font: placeholderLabel.font)
                placeholderLabel!.frame = CGRectMake(labelX, labelY, labelSize.width, labelSize.height)
            }else{
                placeholderLabel.hidden = true
            }
        }
    }
    /// 提醒文字的颜色(默认为浅灰色)
    var placeholderColor: UIColor? {
        didSet{
            self.placeholderLabel!.textColor = placeholderColor
        }
    }
    
    
    private var placeholderLabel: UILabel! 
    
    
    /**
    监听文字的输入
    */
    func textViewDidChange() {
        placeholderLabel.hidden = self.text != ""
    }
    
    //MARK: -  初始化
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        //1.添加提醒的label
        let placeholderLabel = UILabel()
        placeholderLabel.numberOfLines = 0
        placeholderLabel.hidden = true
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGrayColor()
        self.insertSubview(placeholderLabel, atIndex: 0)
        
        self.placeholderLabel = placeholderLabel
        
        //2.添加文字输入监听
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textViewDidChange", name: UITextViewTextDidChangeNotification, object: self)
        
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - deinit
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}
