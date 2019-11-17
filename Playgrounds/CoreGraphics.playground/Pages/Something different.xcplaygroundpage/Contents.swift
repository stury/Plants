//: [Previous](@previous)

/*:
 This page shows an example of drawing something a bit more colorful, and creating an image out of it.  I can show this same code in Python if there's interest.
 */

import Foundation
import CoreGraphics

let size = (800, 800)
var image : Image?

func radians( _ degrees:Double ) -> Double {
    return degrees * (Double.pi/180.0)
}

let renderer = ImageRenderer((0.0, 0.0, 0.0, 1.0))
image = renderer.raster(size: CGSize(width: size.0, height: size.1), drawing: { (context) in
    
    //colors = ['red', 'purple', 'blue', 'green', 'orange', 'yellow']
    //t = turtle.Pen()
    //turtle.bgcolor('black')
    //for x in range(360):
    //    t.pencolor(colors[x%6])
    //    t.width(x/100 + 1)
    //    t.forward(x)
    //    t.left(59)
    let colors = [CGColor.from((1.0, 0.0, 0.0, 1.0)),  // #FF0000
                  CGColor.from((0.5, 0.0, 0.5, 1.0)),  // #800080
                  CGColor.from((0.0, 0.0, 1.0, 1.0)),  // #0000FF
                  CGColor.from((0.0, 1.0, 0.0, 1.0)),  // #00FF00
                  CGColor.from((1.0, 0.7, 0.0, 1.0)),  // #FFA500
                  CGColor.from((1.0, 1.0, 0.0, 1.0))]  // #FFFF00
    var currentLocation = CGPoint(x: size.0/2, y: size.1/2)
    var direction = 0.0
    
    for x in 0...360 {
        context.setStrokeColor(colors[x%colors.count])
        context.setLineWidth(CGFloat(x/100+1))
        let newLocation = CGPoint( x: Double(currentLocation.x)+Double(x)*cos(radians(direction)), y: Double(currentLocation.y)+Double(x)*sin(radians(direction)))
        context.move(to: currentLocation)
        context.addLine(to: newLocation)
        context.strokePath()
        
        currentLocation = newLocation
        direction = (direction + 59.0)
        if direction > 360 {
            direction -= 360
        }
    }

})


//: [Next](@next)
