//
//  UIColorExtension.swift
//  Roomies
//
//  Created by Cameron Moreau on 3/22/17.
//  Copyright © 2017 Mobi. All rights reserved.
//

import UIKit

extension UIColor {
    
    static var chatBlue: UIColor { return UIColor(netHex: 0x6095F2) }
    static var chatGray: UIColor { return UIColor(netHex: 0xF5F8FE) }
    
    static var primaryText: UIColor { return UIColor(netHex: 0x484644) }
    
    // MARK: - Extension Functions
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        let ctx = UIGraphicsGetCurrentContext()
        self.setFill()
        ctx?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
