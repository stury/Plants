//: [Previous](@previous)

/*:
As of  iOS/tvOS 10, there's a newer way to draw into a context.  Use the new *UIGraphicsRenderer* class.
You will need to use either *UIGraphicsImageRenderer* or *UIGraphicsPDFRenderer* depending if you want
a rasterized image, or a vector image respectfully.
 
There are a few issues with using it:
1. It's iOS/tvOS specific.  (No other platforms are suported!)
2. There is no macOS equivalent.
3. Biut it's pretty simple to use.
4. iOS's coordinate system is flipped from CGGraphics and macOS.  You'll need to aply a transform in order to draw correctly.
 
 It's easy to use though:
 1. Create a UIGraphicsImageRenderer with the size you want.
 2. use the `image` method to create the imae you want.
 3. In the closure provided, get the cgContext, and apply a transform to flip the space.
 4. Draw like normal on the cgContext.
 5. Conversion to UIImage handled for you by Apple!
*/

#if os(iOS)
import Foundation
import UIKit
import UIKit.UIGraphicsRendererSubclass

// Lets draw something simple as a raster image

let size = (200, 200)
var image : UIImage?

//: 1. Create a UIGraphicsImageRenderer with the size you want.
let renderer = UIGraphicsImageRenderer(size: CGSize(width: size.0, height: size.1))
//: 2. use the `image` method to create the imae you want.
image = renderer.image { (uiGraphicsContext) in
    
//: 3. In the closure provided, get the cgContext, and apply a transform to flip the space.
    
    let context = uiGraphicsContext.cgContext

    context.saveGState()
    
    /*:
     It turns out that in UIKit, a translation matrix has been applied to flip the drawing layer.
     So in order to fix it, we need to add another translation to flip the coordinate system again.
     */
    context.saveGState()
    context.translateBy(x: 0, y: CGFloat(size.1))
    context.scaleBy(x: 1.0, y: -1.0)

    // Now 0,0 is in the lower left

//: 4. Draw like normal on the cgContext.
//: Let's draw our image.  Look in *Sources/Drawing.swift* for the code!
    
    drawShape(context, size: size)

    context.restoreGState()

//: 5. Conversion to UIImage handled for you by Apple!
    
}
#endif

//: [Next](@next)
