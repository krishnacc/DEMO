//
//  TextField.swift
//  DashBoardApp
//
//  Created by darshini on 3/24/17.
//  Copyright © 2017 zaptech. All rights reserved.
//
//new
import UIKit

class TextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 5);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}
