//: [Previous](@previous)

/*:
You can abstract away all the details by putting the generic boiler plate code into a class to hide it from your consumer.
 I created a *ImageRenderer* class, which now makes my code look dead simple.
 
1. Create a ImageRenderer instance.
2. Ask it to render a specific size image.
3. In the closure do your normal CGContext drawing.
 
 Done.  Class converts the drawing into a UIImage/NSImage depending on your platform.
*/

import Foundation
import CoreGraphics

// Let's draw something simple as a raster image

let size = (200, 200)
var image : Image?

let renderer = ImageRenderer()
image = renderer.raster(size: CGSize(width: size.0, height: size.1), drawing: { (context) in
    
    drawShape(context, size: size)
})

//: [Next](@next)
