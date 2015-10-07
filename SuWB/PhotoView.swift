//
//  PhotoView.swift
//  SuWB
//
//  Created by 王文臻 on 15/9/8.
//  Copyright © 2015年 王文臻. All rights reserved.
//

import UIKit

class PhotoView: UIImageView {

    var photo: Photo? {
        didSet{
            if self.photo != oldValue {
                self.isGIF = self.photo!.thumbnail_pic!.lowercaseString.hasSuffix("gif") //是gif图片
                self.sd_setImageWithURL(NSURL(string: photo!.thumbnail_pic!)!, placeholderImage: UIImage.Asset.TimelineImagePlaceholder.image)
            }
        }
    }
    
    private var isGIF = false {
        didSet{
            giftView.hidden = !isGIF
        }
    }
    
    private var giftView:UIImageView!
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.userInteractionEnabled = true

        //让照片填充imageView，把超出的部分剪切掉
        self.contentMode = UIViewContentMode.ScaleAspectFill
        self.clipsToBounds = true
        
        let gifView = UIImageView(image: UIImage.Asset.TimelineImageGif.image)
        gifView.hidden = true
        gifView.frame = CGRectMake(self.frame.size.width - 27, self.frame.height-20, 27, 20)
        self.giftView = gifView
        
        self.frame.size = CGSizeMake(70, 70)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
