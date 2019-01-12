//
//  Image.swift
//  Mazes
//
//  Created by J. Scott Tury on 7/22/18.
//  Copyright © 2018 self. All rights reserved.
//

#if os(macOS)
    import Cocoa
    public typealias Image = NSImage
    
    extension NSImage {
        
        public convenience init(cgImage: CGImage) {
            self.init(cgImage: cgImage, size: CGSize(width: cgImage.width, height: cgImage.height))
        }
        
        public var cgImage : CGImage? {
            get {
                var result : CGImage?
                if let cgImage = self.cgImage(forProposedRect: nil, context: nil, hints: nil) {
                    result = cgImage
                }
                return result
            }
        }
    }
    
#endif

#if os(iOS)
    import UIKit
    public typealias Image = UIImage

    extension UIImage {
        
        /// Mimicking the NSImage convienience initializer for iOS!
        public convenience init?(contentsOf url: URL) {
            guard let data = try? Data(contentsOf: url) else {
                return nil
            }
            self.init(data: data)
        }
    }
#endif

let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
let bitmapInfo:CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)

public extension Image {
    
    /// A simple helper method to allow us to convert a CGContext into a Image object directly.
    public static func from( context: CGContext ) -> Image? {
        // convert the CGContext into a CGImage.  If that's successful, then we can create an Image out of it.
        var result : Image? = nil
        if let cgImage = context.makeImage() {
            result = Image(cgImage: cgImage)
        }
        return result
    }
    
    /// Simple method for generating a CGContext, filled in with a particular background color.
    public static func context( size: (Int, Int), color:(CGFloat, CGFloat, CGFloat, CGFloat)) -> CGContext? {
        var result: CGContext?
        
        // Create a bitmap graphics context of the given size
        //
        let colorSpace = rgbColorSpace // CGColorSpaceCreateDeviceRGB()
        if let context = CGContext(data: nil, width: size.0, height: size.1, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue ) {
            
            // Draw the background color...
            context.setFillColor(red: color.0, green: color.1, blue: color.2, alpha: color.3)
            context.fill(CGRect(x: 0, y: 0, width: size.0, height: size.1))
            
            result = context
        }
        
        return result
    }
    
    /// Simple method for resizing a given image to a specific size...
    public func resize(size: (Int, Int) ) -> Image? {
        var result : Image? = nil
        
        if let cgImage = self.cgImage {
            if let context = Image.context(size: size, color: (1.0, 1.0, 1.0, 1.0)) {
                context.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.0, height: size.1))
                
                if let cgImage = context.makeImage() {
                    result = Image(cgImage: cgImage)
                }
            }
        }
        return result
    }

    /// Simple method for drawing a line segment in a image...
    public func drawHorizontalLine(at: CGFloat, color: (Double, Double, Double) = (0.0, 1.0, 0.0) ) -> Image? {
        var result : Image? = nil
        
        if let cgImage = self.cgImage {
            let size = (Int(self.size.width),Int(self.size.height))
            if let context = Image.context(size: size, color: (1.0, 1.0, 1.0, 1.0)) {
                context.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.0, height: size.1))
                
                context.setStrokeColor(CGColor.from(color))
                context.drawLineSegment(points: [(0, Int(at)), (size.0, Int(at))])
                
                if let cgImage = context.makeImage() {
                    result = Image(cgImage: cgImage)
                }
            }
        }
        return result
    }
    
    /// This method will allow you to crop an image to a specified Rect
    public func crop(_ rect: CGRect) -> Image? {
        var result : Image? = nil
        
        if let cgImage = self.cgImage {
            if let croppedImage = cgImage.cropping(to: rect) {
                result = Image(cgImage: croppedImage)
            }
        }
        
        return result
    }

    /// simple method to export an Image as a PNG to the user's document directory.
    public func export(name: String = "maze") -> Image? {
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        if let documentURL = URL(string: "\(name).png", relativeTo: URL(fileURLWithPath: documentsPath)) {
            self.output(documentURL)
        }
        
        return self
    }

    /// A simple method for outputting the image as a PNG image to a specified URL.
    public func output(_ url: URL) {
        let image = self
        #if os(macOS)
            if let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) {
                let bitmap = NSBitmapImageRep(cgImage: cgImage)
                #if swift(>=4.0)
                if let data = bitmap.representation(using: .png, properties: [:]) {
                    try? data.write(to: url)
                    print( url )
                }
                #else
                if let data = bitmap.representation(using: .PNG, properties: [:]) {
                    try? data.write(to: url)
                    print( url )
                }
                #endif
            }
        //        if let bits = imageRep.representations.first as? NSBitmapImageRep {
        //            if let data = bits.representation(using: .png, properties: [:]) {
        //                try? data.write(to: URL(fileURLWithPath: "./maze.png"))
        //            }
        //        }
        #endif
    }

}
