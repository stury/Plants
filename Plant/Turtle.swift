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
}

// MARK: -
/// A simple implementation of a Turtle graphics context.  You give it a series of Rules to follow,
/// and an iteration to execute, and it will draw the result.
class Turtle {
    
    static private let colorAmberMonitor = ( 0.7098, 0.3961, 0.1137 ) // amber
    static private let colorGreenMonitor = (0.2, 0.70, 0.2) // green display
    
    /// This class instance keeps track of where we're drawing, such that we can use it to calculate the correct image size to create.
    public var limits : Limit = Limit()
    
    /// The Rules for drawing the image.
    public var rules : Rules = Rules(initiator: "F-F-F-F", rules: ["F" : "F-F+F+FF-F-F+F"])
    
    /// Background color + alpha to use for the background of the image.  (Should easilly be able to change to having a transparent background.)
    public var backgroundColor : (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 1.0)
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
    
    /// This method draws from the start position to the end position on the graphics context.
    func drawSegment(_ start: TurtleState, end: TurtleState ) {
        limits.update(end.position)
        
        context?.setStrokeColor(CGColor.from(color))
        context?.drawLineSegment(points: [start.position, end.position])
    }
    
    public func process( _ character: Character, state: TurtleState ) -> TurtleState {
        var result = state

        switch character {
        case "F", "L", "R":
            // Move forward drawing a line...  turtle state changes to (x', y', angle') where
            // x' = x+ d cos angle
            // y' = y + d sin angle
            // line segment between (x, y) and (x', y') is drawn
            let headingRad = state.radians
            let newState = TurtleState(position: (state.position.0+rules.length*cos(headingRad), state.position.1+rules.length*sin(headingRad)), heading: state.heading )
            // draw the line segment!
            drawSegment(state, end: newState)
            // set new state!
            result = newState
            
        case "f":
            // Move forward without drawing a line...
            let headingRad = state.radians
            result = TurtleState(position: (state.position.0+rules.length*cos(headingRad), state.position.1+rules.length*sin(headingRad)), heading: state.heading )
            limits.update(state.position)
            
        case "-":
            // turn right by rule.angle  (clockwise)
            // turtle state changes to (x, y, direction-angle)
            result = TurtleState(position: (state.position.0, state.position.1), heading: state.modifiedHeading(-rules.angle) )
            
        case "+":
            // turn left by rule.angle (counter clockwise)
            // turtle state changes to (x, y, direction+angle)
            result = TurtleState(position: (state.position.0, state.position.1), heading: state.modifiedHeading(rules.angle) )

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
            
        default:
            #if DEBUG
            print("WARNING: Unimplemented rule for character: \(character)")
            #endif
        }

        return result
    }
    
    /// Method for drawing the rule set at a particular iteration point.
    public func draw(_ iteration: Int, imageSize: (Int, Int) = (20, 20) ) -> Image? {
        var result : Image?
        
        let rule = rules.calculateRules(for: iteration)
        
        //let imageSize = (2400, 2400)
        limits.reset( imageSize )
        
        if let context = Image.context(size: imageSize, color: backgroundColor) {
            
            self.context = context
            
//            // Flip the drawing coordinates so I can draw this top to bottom as it is in the ascii maze...
//            context.saveGState()
//            context.translateBy(x: 0, y: CGFloat(imageSize.1))
//            context.scaleBy(x: 1.0, y: -1.0)

            context.setLineWidth(CGFloat(2.0))
            context.setLineJoin(CGLineJoin.round)

            let startLocation : CGPoint
            if let start = start {
                startLocation = start
            }
            else {
                startLocation = CGPoint(x: floor(Double(imageSize.0)/2.0), y: floor(Double(imageSize.1)/3.0))
            }
            
            var state = TurtleState(position: (Double(startLocation.x), Double(startLocation.y)), heading: rules.initialDirection )
            
            // I've got a graphics context!  Let's build up the image...
            
            context.move(to: startLocation)
            //print( "originatingPosition = \(currentPosition.position)" )
            limits.update(startLocation)
            
            for offset in 0 ..< rule.count {
                let character = rule[String.Index(encodedOffset: offset)]
                //print( "processing character: \(character)" )
                state = process( character, state: state )
            }

            //            context.restoreGState()
            
            // Convert context into a Image to return.
            if let cgImage = context.makeImage() {
                result = Image(cgImage: cgImage)
            }
            
            self.context = nil
            
            // Test to see if the image is within the bounds of the imageSize.  If not,
            // recalculate the imageSize we  should use, and the starting position, and return that!
            if !limits.within(imageSize) {
                // recalculate the image size, and the start position, then rerun this method...
                
                let newImageSize = (Int(limits.width+2*border), Int(limits.height+2*border))
                start = CGPoint(x: startLocation.x-limits.left+border, y:startLocation.y-limits.top+border )
                result = draw( iteration, imageSize: newImageSize )
            }
        }
        
        #if DEBUG
        print( "limit: left:\(limits.left), right:\(limits.right), top:\(limits.top), bottom:\(limits.bottom)" )
        // I could flag that this image isn't big enough, if the values fall outside of the current imageSize!
        #endif
        
        return result
    }

    // MARK: -

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
    public func drawIterative(_ iterations: Int, crop: Bool ) -> [Image] {
        var result : [Image] = [Image]()
        
        start = nil

//        let original = rules
        let colors = [Turtle.colorAmberMonitor, Turtle.colorGreenMonitor]
        
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

        for i in 0...iterations-1 {
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

        color = colors[0]

        return result
    }
    
    // This method creates iterations versions of the plant.  Then assemples the images all into one image to return to the caller.
    public func drawIterativeGrowth(_ iterations: Int ) -> Image? {
        var result : Image? = nil
        let curves = drawIterative(iterations, crop: true)
        
        var maxWidth : Int = 0
        var height : Int = 0
        
        start = nil
        
        // go through the images to figure out the width/height we will need for our composite image.
        for image in curves {
            //print( "Plant for iteration \(i): \(plant.calculateRules(i))" )
            maxWidth += Int(image.size.width)
            height = Int(image.size.height)
        }
        
        // Once we have all of the cropped images, we should be able to calculate the size of the full image, and generate it.
        let imageSize = ( maxWidth, height )
        if let context = Image.context(size: imageSize, color: backgroundColor) {
            
            // now I can iterate through all of the images and generate one image that incorporates them all!
            var offset : CGFloat = 0.0
            for image in curves {
                if let cgImage = image.cgImage {
                    let rect = CGRect(x: offset, y: 0.0, width: image.size.width, height: image.size.height)
                    //print( "\(rect)" )
                    context.draw(cgImage, in: rect)
                    offset += image.size.width
                }
            }
            
            if let cgImage = context.makeImage() {
                result = Image(cgImage: cgImage)
            }
        }
        
        start = nil

        return result
    }
}
