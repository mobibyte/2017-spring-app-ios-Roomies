//
//  pickerViewTableViewCell.swift
//  FoodPin
//
//  Created by Mary Huerta on 10/31/16.
//  Copyright © 2016 Mary Huerta. All rights reserved.
//

import Foundation
import UIKit

class PickerViewTableViewCell: UITableViewCell {
    var isObserving = false;
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet var categoryPicker: UIPickerView!
    
    
    
    
    class var expandedHeight: CGFloat { get { return 200 } }
    class var defaultHeight: CGFloat  { get { return 44  } }
    
    
    func checkHeight() {
        print("Checking height \(frame.size.height)")
        categoryPicker.isHidden = (frame.size.height < PickerViewTableViewCell.expandedHeight)
    }
    
    func watchFrameChanges() {
        if !isObserving {
            addObserver(self, forKeyPath: "frame", options: [NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.initial], context: nil)
            isObserving = true;
        }
    }
    
    func ignoreFrameChanges() {
        if isObserving {
            removeObserver(self, forKeyPath: "frame")
            isObserving = false;
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" {
            checkHeight()
        }
    }
}


