import UIKit

func controlPoint(from: CGPoint, to: CGPoint) -> CGPoint {
    let result = CGPoint(x: from.x + (to.x - from.x)/2.0 ,
                         y: from.y + (to.y - from.y)/2.0 )
    print( "controlPoint from (\(from) to \(to)) =  \(result)" )
    return result
}

func drawImage( _ context: CGContext ) {
    
    let size = (CGFloat(context.width), CGFloat(context.height))
    let insetWidth = size.0/8
    let insetHeight = size.1/8
    var point = CGPoint(x: insetWidth, y: insetHeight)
    context.move(to: point)
    
//    context.addLine(to: CGPoint(x: size.0-insetWidth, y: insetHeight))
//    context.addLine(to: CGPoint(x: size.0-insetWidth, y: size.1-insetHeight))
//    context.addLine(to: CGPoint(x: insetWidth, y: size.1-insetHeight))
//    context.addLine(to: CGPoint(x: insetWidth, y: insetHeight))

    var newPoint = CGPoint(x: size.0-insetWidth, y: insetHeight)
    context.addQuadCurve(to: newPoint, control: controlPoint(from: point, to: newPoint))

    point = newPoint
    newPoint = CGPoint(x: size.0-insetWidth, y: size.1-insetHeight)
    context.addQuadCurve(to: newPoint, control: controlPoint(from: point, to: newPoint))

    point = newPoint
    newPoint = CGPoint(x: insetWidth, y: size.1-insetHeight)
    context.addQuadCurve(to: newPoint, control: controlPoint(from: point, to: newPoint))

    point = newPoint
    newPoint = CGPoint(x: insetWidth, y: insetHeight)
    context.addQuadCurve(to: newPoint, control: controlPoint(from: point, to: newPoint))

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
