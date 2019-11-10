//: [Previous](@previous)

#if os(iOS)
import Foundation
import UIKit
import UIKit.UIGraphicsRendererSubclass

// Lets draw something simple as a raster image

let size = (200, 200)
var image : UIImage?

// or UIGraphicsPDFRenderer
let renderer = UIGraphicsImageRenderer(size: CGSize(width: 200, height: 200))
image = renderer.image { (uiGraphicsContext) in
    // draw a simple shape!
    // 0,0 is in the lower left
    let context = uiGraphicsContext.cgContext
    context.setFillColor(CGColor.from((1.0, 0.0, 0.0, 1.0)))
    context.beginPath()
    context.move(to: CGPoint(x: 0, y: 0))
    context.addLine(to: CGPoint(x: size.0/2, y: size.1/2))
    context.addLine(to: CGPoint(x: size.0/2, y: 0))
    context.addLine(to: CGPoint(x: 0, y: size.1/2))
    context.addLine(to: CGPoint(x: 0, y: 0))
    context.closePath()
    context.drawPath(using: .fillStroke)
}
#endif

//: [Next](@next)
