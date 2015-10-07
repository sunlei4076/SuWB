//
//  ComposeToolbar.swift
//  SuWB
//
//  Created by 王文臻 on 15/9/28.
//  Copyright © 2015年 王文臻. All rights reserved.
//

import UIKit

/**
发微博工具栏的样式

- Camera:  相机
- Picture: 照片
- Mention: 提到 @
- Trend:   潮流话题 ＃。。。。＃
- Emotion: 表情 emotion
*/
@objc enum ComposeToolbarButtonType: Int {
    /**
    *  相机
    */
    case Camera = 100
    /**
    *  照片
    */
    case Picture = 101
    /**
    *  提到 @
    */
    case Mention = 102
    /**
    *  潮流话题 ＃。。。。＃
    */
    case Trend = 103
    /**
    *  表情 emotion
    */
    case Emotion = 104
    
    case None = 10000
}


@objc protocol ComposeToolbarDelegate {
    func composeToolbar(composeToolbar: ComposeToolbar, didClickedButton buttonType: ComposeToolbarButtonType)
}
class ComposeToolbar: UIView {

    weak var delegate: ComposeToolbarDelegate?
    
    
    private func addButtonWithIcon(icon: UIImage,highIcon: UIImage,type: ComposeToolbarButtonType) {
        let btn = UIButton()
        btn.tag = type.rawValue
        btn.setImage(icon, forState: UIControlState.Normal)
        btn.setImage(highIcon, forState: UIControlState.Highlighted)
        btn.addTarget(self, action: "composeToolbarButtonDidClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(btn)
    }
    
    
    func composeToolbarButtonDidClicked(button: UIButton) {
        var type: ComposeToolbarButtonType!

            switch button.tag {
                case 100: type = ComposeToolbarButtonType.Camera
                case 101: type = ComposeToolbarButtonType.Picture
                case 102: type = ComposeToolbarButtonType.Mention
                case 103: type = ComposeToolbarButtonType.Trend
                case 104: type = ComposeToolbarButtonType.Emotion
                default : type = ComposeToolbarButtonType.None
            }

        delegate?.composeToolbar(self, didClickedButton: type)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame.size.height = 44
        let buttonW:CGFloat = self.frame.size.width / CGFloat(subviews.count)
        let buttonH:CGFloat = 44
        let buttonY:CGFloat = 0
        for index in 0..<subviews.count {
            let button = subviews[index]
            let buttonX:CGFloat = CGFloat(index) * buttonW
            button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH)
        }
    }
    
    //MARK: -  初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        //设置背景
        self.backgroundColor = UIColor(patternImage: UIImage.Asset.ComposeToolbarBackgroundOs7.image)
        
        //添加按钮
        addButtonWithIcon(UIImage.Asset.ComposeCamerabuttonBackgroundOs7.image, highIcon: UIImage.Asset.ComposeCamerabuttonBackgroundHighlightedOs7.image, type: .Camera)
        addButtonWithIcon(UIImage.Asset.ComposeToolbarPictureOs7.image, highIcon: UIImage.Asset.ComposeToolbarPictureHighlightedOs7.image, type: .Picture)
        addButtonWithIcon(UIImage.Asset.ComposeMentionbuttonBackgroundOs7.image, highIcon: UIImage.Asset.ComposeMentionbuttonBackgroundHighlightedOs7.image, type: .Mention)
        addButtonWithIcon(UIImage.Asset.ComposeTrendbuttonBackgroundOs7.image, highIcon: UIImage.Asset.ComposeTrendbuttonBackgroundHighlightedOs7.image, type: .Trend)
        addButtonWithIcon(UIImage.Asset.ComposeEmoticonbuttonBackgroundOs7.image, highIcon: UIImage.Asset.ComposeEmoticonbuttonBackgroundHighlightedOs7.image, type: .Emotion)

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
