
//
//  Photo.swift
//  SuWB
//
//  Created by 王文臻 on 15/9/7.
//  Copyright © 2015年 王文臻. All rights reserved.
//

import UIKit

class Photo: NSObject {
    
    var thumbnail_pic: String? {
        didSet{
            if self.thumbnail_pic != oldValue {
                self.square = self.thumbnail_pic!.stringByReplacingOccurrencesOfString("thumbnail", withString: "square")
                self.bmiddle = self.thumbnail_pic!.stringByReplacingOccurrencesOfString("thumbnail", withString: "bmiddle")
            }
        }
    }
    
    var square: String?
    
    var bmiddle: String?

}
