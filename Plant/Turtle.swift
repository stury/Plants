//
//  Turtle.swift
//
//  simple implementation of a Turtle rule based drawing system.
//
//  Created by Scott Tury on 12/2/18.
//  Copyright © 2018 Scott Tury. All rights reserved.
//

import Foundation

/// A structure to keep track of the position and heading of the turtle.
struct TurtleState {
    /// x, y coordinate
    let position: (Double, Double)
    /// angle of direction
    let heading: Double
}

// MARK: -
/// A simple implementation of a Turtle graphics context.  You give it a series of Rules to follow,
/// and an iteration to execute, and it will draw the result.
class Turtle {
    
    public var limits : Limit = Limit()
    public var rules : Rules = Rules(initiator: "F-F-F-F", rules: ["F" : "F-F+F+FF-F-F+F"])
    
    public var backgroundColor : (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 1.0)
    public var color = ( 0.7098, 0.3961, 0.1137 )
    
    public var context : CGContext?
    
    /// This function converts degrees into radiens.
    func radiens( _ degrees: Double) -> Double {
        return degrees * (Double.pi/180.0)
    }
    
    /// This function will update the current degrees that the plant should be branching in.
    /// It also checks to make sure the result is between 0 and 360.
    func modDirection( modifier: Double, direction: Double) -> Double {
        var result = direction + modifier
        if direction > 360.0 {
            result -= 360.0
        }
        else if direction < 0 {
            result += 360.0
        }
        return result
    }
    
    func drawSegment(_ start: TurtleState, end: TurtleState ) {

        limits.update(end.position)
        
        context?.setStrokeColor(CGColor.from(color))
        context?.drawLineSegment(points: [start.position, end.position])
    }
    
    public func draw(_ iteration: Int ) -> Image? {
        var result : Image?
        
        let rule = rules.calculateRules(iteration)
        
        let imageSize = (2400, 2400)
        limits.reset( imageSize )
        
        if let context = Image.context(size: imageSize, color: backgroundColor) {
            
            self.context = context
            
//            // Flip the drawing coordinates so I can draw this top to bottom as it is in the ascii maze...
//            context.saveGState()
//            context.translateBy(x: 0, y: CGFloat(imageSize.1))
//            context.scaleBy(x: 1.0, y: -1.0)

            context.setLineWidth(CGFloat(2.0))
            context.setLineJoin(CGLineJoin.round)

            var state = TurtleState(position: (floor(Double(imageSize.0)/2.0), floor(Double(imageSize.1)/3.0)), heading: 90.0 )
            
            // I've got a graphics context!  Let's build up the image...
            let startLocation = CGPoint(x: state.position.0, y: state.position.1)
            context.move(to: startLocation)
            //print( "originatingPosition = \(currentPosition.position)" )
            limits.update(startLocation)
            
            for offset in 0 ..< rule.count {
                let character = rule[String.Index(encodedOffset: offset)]
                //print( "processing character: \(character)" )
                switch character {
                case "F":
                    // Move forward drawing a line...  turtle state changes to (x', y', angle') where
                    // x' = x+ d cos angle
                    // y' = y + d sin angle
                    // line segment between (x, y) and (x', y') is drawn
                    let headingRad = radiens(state.heading)
                    let newState = TurtleState(position: (state.position.0+rules.length*cos(headingRad), state.position.1+rules.length*sin(headingRad)), heading: state.heading )
                    // draw the line segment!
                    drawSegment(state, end: newState)
                    // set new state!
                    state = newState
                    
                case "f":
                    // Move forward without drawing a line...
                    let headingRad = radiens(state.heading)
                    state = TurtleState(position: (state.position.0+rules.length*cos(headingRad), state.position.1+rules.length*sin(headingRad)), heading: state.heading )
                    limits.update(state.position)
                    
                case "-":
                    // turn right by rule.angle  (clockwise)
                    // turtle state changes to (x, y, direction-angle)
                    state = TurtleState(position: (state.position.0, state.position.1), heading: modDirection(modifier: -rules.angle, direction: state.heading) )

                case "+":
                    // turn left by rule.angle (counter clockwise)
                    // turtle state changes to (x, y, direction+angle)
                    state = TurtleState(position: (state.position.0, state.position.1), heading: modDirection(modifier: rules.angle, direction: state.heading) )

                default:
                    print("WARNING: Unimplemented rule for character: \(character)")
                }
            }
            
//            context.restoreGState()
            
            // Convert context into a Image to return.
            if let cgImage = context.makeImage() {
                result = Image(cgImage: cgImage)
            }
            
            self.context = nil
        }
        
        #if DEBUG
        print( "limit: left:\(limits.left), right:\(limits.right), top:\(limits.top), bottom:\(limits.bottom)" )
        // I could flag that this image isn't big enough, if the values fall outside of the current imageSize!
        #endif
        
        return result
    }

    // MARK: -

    // This method provides a cropped version the image.  This will allow us to automate having multikle images imposed onto the same image so you can see their growth...
    public func drawCropped( _ iterations: Int, offset: CGFloat = 0.0 ) -> Image? {
        var result : Image?
        
        if let image = draw(iterations) {
            // print("limit left: \(plant.limitLeft), left: \(plant.limitRight)")
            if let cropImage = image.crop(CGRect(x: limits.left-offset/2, y: 0, width: (limits.right - limits.left) + offset, height: image.size.height)) {
                result = cropImage
            }
            //            else {
            //                result = plantImage
            //            }
        }
        
        return result
    }
    
    /// This method creates cropped iteration versions of the plant.  This means you give an iteration number,
    /// and then it generates each successive iteration into an Image.  It then adds all the images into an
    /// image array to pass back to the caller.
    public func drawIterative(_ iterations: Int, crop: Bool, offset: CGFloat = 0.0 ) -> [Image] {
        var result : [Image] = [Image]()
        let original = rules
        
        for i in 0...iterations {
            //print( "Plant for iteration \(i): \(plant.calculateRules(i))" )
            var image : Image?
            
            if i > 0 {
                rules = Rules(initiator: original.initiator, rules: original.rules, angle: original.angle, length: original.length/(2.0*Double(i)))
            }
            
            if crop {
                image = drawCropped(i, offset: offset)
            }
            else {
                image = draw(i)
            }
            
            if let image = image {
                result.append(image)
            }
        }
        rules = original
        
        return result
    }
    
    // This method creates iterations versions of the plant.  Then assemples the images all into one image to return to the caller.
    public func drawIterativeGrowth(_ iterations: Int, offset: CGFloat = 0.0 ) -> Image? {
        var result : Image? = nil
        let curves = drawIterative(iterations, crop: true, offset: offset)
        
        var maxWidth : Int = 0
        var height : Int = 0
        
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
        
        return result
    }
}
