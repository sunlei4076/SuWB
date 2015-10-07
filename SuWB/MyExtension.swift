//
//  MyExtension.swift
//  SuWB
//
//  Created by 王文臻 on 15/8/24.
//  Copyright © 2015年 王文臻. All rights reserved.
//

import UIKit

func myPrint<T>(value: T) {
    #if DEBUG
  print(value)
    #else
//    print(value)
    #endif
}

func printLog<T>(message:T, file:String = __FILE__, method:String = __FUNCTION__,line:Int = __LINE__) {
    #if DEBUG
    print("\((file as NSString).lastPathComponent)[\(line)],\(method):\(message)")
    #endif
}

let kScreenBounds = UIScreen.mainScreen().bounds
let kScreenWidth = UIScreen.mainScreen().bounds.width
let kScreenHeight = UIScreen.mainScreen().bounds.height


//MARK: - UIImage扩展
extension UIImage {

    /// 拉伸照片的大小
    class func resizableImageWithName(name:String) -> UIImage? {
    
        guard let image = UIImage(named: name) else{
            return nil
        }
        return image.resizableImageWithCapInsets(UIEdgeInsets(top: image.size.height/2, left: image.size.width/2, bottom: image.size.height/2,right: image.size.width/2))
    }
    
    /// 拉伸照片的大小 left , top < 1
    class func resizableImageWithName(name:String, left: CGFloat, top: CGFloat) -> UIImage? {
    
        guard let image = UIImage(named: name) else {
            return nil
        }
        return image.resizableImageWithCapInsets(UIEdgeInsets(top: image.size.height * top, left: image.size.width * left, bottom: image.size.height * (1 - top), right: image.size.width * (1 - left)))
    }
}

//MARK: - UIBarButtonItem扩展
extension UIBarButtonItem {
  /// 创建一个有高亮情况的BarButtonItem
  class func itemWithIcon(icon: String?,highIcon: String?,target: AnyObject?,action: String?) -> UIBarButtonItem? {
    
    let button = UIButton(type: .Custom)
    if icon == nil && highIcon == nil { return nil}
    button.setBackgroundImage(UIImage(named: icon!), forState: UIControlState.Normal)
    button.setBackgroundImage(UIImage(named: highIcon!), forState: UIControlState.Highlighted)
    button.frame = CGRectMake(0, 0, button.currentBackgroundImage!.size.width, button.currentBackgroundImage!.size.height)
    if target != nil && action != nil {
      button.addTarget(target, action: Selector(action!), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    return UIBarButtonItem(customView: button)
  }
}

//MARK: - String扩展
extension String {
    
    /**
    计算提供字体的长度尺寸
    
    - parameter size: 字体限制的尺寸
    - parameter font: 字体的样式
    
    - returns: 返回字体的尺寸
    */
    func size(box size: CGSize = CGSizeMake(CGFloat(MAXFLOAT), CGFloat(MAXFLOAT)), font: UIFont) -> CGSize {
        return (self as NSString).boundingRectWithSize(size, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil).size
    }
  
}


//MARK: - UIButton扩展
extension UIButton {
  
  /// 创建一个是否打勾的按钮
  class func checkBox(title title:String, target: AnyObject?, action: String?) -> UIButton {
    //创建一个按钮
    let chechBox = UIButton(type: .Custom)
    //设置打勾按钮的图片
    chechBox.setImage(UIImage.Asset.NewFeatureShareFalse.image, forState: UIControlState.Normal)
    chechBox.setImage(UIImage.Asset.NewFeatureShareTrue.image, forState: UIControlState.Selected)
    //获取按钮字体的rect大小
//    let size = String.sizeOfString(string: title, size: CGSizeMake(CGFloat(MAXFLOAT), CGFloat(MAXFLOAT)), font: chechBox.titleLabel!.font)
    let size = title.size(font: chechBox.titleLabel!.font)
    //按钮的bounds尺寸
    chechBox.bounds = CGRectMake(0, 0, size.width+50, size.height)
    //设置按钮的title
    chechBox.setTitle(title, forState: .Normal)
    //设置按钮的title的字体
    chechBox.titleLabel?.font = UIFont.systemFontOfSize(15)
    //按钮的默认状态为已打勾
    chechBox.selected = true
    //设置按钮图片右边的间隔（与title间的）
    chechBox.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20)
    //添加按钮的动作监听
    if action != nil {
      chechBox.addTarget(target, action: Selector(action!), forControlEvents: UIControlEvents.TouchUpInside)
    }
    //设置按钮字体的颜色
    chechBox.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
    
    return chechBox
    
  }
  
}

//MARK: - NSDate扩展
extension NSDate {
    
    /**
    是否为今天
    */
    func isToday() -> Bool {
        let calender = NSCalendar.currentCalendar()
        
        let unit: NSCalendarUnit = [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day]
        //获取当年时间的年月日
        let newDate = calender.components(unit, fromDate: NSDate())
        //获取创建微博时间的年月日
        let createDate = calender.components(unit, fromDate: self)
        
        return newDate.year == createDate.year && newDate.month == createDate.month && newDate.day == createDate.day
    }
    
    /**
    是否为今年
    */
    func isThisYear() -> Bool {
        let calender = NSCalendar.currentCalendar()
        
        //获取当年时间的年月日
        let newDate = calender.components(NSCalendarUnit.Year, fromDate: NSDate())
        //获取创建微博时间的年月日
        let createDate = calender.components(NSCalendarUnit.Year, fromDate: self)
        
        return newDate.year == createDate.year
    }
    
    /**
    是否为昨天
    */
    func isYesterday() -> Bool {
        return self.isYesterdayFromNewTime(NSDate())
    }
    
    /**
    self自身是否为new的前一天（昨天）
    */
    func isYesterdayFromNewTime(new: NSDate) -> Bool {
        
        let calender = NSCalendar.currentCalendar()
        
        let unit: NSCalendarUnit = [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second]
        //获取当年时间的年月日
        let newDate = calender.components(unit, fromDate: new)
        //获取创建微博时间的年月日
        let createDate = calender.components(unit, fromDate: self)
        
        guard newDate.year == createDate.year else {return false } //同一年
        
        
        var frontMonth = newDate.month - 1 //因为为同一年所以在这里去年的最后一天不算作昨天
        if newDate.month == 1 { //如果当前是1月
            frontMonth = 12
            newDate.year -= 1
            if newDate.day == 1 { //如果当前为一月的一号
                return false //去年的最后一天不算昨天
            }else {
                if newDate.day-1 == createDate.day {
                    return true
                }else{
                    return false
                }
            }
        }
        
        let frontMonthDayCount = thisMonthMaxDay(frontMonth, isLeapYear: isLeapYear(newDate.year))
        
        if newDate.day == 1 { //某月的第一天
            if createDate.day == frontMonthDayCount! { //为前一个月的最后一天 －> 是昨天
                return true
            }else{return false}
        }else { //某个月的1号后面几天
            if (newDate.day-1) == createDate.day {
                return true
            }else{
                return false
            }
        }

        
    }
    
    /**
    当年时间距离创建微博时间的年天月日小时分钟
    */
    func deltaWithNow() -> NSDateComponents {
        let calender = NSCalendar.currentCalendar()
        
        let unit: NSCalendarUnit = [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second]
        return calender.components(unit, fromDate: self, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))
    }
    
    /**
    是否为闰年
    */
    func isLeapYear(year: Int) -> Bool {
        if (year % 4 == 0 && year % 100 != 0) || year%400 == 0 { // print("\(year)是闰年")
            return true
        }else{ //print("\(year)是不是闰年")
            return false
        }
    }
    
    /**
    某月的总天数
    :param: isLeapYear 是否为闰年
    */
    func thisMonthMaxDay(month: Int, isLeapYear: Bool) -> Int? {
        if month > 12 || month < 1 { //月份输入错误超出限制
            return nil
        }
//        let monthOf31Day = [1,3,5,7,8,10,12]
        let monthOf30Day = [4,6,9,11]
        var dayOfFebruary = 28
        if isLeapYear { //闰年二月份的天数
            dayOfFebruary = 29
        }
        if month == 2 { //二月份的天数
            return dayOfFebruary
        }else if monthOf30Day.contains(month) { //30 days
            return 30
        }else {
            return 31
        }
    }
    
    
}


//MARK - UIClolor扩展
extension UIColor {
    /// 快速通过rgb创建一个颜色
    class func colorWithRGB(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        let color = UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
        return color
    }
}

//MARK: - Array扩展
extension Array {
    /// 随机返回数组中的成员
    var random: Element? {
        return self.count != 0 ? self[Int(arc4random_uniform(UInt32(self.count)))] : nil
    }
}

/**
*  将两个CGRect对应相加
*/
infix operator +++ { associativity left precedence 155 }

func +++(rect1: CGRect, rect2: CGRect) -> CGRect {
    let rectX:CGFloat = rect1.origin.x + rect2.origin.x
    let rectY:CGFloat = rect1.origin.y + rect2.origin.y
    let rectW:CGFloat = rect1.size.width + rect2.size.width
    let rectH:CGFloat = rect1.size.height + rect2.size.height
    return CGRectMake(rectX, rectY, rectW, rectH)
}

 /// 延迟操作
typealias Task = (cancel: Bool) -> Void

func delay(time: NSTimeInterval, task:()->()) -> Task? {

    func dispath_later(black:()->()) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), black)
    }
    
    var closure: dispatch_block_t? = task
    var result: Task?
    
    let delayClosure: Task = {
        cancel in
        if let internalClosure = closure {
            if cancel == false {
                dispatch_async(dispatch_get_main_queue(), internalClosure)
            }
        }
        closure = nil
        result = nil
    }
    
    result = delayClosure
    
    dispath_later { () -> () in
        if let delaytedClosure = result {
            delaytedClosure(cancel: false)
        }
    }
    
    return result
}

func cancel(task:Task?) {
    task?(cancel: true)
}


