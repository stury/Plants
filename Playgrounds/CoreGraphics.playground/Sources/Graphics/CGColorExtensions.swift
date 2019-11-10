import Foundation
import CoreGraphics
#if os(iOS)
    import UIKit
#endif

extension CGColor {
    
    /**
    Simple static method for converting between a triplet RGB of Double values into a CGColor object.  This particular method does not create transparent CGColor values.  They're all opaque.
     
     - parameter rgbColor: A triplet or Double values specifying the RGB values of a color you want.
     */
    static public func from(_ rgbColor: (Double, Double, Double)) -> CGColor {
        #if os(macOS)
        return CGColor(red: CGFloat(rgbColor.0), green: CGFloat(rgbColor.1), blue: CGFloat(rgbColor.2), alpha: 1.0)
        #else
        let color = UIColor(red: CGFloat(rgbColor.0), green: CGFloat(rgbColor.1), blue: CGFloat(rgbColor.2), alpha: 1.0)
        return color.cgColor
        #endif
    }

    /**
    Simple static method for converting between a triplet RGBA of Double values into a CGColor object.  This particular method does not create transparent CGColor values.  They're all opaque.
     
     - parameter rgbaColor: A triplet or Double values specifying the RGB values of a color you want.
     */
    static public func from(_ rgbaColor: (Double, Double, Double, Double)) -> CGColor {
        #if os(macOS)
        return CGColor(red: CGFloat(rgbaColor.0), green: CGFloat(rgbaColor.1), blue: CGFloat(rgbaColor.2), alpha: CGFloat(rgbaColor.3))
        #else
        let color = UIColor(red: CGFloat(rgbaColor.0), green: CGFloat(rgbaColor.1), blue: CGFloat(rgbaColor.2), alpha: CGFloat(rgbaColor.3))
        return color.cgColor
        #endif
    }
}
