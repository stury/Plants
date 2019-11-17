/*:
 When using CoreGraphics, you typically want to do the following:
 1. Create a context to draw into.
 2. Do the drawing you want.
 3. Create an image from the context.
 */

import Foundation
import CoreGraphics

/*:
 This is a simple method for generating a CGContext, filled in with a particular background color.

   - parameter size: (Int, Int) of what size image you want to create.
   - parameter color: (CGFlloat, CGFloat, CGFloat, CGFloat) specifying the color you want filled into the image when it's created.

 - returns: A new CGContext if the bitmap was created.
*/
func context( size: (Int, Int), color:(CGFloat, CGFloat, CGFloat, CGFloat)) -> CGContext? {
   var result: CGContext?
   
//: Create a bitmap graphics context of the given size
   let colorSpace = CGColorSpaceCreateDeviceRGB()
   if let context = CGContext(data: nil, width: size.0, height: size.1, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue).rawValue ) {
       
       // Draw the background color...
       context.setFillColor(red: color.0, green: color.1, blue: color.2, alpha: color.3)
       context.fill(CGRect(x: 0, y: 0, width: size.0, height: size.1))
       
       result = context
   }
   
   return result
}


let size = (200, 200)
var image : Image?

let transparentColor : (CGFloat, CGFloat, CGFloat, CGFloat) = (1.0, 1.0, 1.0, 0.0)

//: 1. create a context to draw into.  (See method above!)
if let context = context(size: size, color: transparentColor) {
    
//: 2. Draw our image in the CGContext.  Look in *Sources/Drawing.swift* to see the code!
    drawShape(context, size: size)
    
//: 3. Create a CGImage out of our context.  We can use this to instantiate a UIImage or a NSImage!
    if let cgImage = context.makeImage() {
        image = Image(cgImage: cgImage)
    }
}


//: [Next](@next)
