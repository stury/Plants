//
//  Limit.swift
//  Plant
//
//  Created by Scott Tury on 12/2/18.
//  Copyright © 2018 Scott Tury. All rights reserved.
//

import Foundation

#if os(macOS)
import Cocoa
#elseif os(iOS)
import UIKit
#endif

/// This class is used to keep track of limit extremes of where drawing has occurred in the image.
public class Limit {
    
    public var left : CGFloat = 0.0
    public var right: CGFloat = 0.0
    public var top : CGFloat = 0.0
    public var bottom : CGFloat = 0.0
    
    public var height : CGFloat {
        get {
            return (bottom - top)
        }
    }

    public var width : CGFloat {
        get {
            return (right - left)
        }
    }

    // resets the limit values based on an Int pair for (width, height).
    public func reset(_ imageSize: (Int, Int)) {
        left  = CGFloat(imageSize.0)
        right = 0.0
        top = CGFloat(imageSize.1)
        bottom = 0.0
    }
    
    // resets the limit values based on an CGFloat pair for (width, height).
    public func reset(_ imageSize: (CGFloat, CGFloat)) {
        reset( (Int(imageSize.0), Int(imageSize.1)) )
    }
    
    // resets the limit values based on an Double pair for (width, height).
    public func reset(_ imageSize: (Double, Double)) {
        reset( (Int(imageSize.0), Int(imageSize.1)) )
    }
    
    
    /// Calculate the limits of the actual drawing, so we might be able to crop the image at the emd.
    public func update(_ point: CGPoint ) {
        if point.x < left {
            left = point.x
        }
        if point.x > right {
            right = point.x
        }
        
        if point.y < top {
            top = point.y
        }
        if point.y > bottom {
            bottom = point.y
        }
    }
    
    public func update(_ point: (CGFloat, CGFloat) ) {
        update( CGPoint(x: point.0, y: point.1) )
    }
    
    public func update(_ point: (Double, Double) ) {
        update( CGPoint(x: point.0, y: point.1) )
    }
    
    // method to test if the drawn image fits within the size of the image we created.
    public func within(_ size: (Int, Int) ) -> Bool {
        var result = false
        
        if left >= 0 && right <= CGFloat(size.0) &&
            top >= 0 && bottom <= CGFloat(size.1) {
            result = true
        }
        
        return result
    }
}
