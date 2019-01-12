import UIKit

func drawImage( _ context: CGContext ) {
    
    let size = (CGFloat(context.width), CGFloat(context.height))
    let insetWidth = size.0/8
    let insetHeight = size.1/8
    context.move(to: CGPoint(x: insetWidth, y: insetHeight))
    context.addLine(to: CGPoint(x: size.0-insetWidth, y: insetHeight))
    context.addLine(to: CGPoint(x: size.0-insetWidth, y: size.1-insetHeight))
    context.addLine(to: CGPoint(x: insetWidth, y: size.1-insetHeight))
    context.addLine(to: CGPoint(x: insetWidth, y: insetHeight))
    context.closePath()
    
    print( context.boundingBoxOfPath )
    
    context.drawPath(using: .eoFillStroke)

}

let size = (200, 200)
var context = Image.context(size: size, color: (1.0,1.0,1.0,1.0))
if let context = context {
    context.setFillColor(CGColor.from((0.0, 1.0, 0.0)))
    context.setStrokeColor(CGColor.from((1.0, 0.0, 0.0)))
    
    drawImage(context)

    // context.boundingBoxOfPath is invalid at the point where we draw the path.
    
    let result = Image.from( context: context )
}
