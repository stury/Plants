//
//  Turtle.swift
//
//  simple implementation of a Turtle rule based drawing system.
// This is an example of a DOL-system.  It is deterministic and context free.
//
//  Created by Scott Tury on 12/2/18.
//  Copyright © 2018 Scott Tury. All rights reserved.
//

import Foundation

enum TurtleDrawingMode {
    /// Draw each segent as if it were the only piece to draw.
    case discrete
    /// Draw each piece as a part of a larger path.
    case path
}

/// A structure to keep track of the position and heading of the turtle.
struct TurtleState {
    /// Position specified as (x, y) of the current turtle cursor
    let position: (Double, Double)
    /// Angle of direction for the turtle (specified in degrees, not radians)
    let heading: Double
    
    var radians: Double {
        get {
            return heading * (Double.pi/180.0)
        }
    }
    
    /// This function will return the current heading (in degrees) by adding the supplied modifier value (in degrees).
    /// It also checks to make sure the result is between 0 and 360.
    func modifiedHeading(_ modifier: Double ) -> Double {
        var result = heading + modifier
        if result > 360.0 {
            result -= 360.0
        }
        else if result < 0 {
            result += 360.0
        }
        return result
    }
    
    let drawingMode: TurtleDrawingMode
}

// MARK: -
/// A simple implementation of a Turtle graphics context.  You give it a series of Rules to follow,
/// and an iteration to execute, and it will draw the result.
class Turtle {
    
    static public let colorAmberMonitor = ( 0.7098, 0.3961, 0.1137 ) // amber
    static public let colorGreenMonitor = (0.2, 0.70, 0.2) // green display
    
    static public let colorBackgroundWhite = (CGFloat(1.0), CGFloat(1.0), CGFloat(1.0), CGFloat(1.0))
    static public let colorBackgroundBlack = (CGFloat(0.0), CGFloat(0.0), CGFloat(0.0), CGFloat(1.0))
    
    
    /// This class instance keeps track of where we're drawing, such that we can use it to calculate the correct image size to create.
    public var limits : Limit = Limit()
    
    /// The Rules for drawing the image.
    public var rules : Rules = Rules(initiator: "F-F-F-F", rules: ["F" : "F-F+F+FF-F-F+F"])
    
    /// Background color + alpha to use for the background of the image.  (Should easilly be able to change to having a transparent background.)
    public var backgroundColor : (CGFloat, CGFloat, CGFloat, CGFloat) = colorBackgroundBlack
    /// Class to use for generating the Images
    public var renderer = ImageRenderer()
    /// Value to use for drawing the image.
    public var color = colorAmberMonitor
    /// Value for the border around the image being drawn.  Number of pixels to have around the drawn image.
    public var border : CGFloat = 50.0
    
    /// If you know where the start location should be, you can use this property to set the start location of each iteration drawing.
    /// typically it should be nil, and you should let the methods use this.
    private var start:CGPoint? = nil
    
    private var stack : [TurtleState] = [TurtleState]()
    
//    public var colorBlock : ((Int)->(Double, Double, Double))? = (iteration:Int)->(Double, Double, Double) {
//        var result : (Double, Double, Double)
//        if iteration % 2 == 0 {
//            result =  ( 0.7098, 0.3961, 0.1137 ) // amber
//        }
//        else {
//            result = (0.2, 1.0, 0.2) // green displayz
//        }
//        return result
//    }
    
    
    public var context : CGContext?
    
    private var length : Double = 1.0
    
    /// This method draws from the start position to the end position on the graphics context.
    func drawSegment(_ start: TurtleState, end: TurtleState ) {
        limits.update(end.position)
        
        context?.setStrokeColor(CGColor.from(color))
        if end.drawingMode == .path {
            context?.drawLineSegment(points: [start.position, end.position], discrete: false)
        }
        else {
            context?.drawLineSegment(points: [start.position, end.position])
        }
    }
    
    public func process( _ character: Character, state: TurtleState ) -> TurtleState {
        var result = state

        switch character {
            
        case "f":
            // Move forward without drawing a line...
            let headingRad = state.radians
            result = TurtleState(position: (state.position.0+length*cos(headingRad), state.position.1+length*sin(headingRad)), heading: state.heading, drawingMode: state.drawingMode )
            limits.update(state.position)
            
        case "-", "−":
            // turn right by rule.angle  (clockwise)
            // turtle state changes to (x, y, direction-angle)
            result = TurtleState(position: (state.position.0, state.position.1), heading: state.modifiedHeading(-rules.angle), drawingMode: state.drawingMode )
            
        case "+":
            // turn left by rule.angle (counter clockwise)
            // turtle state changes to (x, y, direction+angle)
            result = TurtleState(position: (state.position.0, state.position.1), heading: state.modifiedHeading(rules.angle), drawingMode: state.drawingMode )

        // In order to support 3D drawing of these, I'll have to implement the following:
        // & ^ \ / |
            
        // Plants need branching, so that's what these rules are for:  Keeping track of the branches. (Push TurtleState onto and off of a stack.)
        case "[":
            // Push the state onto a stack.
            stack.append(state)
            
        case "]":
            // pop the top item off the stack.
            if let priorState = stack.popLast() {
                result = priorState
            }
            
        case "{":
            // Draw needs to switch to using paths
            result = TurtleState(position: state.position, heading: state.heading, drawingMode: .path )
            context?.move(to: CGPoint(x:CGFloat(result.position.0), y:CGFloat(result.position.1)))
            context?.setFillColor(CGColor.from(color))
            
        case "}":
            // switch back to default drawing.
            result = TurtleState(position: state.position, heading: state.heading, drawingMode: .discrete )
            // need to also close the Path, and stroke/fill it.
            context?.drawPath(using: .fillStroke)
            
        default:
            if let scalar = Unicode.Scalar(String(character)) {
                if  CharacterSet.uppercaseLetters.contains(scalar)  {
                    // Move forward drawing a line...  turtle state changes to (x', y', angle') where
                    // x' = x+ d cos angle
                    // y' = y + d sin angle
                    // line segment between (x, y) and (x', y') is drawn
                    let headingRad = state.radians
                    let newState = TurtleState(position: (state.position.0+length*cos(headingRad), state.position.1+length*sin(headingRad)), heading: state.heading, drawingMode: state.drawingMode )
                    // draw the line segment!
                    drawSegment(state, end: newState)
                    // set new state!
                    result = newState
                }
                else {
                    #if DEBUG
                    print("WARNING: Unimplemented rule for character: \(character)")
                    #endif
                }
            }
            else {
                #if DEBUG
                print("WARNING: Unimplemented rule for character: \(character)")
                #endif
            }
        }

        return result
    }
    
    private func draw( context: CGContext, imageSize: CGSize, rule: String ) {
        self.context = context
        
        context.setLineWidth(CGFloat(2.0))
        context.setLineJoin(CGLineJoin.round)

        let startLocation : CGPoint
        if let start = start {
            startLocation = start
        }
        else {
            startLocation = CGPoint(x: floor(Double(imageSize.width)/2.0), y: floor(Double(imageSize.height)/3.0))
            start = startLocation
        }
        
        var state = TurtleState(position: (Double(startLocation.x), Double(startLocation.y)), heading: rules.initialDirection, drawingMode: .discrete )
        
        // Let's build up the image...
        
        context.move(to: startLocation)
        //print( "originatingPosition = \(currentPosition.position)" )
        limits.update(startLocation)
        
        for offset in 0 ..< rule.count {
            let character = rule[String.Index(utf16Offset: offset, in: rule)]
            //print( "processing character: \(character)" )
            state = process( character, state: state )
        }

        self.context = nil
    }
    
    /// Method for drawing the rule set at a particular iteration point.
    public func draw(_ iteration: Int, imageSize: (Int, Int) = (20, 20) ) -> Image? {
        var result : Image?
        
        let rule = rules.calculateRules(for: iteration)
        
        length = rules.calculateLength(for: iteration)
        limits.reset( imageSize )
        
        renderer.backgroundColor = backgroundColor
        result = renderer.raster(size: CGSize(width: imageSize.0, height: imageSize.1)) { [weak self] (context) in
            self?.draw( context: context, imageSize: CGSize(width: imageSize.0, height: imageSize.1), rule:rule)
        }
        
        // Test to see if the image is within the bounds of the imageSize.  If not,
        // recalculate the imageSize we  should use, and the starting position, and return that!
        if !limits.within((imageSize.0, imageSize.1)) {
            // recalculate the image size, and the start position, then rerun this method...
            
            let newImageSize = (Int(limits.width+2*border), Int(limits.height+2*border))
            if let start = start {
                self.start = CGPoint(x: start.x-limits.left+border, y:start.y-limits.top+border )
                result = draw( iteration, imageSize: newImageSize )
            }
        }

        #if DEBUG
        print( "limit: left:\(limits.left), right:\(limits.right), top:\(limits.top), bottom:\(limits.bottom)" )
        // I could flag that this image isn't big enough, if the values fall outside of the current imageSize!
        #endif
        start = nil
        
        return result
    }
}

// MARK: -
extension Turtle {
    
    // This method provides a cropped version the image.  This will allow us to automate having multikle images imposed onto the same image so you can see their growth...
    public func drawCropped( _ iterations: Int, imageSize: (Int, Int) = (20, 20)) -> Image? {
        var result : Image?
        
        if let image = draw(iterations, imageSize: imageSize) {
            // Note, since we drew the image upside down, the top and bottom are reversed...
//            if let cropImage = image.crop(CGRect(x: limits.left-border/2, y: 0.0, width: limits.width + border, height: image.size.height)) {
            if let cropImage = image.crop(CGRect(x: limits.left-border/2, y: image.size.height-(limits.bottom+border/2), width: limits.width + border, height: limits.height+border)) {
                result = cropImage

            }
        }
        
        return result
    }
    
    /// This method creates cropped iteration versions of the plant.  This means you give an iteration number,
    /// and then it generates each successive iteration into an Image.  It then adds all the images into an
    /// image array to pass back to the caller.
    public func drawIterative(_ range: Range<Int>, crop: Bool, colors: [(Double, Double, Double)] = [Turtle.colorAmberMonitor, Turtle.colorGreenMonitor] ) -> [Image] {
        var result : [Image] = [Image]()
        
        start = nil
        
        //        let original = rules
        //        let colors = [Turtle.colorAmberMonitor, Turtle.colorGreenMonitor]
        if let min = range.min(), let max = range.max() {
            let iterations = max - min
            color = colors[iterations%colors.count]
            let lastIterationImage : Image?
            if crop {
                lastIterationImage = drawCropped(iterations)
            }
            else {
                lastIterationImage = draw(iterations)
            }
            
            let size : (Int, Int)
            if let image = lastIterationImage {
                size = ( Int(floor(image.size.width)), Int(floor(image.size.height)))
            }
            else {
                // Should not get here!
                size = (20, 20)
            }
            
            for i in min..<max {
                //print( "Plant for iteration \(i): \(plant.calculateRules(i))" )
                var image : Image?
                
                //            if i > 0 {
                //                rules = Rules(initiator: original.initiator, rules: original.rules, angle: original.angle, length: original.length/(2.0*Double(i)))
                //            }
                color = colors[i%colors.count]
                
                if crop {
                    image = drawCropped(i, imageSize: size)
                }
                else {
                    image = draw(i, imageSize: size)
                }
                
                if let image = image {
                    result.append(image)
                }
            }
            //        rules = original
            
            if let image = lastIterationImage {
                result.append(image)
            }
        }
        
        color = colors[0]
        
        return result
    }

    // This method creates iterations versions of the plant.  Then assemples the images all into one image to return to the caller.
    public func drawIterativeGrowth(_ range: Range<Int>, colors: [(Double, Double, Double)] = [Turtle.colorAmberMonitor, Turtle.colorGreenMonitor], mode: ImageHorizontalMode = .bottom ) -> Image? {
        var result : Image? = nil
        let curves = drawIterative(range, crop: true, colors: colors)
        
        start = nil
        
        result = curves.arrangedHorizontally(backgroundColor:backgroundColor, mode: mode)
        
        return result
    }

    // This method creates iterations versions of the plant.  Then assemples the images all into one image to return to the caller.
    public func drawIterativeGrowth(_ iterations: Int, colors: [(Double, Double, Double)] = [Turtle.colorAmberMonitor, Turtle.colorGreenMonitor], mode: ImageHorizontalMode = .bottom ) -> Image? {        
        return drawIterativeGrowth(0..<iterations, colors: colors, mode: mode)
    }

}

