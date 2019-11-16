/// Plant.swift
///
/// This is a super simple 2D plant generation algorithm I wrote in 1990 on clasic macOS based on a Scientific
/// American article by A.K.Dewdney.
/// Updated the algorithm for Swift 4.2 and suport CoreGraphics on macOS/iOS November 30, 2018.
///
/// Scott Tury

#if os(macOS)
    import Cocoa
    import Quartz
#elseif os(iOS)
    import UIKit
#endif

public enum PlantItemEnum : Int {
    case leaf = 0
    case branch = 1
}

public enum PlantBranchEnum {
    case left
    case right
}

public struct PositionNode {
    let position: (Double, Double)
    var direction: Double
    var branch : PlantBranchEnum  // Come back and check this out!
}

public class Plant : CustomStringConvertible {

    public var description: String {
        get {
            // Convert the Plant info to a string
             var result : String = ""
             if let name = name {
                 result += "\(name) Rule Set\n\n"
             }
             result += "δ = \(branchAngle)°\n\n"
             result += " w : \(seed)\n"
             var iteration = 1
             for (rule, replacement) in rules {
                 result += "p\(iteration) : \(rule) -> \(replacement)\n"
                 iteration += 1
             }
             
             return result
        }
    }
    
    public var branchAngle : Double = 45.0
    
    /// This class instance keeps track of where we're drawing, such that we can use it to calculate the correct image size to create.
    public var limits : Limit = Limit()
    public var border : CGFloat = 40.0
    
    public var backgroundColor : (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
    
    private let branchColor = ( 0.7098, 0.3961, 0.1137 )
    private let leafColor = ( 0.0, 1.0, 0.0 )
    private var startPos : (Double, Double)? = nil
    
    public var context : CGContext?
    var positionStack : [PositionNode] = [PositionNode]()
    
    public var lengthModifier : Double = 1.0
    public var name: String?
    
    let seed = "0"
    public static let rule0 = "11[0]1[0]1110"
    //static let rule0 = "1[0][0]110" // Maple leaf
    //static let rule0 = "11[[0]][[][0]]10" // Christmas
    //static let rule0 = "1[0][0]" // ? Plant
    //static let rule0 = "1[1[1[1[1[1[10]]]]]]" // Paisley
    //static let rule0 = "11[1[1[0]]]1[1[0]]1[1[0][1[0]]]"  // Lopsided
    //static let rule0 = "11[1[1[0]]][11[][0]]111[10]" // Sparse lopsided
    
    public static let rule1 = "11"
    
    var rules =  ["0": rule0, "1": rule1]
    
    public convenience init(branchAngle: Double = 45.0, rule0: String = rule0, rule1: String = rule1) {
        self.init()
        self.branchAngle = branchAngle
        self.rules["0"] = rule0
        self.rules["1"] = rule1
    }

    public convenience init(name: String, branchAngle: Double = 45.0, rule0: String = rule0, rule1: String = rule1) {
        self.init()
        self.name = name
        self.branchAngle = branchAngle
        self.rules["0"] = rule0
        self.rules["1"] = rule1
    }
    
    /// Calculate the limits of the actual drawing, so we might be able to crop the image at the emd.
    private func updateLimit(_ point: CGPoint ) {
        limits.update(point)
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
        let adjustedPosition = ( position.0 + CGFloat( ceil(sin(directionInRadiens)*4.0*lengthModifier) ),
                                 position.1 - CGFloat(ceil(cos(directionInRadiens)*4.0*lengthModifier)) )
        //print( "drawLeaf() directionsInRadiens=\(directionInRadiens), position=\(position), adjustedPosition=\(adjustedPosition)")
        
        limits.update(adjustedPosition)
        
        if let context = context {
            context.setStrokeColor(CGColor.from(color(for: .leaf)))
            context.setLineWidth(CGFloat(2.0*lengthModifier))
            context.drawLineSegment(points: [position, adjustedPosition])
        }
    }
    
    func drawLeaf(_ position: (Double, Double), direction: Double) {
        drawLeaf((CGFloat(position.0), CGFloat(position.1)), direction: direction)
    }
    
    func drawBranch(_ position: (CGFloat, CGFloat), direction: Double, length: Double) -> (CGFloat, CGFloat) {
        let directionInRadiens = radiens(direction)
        let adjustedPosition = ( position.0 + CGFloat( ceil(sin(directionInRadiens)*length*lengthModifier) ),
                                 position.1 - CGFloat(ceil(cos(directionInRadiens)*length*lengthModifier)) )
        
        limits.update(adjustedPosition)
        
        context?.setLineWidth(CGFloat(2.0*lengthModifier))
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
    
    /// Common drawing routine for both raster and PDF drawing.
    private func draw(in context:CGContext, rule: String, imageSize: (Int, Int) ) {
        self.context = context
        
        // Flip the drawing coordinates so I can draw this top to bottom as it is in the ascii maze...
        context.saveGState()
        context.translateBy(x: 0, y: CGFloat(imageSize.1))
        context.scaleBy(x: 1.0, y: -1.0)
        context.setLineWidth(CGFloat(2.0))
        context.setLineJoin(CGLineJoin.round)
        
        positionStack = [PositionNode]()
        
        var currentPosition : PositionNode
        if let startPos = startPos {
            currentPosition = PositionNode(position: startPos, direction: 0.0, branch: .left)
        }
        else {
            let position = (floor(Double(imageSize.0)/2.0), floor(Double(imageSize.1)*0.75))
            currentPosition = PositionNode(position: position, direction: 0.0, branch: .left)
            startPos = position
        }
        
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
    }
}

    
// MARK: - Raster Drawing Routines
    
extension Plant {
    public func drawPlant(_ iterations: Int, imageSize: (Int, Int) = (20, 20) ) -> Image? {
        var result : Image?
        
        let rule = calculateRules(iterations)
        
        limits.reset(imageSize)

        let renderer = ImageRenderer( backgroundColor )
        result = renderer.raster(size: CGSize(width: imageSize.0, height: imageSize.1)) { [weak self] (context) in
            self?.draw(in:context, rule:rule, imageSize:imageSize)
        }

        if !limits.within(imageSize) {
            // recalculate the image size, and the start position, then rerun this method...
            if let startLocation = startPos {
                let newImageSize = (Int(limits.width+2*border), Int(limits.height+2*border))
                if newImageSize == imageSize {
                    print( "Uh, oh!  We're stuck.  Why?")
                }
                let x = Double((CGFloat(startLocation.0)-limits.left)+border)
                let y = Double((CGFloat(startLocation.1)-limits.top)+border)
                startPos = ( x, y )
            
                result = drawPlant( iterations, imageSize: newImageSize )
            }
        }
        startPos = nil
        
        return result
    }
    
    // This method provides a cropped version the image.  This will allow us to automate having multikle images imposed onto the same image so you can see their growth...
    public func croppedPlant( _ iterations: Int, offset: CGFloat = 0.0 ) -> Image? {
        var result : Image?

        if let _ = drawPlant(iterations) {
            //print("limit left: \(limits.left), left: \(limits.right)")
            let height = limits.bottom-limits.top
            if let cropImage = drawPlant(iterations, imageSize: (Int((limits.right-limits.left)+offset), Int(height))) {
                result = cropImage
            }
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
            print( "plant width:\(plantImage.size.width) height:\(plantImage.size.height)" )
            maxWidth += Int(plantImage.size.width)
            height = Int(plantImage.size.height)
        }

        // Once we have all of the cropped images, we should be able to calculate the size of the full image, and generate it.
        let imageSize = ( maxWidth, height )
        print( "iterative pdf size: \(imageSize)" )
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

// MARK: - PDF Drawing Routines
extension Plant {

    public func drawPlantPdf(_ iteration: Int, imageSize: (Int, Int) = (20, 20) ) -> Data? {
        var result : Data?
        
        let rule = calculateRules(iteration)
        
        limits.reset(imageSize)
        
        let renderer = ImageRenderer( backgroundColor )
        result = renderer.data(mode: .pdf, size: CGSize(width: imageSize.0, height: imageSize.1)) { [weak self] (context) in
            self?.draw(in:context, rule:rule, imageSize:imageSize)
        }
        
        if !limits.within(imageSize) {
            // recalculate the image size, and the start position, then rerun this method...
            if let startLocation = startPos {
                let newImageSize = (Int(limits.width+2*border), Int(limits.height+2*border))
                if newImageSize == imageSize {
                    print( "Uh, oh!  We're stuck.  Why?")
                }
                let x = Double((CGFloat(startLocation.0)-limits.left)+border)
                let y = Double((CGFloat(startLocation.1)-limits.top)+border)
                startPos = ( x, y )
            
                result = drawPlantPdf( iteration, imageSize: newImageSize )
            }
        }

        return result
    }
    
    // This method provides a cropped version the image.  This will allow us to automate having multiple images imposed onto the same image so you can see their growth...
    public func croppedPlantPdf( _ iteration: Int, offset: CGFloat = 0.0 ) -> Data? {
        var result : Data?

        if let image = drawPlantPdf(iteration) {
            //print("limit left: \(limits.left), left: \(limits.right)")
            let height = limits.bottom-limits.top
            let width = (limits.right-limits.left)+offset
//            if let cropImage = drawPlantPdf(iteration, imageSize: (Int(width), Int(height))) {
//                result = cropImage
//            }
            let translation = ( limits.left, limits.bottom )
            let imageSize = ( width, height )
            print( "cropped pdf size: \(imageSize)" )
            
            let renderer = ImageRenderer(backgroundColor)
            result = renderer.data(mode: .pdf, size: CGSize(width: imageSize.0, height: imageSize.1)) { (context) in
                // now I can iterate through all of the images and generate one image that incorporates them all!
                if let provider = CGDataProvider(data: image as CFData),
                    let document = CGPDFDocument(provider),
                    let page = document.page(at:1)
                {
                    let imageRect = page.getBoxRect(.mediaBox)
                    // transform the page over the current offset, and then draw the page.

                    // Calculate where we need to draw!
//                    let rect : CGRect
//                    rect = CGRect(x: offset, y: (CGFloat(height) - imageRect.size.height)/2.0, width: imageRect.size.width, height: imageRect.size.height)
//                    context.translateBy(x: rect.origin.x, y: rect.origin.y)

                    context.translateBy(x: -translation.0, y:-( imageRect.size.height - translation.1))
                    context.drawPDFPage( page )
                    // reset the translation...
                    context.translateBy(x: +translation.0, y: (imageRect.size.height - translation.1))
//                    context.translateBy(x: -rect.origin.x, y: -rect.origin.y)
                }
            }
        }

        return result
    }
    
    /// This method creates cropped iteration versions of the plant.  This means you give an iteration number,
    /// and then it generates each successive iteration into an Image.  It then adds all the images into an
    /// image array to pass back to the caller.
    public func iterativePlantsPdf(_ iterations: Int, crop: Bool, offset: CGFloat = 0.0 ) -> [Data] {
        var result : [Data] = [Data]()
        
        for i in 0...iterations {
            //print( "Plant for iteration \(i): \(plant.calculateRules(i))" )
            var image : Data?
            
            if crop {
                image = croppedPlantPdf(i, offset: offset)
            }
            else {
                image = drawPlantPdf(i)
            }
            
            if let image = image {
                result.append(image)
            }
        }
        return result
    }

    // This method creates iterations versions of the plant.  Then assemples the images all into one image to return to the caller.
    public func iterativeGrowthPdf(_ iterations: Int, offset: CGFloat = 0.0 ) -> Data? {
        var result : Data? = nil
        let plants = iterativePlantsPdf(iterations, crop: true, offset: offset)

        var maxWidth : Int = 0
        var height   : Int = 0
        
        // go through the images to figure out the width/height we will need for our composite image.
        for plantImage in plants {
            //print( "Plant for iteration \(i): \(plant.calculateRules(i))" )
            // NEED to open this as a PDF Docuent to find out it's size...
            if let provider = CGDataProvider(data: plantImage as CFData),
                let document = CGPDFDocument(provider),
                let page = document.page(at:1)
            {
                let boxRect = page.getBoxRect(.mediaBox)
                
                print( "pdf plant width:\(boxRect.width) height:\(boxRect.height)" )
                maxWidth += Int(boxRect.width)
                height = Int(boxRect.height)
            }
            //let document = PDFDocument(data: plantImage)
        }

        // Once we have all of the cropped images, we should be able to calculate the size of the full image, and generate it.
        let imageSize = ( maxWidth, height )
        print( "iterative pdf size: \(imageSize)" )
        
        let renderer = ImageRenderer(backgroundColor)
        result = renderer.data(mode: .pdf, size: CGSize(width: imageSize.0, height: imageSize.1)) { (context) in
            // now I can iterate through all of the images and generate one image that incorporates them all!
            var offset : CGFloat = 0.0
            for image in plants {

                if let provider = CGDataProvider(data: image as CFData),
                    let document = CGPDFDocument(provider),
                    let page = document.page(at:1)
                {
                    let boxRect = page.getBoxRect(.mediaBox)
                    // transform the page over the current offset, and then draw the page.
                    //let rect = CGRect(x: offset, y: 0.0, width: boxRect.width, height: boxRect.height)
                    //let transform = page.getDrawingTransform(.mediaBox, rect: rect, rotate: 0, preserveAspectRatio: true)
                    print(" translating by \(offset)")
                    context.translateBy(x: offset, y: 0.0)
                    context.drawPDFPage( page )
                    // reset the translation...
                    context.translateBy(x: -offset, y: 0.0)

                    offset += boxRect.width
                }
            }
        }
        
        return result
    }
}
