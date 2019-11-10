import Foundation
import CoreGraphics

/**
 Simple method for generating a CGContext, filled in with a particular background color.

   - parameter size: (Int, Int) of what size image you want to create.
   - parameter color: (CGFlloat, CGFloat, CGFloat, CGFloat) specifying the color you want filled into the image when it's created.

 - returns: A new CGContext if the bitmap was created.
*/
func context( size: (Int, Int), color:(CGFloat, CGFloat, CGFloat, CGFloat)) -> CGContext? {
   var result: CGContext?
   
   // Create a bitmap graphics context of the given size
   //
   let colorSpace = CGColorSpaceCreateDeviceRGB()
   if let context = CGContext(data: nil, width: size.0, height: size.1, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue).rawValue ) {
       
       // Draw the background color...
       context.setFillColor(red: color.0, green: color.1, blue: color.2, alpha: color.3)
       context.fill(CGRect(x: 0, y: 0, width: size.0, height: size.1))
       
       result = context
   }
   
   return result
}


// Lets draw something simple as a raster image

let size = (200, 200)
var image : Image?

if let context = context(size: size, color: (1.0, 1.0, 1.0, 0.0)) {
    
    // draw a simple shape!
    // 0,0 is in the lower left
    let color = (1.0, 0.0, 0.0, 1.0)
    context.setFillColor(CGColor.from(color))
    context.beginPath()
    context.move(to: CGPoint(x: 0, y: 0))
    context.addLine(to: CGPoint(x: size.0/2, y: size.1/2))
    context.addLine(to: CGPoint(x: size.0/2, y: 0))
    context.addLine(to: CGPoint(x: 0, y: size.1/2))
    context.addLine(to: CGPoint(x: 0, y: 0))
    context.closePath()
    context.drawPath(using: .fillStroke)
    
    if let cgImage = context.makeImage() {
        image = Image(cgImage: cgImage)
    }
}


//: [Next](@next)
