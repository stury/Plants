//: [Previous](@previous)

/*:
PDF Drawing is a tad different.
1. Create a CGDataConsumer, to save the PDF to a mutable Data object.
2. Create a context to draw into. (using a different initializer!)
3. Start a page on the context
4. Do the drawing you want.
5. Close the page.  (You can do multiple pages in a PDF document.)
6. Close the PDF.
*/

import PDFKit
import CoreGraphics

let transparentColor : (CGFloat, CGFloat, CGFloat, CGFloat) = (1.0, 1.0, 1.0, 0.0)

/*:
 This is a simple method to condense the steps necessary to draw into a PDF context into one function.
 - parameter size: The size of the PDF image to draw.
 - parameter drawing: A closure which is passed the context to draw into.
 */
func generatePDFData(size: (Int, Int), _ drawing: (CGContext)->Void ) -> Data? {
    var result : Data? = nil
    
//: First create a CGRect specifying the size of the drawing you need.
    var mediaBox = CGRect(x: 0, y: 0, width: size.0, height: size.1)
    
//: 1. Create a CGDataConsumer, to save the PDF to a mutable Data object.
    if let pdfData = CFDataCreateMutable(nil, 0) {
        if let consumer = CGDataConsumer(data: pdfData) {
//: 2. Create a context to draw into. (using a different initializer than the previous page!)
            if let context = CGContext(consumer: consumer, mediaBox: &mediaBox, nil) {
//: 3. Start a page on the context
                context.beginPDFPage(nil)
                
                // Draw the background color...
                context.setFillColor(red: transparentColor.0, green: transparentColor.1, blue: transparentColor.2, alpha: transparentColor.3)
                context.fill(CGRect(x: 0, y: 0, width: size.0, height: size.1))
                
//: 4. Do the drawing you want.
                drawing(context)
                
//: 5. Close the page.  (You can do multiple pages in a PDF document.)
                context.endPDFPage()
//: 6. Close the PDF.
                context.closePDF()
                
//:  Convert the lower level CFData into a more friendly Swift Data object...
                let size = CFDataGetLength(pdfData)
                if let bytePtr = CFDataGetBytePtr(pdfData) {
                    result = Data(bytes: bytePtr, count: size)
                }
            }
        }
    }
    return result
}

//: Example code using this function!

let size = (200, 200)

let pdfData = generatePDFData( size: size) { (context) in
        //: Let's draw our image.  Look in *Sources/Drawing.swift* for the code!
        drawShape(context, size: size)
    }
if let pdfData = pdfData {
//: Let's use the new PDFKit to read in the data, and display it natively on iOS and macOS...
    if let document = PDFDocument(data: pdfData) {
        if document.pageCount > 0 {
            let page = document.page(at: 0)

            if let mediaBox: CGRect = page?.bounds(for: .mediaBox) {
                print( "PDF Page size = \(mediaBox.size)" )
            }
        }
    }
}

//: [Next](@next)
