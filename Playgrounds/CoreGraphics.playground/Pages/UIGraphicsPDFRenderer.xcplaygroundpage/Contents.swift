//: [Previous](@previous)

#if os(iOS)
import Foundation
import UIKit
import UIKit.UIGraphicsRendererSubclass
import PDFKit

/*:
Here's the same example using the new *UIGraphicsPDFRenderer* class to generate a PDF image.
 This technique only workes on iOS/tvOS 10.0 and higher.
 
There are a few issues with using it:
1. It's iOS/tvOS specific.  (No other platforms are suported!)
2. There is no macOS equivalent.
3. Biut it's pretty simple to use.
4. iOS's coordinate system is flipped from CGGraphics and macOS.  You'll need to aply a transform in order to draw correctly.
 
 It's easy to use though:
 1. Create a *UIGraphicsPDFRenderer* with the size you want.
 2. use the `pdfData` method to create the pdf data.
 3. In the closure provided, get the cgContext, and apply a transform to flip the space coordinates.
 4. Draw like normal on the cgContext.
 5. Conversion to Data handled for you by Apple!
*/

let size = (200, 200)

let bounds = CGRect(origin: CGPoint(x:0, y:0), size: CGSize(width: size.0, height: size.1))
//: 1. Create a *UIGraphicsPDFRenderer* with the size you want.
let renderer = UIGraphicsPDFRenderer(bounds: bounds)
//: 2. use the `pdfData` method to create the pdf data.
let pdfData = renderer.pdfData { (pdfRendererContext) in
    pdfRendererContext.beginPage() // You can add a new page, just calling beginPage()
    
    let context = pdfRendererContext.cgContext
    /*:
     3. In the closure provided, get the cgContext, and apply a transform to flip the space coordinates.
     It turns out that in UIKit, a translation matrix has been applied to flip the drawing layer.
     So in order to fix it, we need to add another translation to flip the coordinate system again.
     */
    context.saveGState()
    context.translateBy(x: 0, y: CGFloat(size.1))
    context.scaleBy(x: 1.0, y: -1.0)

//: 4. Draw like normal on the cgContext.   Don't forget to color in the background!
    let transparentColor : (CGFloat, CGFloat, CGFloat, CGFloat) = (1.0, 1.0, 1.0, 0.0)
    context.setFillColor(red: transparentColor.0, green: transparentColor.1, blue: transparentColor.2, alpha: transparentColor.3)
    context.fill(CGRect(x: 0, y: 0, width: size.0, height: size.1))

    drawShape(context, size: size)

//: 5. Conversion to Data handled for you by Apple!
}
#endif

// We have some pdfData.  Let's load it in!
//: Let's use the new PDFKit to read in the data, and display it natively on iOS and macOS...
if let document = PDFDocument(data: pdfData) {
    if document.pageCount > 0 {
        let page = document.page(at: 0)

        if let mediaBox: CGRect = page?.bounds(for: .mediaBox) {
            print( "PDF Page size = \(mediaBox.size)" )
        }
    }
}

//: [Next](@next)
