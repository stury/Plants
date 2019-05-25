/// Plant.swift
///
/// This is a super simple 2D plant generation algorithm I wrote in 1990 on clasic macOS based on a Scientific
/// American article by A.K.Dewdney.
/// Updated the algorithm for Swift 4.2 and suport CoreGraphics on macOS/iOS November 30, 2018.
///
/// Scott Tury

#if os(macOS)
    import Cocoa
#elseif os(iOS)
    import UIKit
#endif

enum PlantItemEnum : Int {
    case leaf = 0
    case branch = 1
}

enum PlantBranchEnum {
    case left
    case right
}

struct PositionNode {
    let position: (Double, Double)
    var direction: Double
    var branch : PlantBranchEnum  // Come back and check this out!
}

class Plant {
    public var branchAngle : Double = 45.0
    
    public var limitLeft : CGFloat = 0.0
    public var limitRight: CGFloat = 0.0
    public var limitTop : CGFloat = 0.0
    public var limitBottom : CGFloat = 0.0
    
    public var backgroundColor : (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 1.0)
    
    private let branchColor = ( 0.7098, 0.3961, 0.1137 )
    private let leafColor = ( 0.0, 1.0, 0.0 )
    
    public var context : CGContext?
    var positionStack : [PositionNode] = [PositionNode]()
    
    let seed = "0"
    static let rule0 = "11[0]1[0]1110"
    //static let rule0 = "1[0][0]110" // Maple leaf
    //static let rule0 = "11[[0]][[][0]]10" // Christmas
    //static let rule0 = "1[0][0]" // ? Plant
    //static let rule0 = "1[1[1[1[1[1[10]]]]]]" // Paisley
    //static let rule0 = "11[1[1[0]]]1[1[0]]1[1[0][1[0]]]"  // Lopsided
    //static let rule0 = "11[1[1[0]]][11[][0]]111[10]" // Sparse lopsided
    
    static let rule1 = "11"
    
    var rules =  ["0": rule0, "1": rule1]
    
    /// Calculate the limits of the actual drawing, so we might be able to crop the image at the emd.
    private func updateLimit(_ point: CGPoint ) {
        if point.x < limitLeft {
            limitLeft = point.x
        }
        if point.x > limitRight {
            limitRight = point.x
        }
        
        if point.y < limitTop {
            limitTop = point.y
        }
        if point.y > limitBottom {
            limitBottom = point.y
        }
    }

    private func updateLimit(_ point: (CGFloat, CGFloat) ) {
        updateLimit( CGPoint(x: point.0, y: point.1) )
    }
    
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
    
    func color( for type: PlantItemEnum ) -> ( Double, Double, Double) {
        let result : (Double, Double, Double)
        switch ( type ) {
        case .branch:
            result = branchColor
        default:
            result = leafColor
        }
        return result
    }
    
    func drawLeaf(_ position: (CGFloat, CGFloat), direction: Double) {
        let directionInRadiens = radiens(direction)
        let adjustedPosition = ( position.0 + CGFloat( ceil(sin(directionInRadiens)*4.0) ),
                                 position.1 - CGFloat(ceil(cos(directionInRadiens)*4.0)) )
        //print( "drawLeaf() directionsInRadiens=\(directionInRadiens), position=\(position), adjustedPosition=\(adjustedPosition)")
        
        updateLimit(adjustedPosition)
        
        if let context = context {
            context.setStrokeColor(CGColor.from(color(for: .leaf)))
            context.setLineWidth(2.0)
            context.drawLineSegment(points: [position, adjustedPosition])
        }
    }
    
    func drawLeaf(_ position: (Double, Double), direction: Double) {
        drawLeaf((CGFloat(position.0), CGFloat(position.1)), direction: direction)
    }
    
    func drawBranch(_ position: (CGFloat, CGFloat), direction: Double, length: Double) -> (CGFloat, CGFloat) {
        let directionInRadiens = radiens(direction)
        let adjustedPosition = ( position.0 + CGFloat( ceil(sin(directionInRadiens)*length) ),
                                 position.1 - CGFloat(ceil(cos(directionInRadiens)*length)) )
        
        updateLimit(adjustedPosition)
        
        context?.setStrokeColor(CGColor.from(color(for: .branch)))
        context?.drawLineSegment(points: [position, adjustedPosition])
        return adjustedPosition
    }
    
    func drawBranch(_ position: (Double, Double), direction: Double, length: Double) -> (Double, Double) {
        let floatPosition = drawBranch((CGFloat(position.0), CGFloat(position.1)), direction: direction, length: length)
        return (Double(floatPosition.0), Double(floatPosition.1))
    }
    
    /// calculates the entire rule base based on the number of iterations we want to draw.
    func calculateRules( _ iterations: Int ) -> String {
        var result = seed
        
        for _ in 0..<iterations {
            var tmpString = ""
            for offset in 0..<result.count {
                // for each character, if I have a rule for it, replace that character with the rule.  Otherwise keep the character.
                let character = result[String.Index(utf16Offset: offset, in: result)]
                if let replacement = rules[String(character)] {
                    tmpString.append(replacement)
                }
                else {
                    tmpString.append(character)
                }
            }
            result = tmpString
        }
        
        return result
    }
    
    func resetLimits(_ imageSize: (Int, Int)) {
        limitLeft  = CGFloat(imageSize.0)
        limitRight = 0.0
        limitTop = CGFloat(imageSize.1)
        limitBottom = 0.0
    }
    
    public func drawPlant(_ iterations: Int ) -> Image? {
        var result : Image?
        
        let rule = calculateRules(iterations)
        
        let imageSize = (600, 600)
        resetLimits( imageSize )
        
        if let context = Image.context(size: imageSize, color: backgroundColor) {
            
            self.context = context
            
            // Flip the drawing coordinates so I can draw this top to bottom as it is in the ascii maze...
            context.saveGState()
            context.translateBy(x: 0, y: CGFloat(imageSize.1))
            context.scaleBy(x: 1.0, y: -1.0)
            context.setLineWidth(CGFloat(2.0))
            context.setLineJoin(CGLineJoin.round)
            
            positionStack = [PositionNode]()
            var currentPosition = PositionNode(position: (floor(Double(imageSize.0)/2.0), floor(Double(imageSize.1)*0.75)), direction: 0.0, branch: .left)
            positionStack.append(currentPosition)
            
            // I've got a graphics context!  Let's build up the image...
            let startLocation = CGPoint(x: currentPosition.position.0, y: currentPosition.position.1)
            context.move(to: startLocation)
            //print( "originatingPosition = \(currentPosition.position)" )
            updateLimit(startLocation)
            
            var len = 0.0
            
            for offset in 0 ..< rule.count {
                let character = rule[String.Index(utf16Offset: offset, in: rule)]
                //print( "processing character: \(character)" )
                switch character {
                case "0":
                    if len > 0.0 {
                        currentPosition = PositionNode(position: drawBranch(currentPosition.position, direction: currentPosition.direction, length: len), direction: currentPosition.direction, branch: currentPosition.branch)
                        len = 0.0
                    }
                    drawLeaf(currentPosition.position, direction: currentPosition.direction)
                case "1":
                    len += 1.0
                case "[":
                    if len > 0.0 {
                        currentPosition = PositionNode(position: drawBranch(currentPosition.position, direction: currentPosition.direction, length: len), direction: currentPosition.direction, branch: currentPosition.branch)
                        len = 0.0
                    }
                    if currentPosition.branch == .left {
                        currentPosition.direction -= branchAngle
                    }
                    else {
                        currentPosition.direction += branchAngle
                    }

                    // push an item onto the stack?
                    positionStack.append(currentPosition)
                    
                case "]":
                    if positionStack.count > 0 {
                        currentPosition = positionStack.removeLast()
                        if currentPosition.branch == .left {
                            currentPosition.direction += branchAngle
                            currentPosition.branch = .right
                        }
                        else {
                            currentPosition.branch = .left
                            currentPosition.direction -= branchAngle
                        }
                        context.move(to: CGPoint(x: currentPosition.position.0, y: currentPosition.position.1))
                    }
                default:
//                    if positionStack.count > 0 {
//                        currentPosition = positionStack.removeLast()
//                        if currentPosition.branch == .left {
//                            currentPosition.direction += branchAngle
//                            currentPosition.branch = .right
//                        }
//                        else {
//                            currentPosition.branch = .left
//                            currentPosition.direction -= branchAngle
//                        }
//                        context.move(to: CGPoint(x: currentPosition.position.0, y: currentPosition.position.1))
//                    }
                    print("WARNING: cannot process rule for character: \(character)")
                }
            }
            
            context.restoreGState()
            
            // Convert context into a Image to return.
            if let cgImage = context.makeImage() {
                result = Image(cgImage: cgImage)
            }
            
            self.context = nil
        }

        #if DEBUG
        print( "limit: left:\(limitLeft), right:\(limitRight), top:\(limitTop), bottom:\(limitBottom)" )
        // I could flag that this image isn't big enough, if the values fall outside of the current imageSize!
        #endif
        
        return result
    }
    
    // This method provides a cropped version the image.  This will allow us to automate having multikle images imposed onto the same image so you can see their growth...
    public func croppedPlant( _ iterations: Int, offset: CGFloat = 0.0 ) -> Image? {
        var result : Image?

        if let plantImage = drawPlant(iterations) {
            // print("limit left: \(plant.limitLeft), left: \(plant.limitRight)")
            if let cropImage = plantImage.crop(CGRect(x: limitLeft-offset/2, y: 0, width: (limitRight - limitLeft) + offset, height: plantImage.size.height)) {
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
    public func iterativePlants(_ iterations: Int, crop: Bool, offset: CGFloat = 0.0 ) -> [Image] {
        var result : [Image] = [Image]()
        
        for i in 0...iterations {
            //print( "Plant for iteration \(i): \(plant.calculateRules(i))" )
            var image : Image?
            
            if crop {
                image = croppedPlant(i, offset: offset)
            }
            else {
                image = drawPlant(i)
            }
            
            if let image = image {
                result.append(image)
            }
        }
        return result
    }
    
    // This method creates iterations versions of the plant.  Then assemples the images all into one image to return to the caller.
    public func iterativeGrowth(_ iterations: Int, offset: CGFloat = 0.0 ) -> Image? {
        var result : Image? = nil
        let plants = iterativePlants(iterations, crop: true, offset: offset)

        var maxWidth : Int = 0
        var height : Int = 0
        
        // go through the images to figure out the width/height we will need for our composite image.
        for plantImage in plants {
            //print( "Plant for iteration \(i): \(plant.calculateRules(i))" )
            maxWidth += Int(plantImage.size.width)
            height = Int(plantImage.size.height)
        }

        // Once we have all of the cropped images, we should be able to calculate the size of the full image, and generate it.
        let imageSize = ( maxWidth, height )
        if let context = Image.context(size: imageSize, color: backgroundColor) {
            
            // now I can iterate through all of the images and generate one image that incorporates them all!
            var offset : CGFloat = 0.0
            for image in plants {
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
