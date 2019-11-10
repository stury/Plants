//: [Previous](@previous)

import Foundation
import CoreGraphics

// Lets draw something simple as a raster image

let size = (200, 200)
var image : Image?

let renderer = ImageRenderer()
image = renderer.raster(size: CGSize(width: size.0, height: size.1), drawing: { (context) in
    
    // draw a simple shape!
    // 0,0 is in the lower left
    context.beginPath()
    context.setFillColor(CGColor.from((1.0, 0.0, 0.0, 1.0)))
    context.move(to: CGPoint(x: 0, y: 0))
    context.addLine(to: CGPoint(x: size.0/2, y: size.1/2))
    context.addLine(to: CGPoint(x: size.0/2, y: 0))
    context.addLine(to: CGPoint(x: 0, y: size.1/2))
    context.addLine(to: CGPoint(x: 0, y: 0))
    context.closePath()
    
    context.drawPath(using: .fillStroke)
})

//: [Next](@next)
