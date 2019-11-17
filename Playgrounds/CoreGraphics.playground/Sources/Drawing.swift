import Foundation
import CoreGraphics

/*:
 This function draws a shape into the CGContext provided.  We draw two different shapes,
 and a divider along the diagonal, so you can tell where things are located in the context.
 - parameter context: CGContext where we will draw our shape.
 - parameter size: A Tuple of two Int values specifying (width, height) of the context.
 */
public func drawShape( _ context: CGContext, size: (Int, Int) ) {
    // draw a simple shape!
    // 0,0 is in the lower left
    context.clear(CGRect(origin: CGPoint(x: 0, y: 0),
                         size: CGSize(width: size.0, height: size.1)))
    
    //: define the colors for black and red
    let black   = CGColor(srgbRed: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    let red     = CGColor(srgbRed: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)

    //: Set the stroke to black, and the fill color to red.
    context.setStrokeColor(black)
    context.setFillColor(red)
    
    //: draw a bow tie anchored at 0,0 (bottom left)
    context.move(to: CGPoint(x: 0, y: 0))
    context.addLine(to: CGPoint(x: size.0/2-1, y: size.1/2-1))
    context.addLine(to: CGPoint(x: size.0/2-1, y: 0))
    context.addLine(to: CGPoint(x: 0, y: size.1/2-1))
    context.addLine(to: CGPoint(x: 0, y: 0))
    
    // Now tell the context to stroke the path, and fill in the content
    context.drawPath(using: .fillStroke)
    
    //: Create constants for green and blue
    let green   = CGColor(srgbRed: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
    let blue    = CGColor(srgbRed: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)

    // Set new stroke and fill colors.
    context.setStrokeColor(blue)
    context.setFillColor(green)

    // Draw an elipse or circle - depending the size we were given.
    context.addEllipse(in: CGRect(origin: CGPoint(x: Int(Float(size.0)*0.5), y: Int(Float(size.1)*0.5)),
                                  size: CGSize(width: Int(Float(size.0)*0.5)-1, height: Int(Float(size.1)*0.5)-1)))
    context.drawPath(using: .fillStroke)

    //:  Now draw a diagonal path from 0, 0 to the end of the context.
    context.setStrokeColor(black)
    context.move(to: CGPoint(x: size.0, y: 0))
    context.addLine(to: CGPoint(x: 0, y: size.1))
    
    // Only stroke the path here.
    context.drawPath(using: .stroke)
}
