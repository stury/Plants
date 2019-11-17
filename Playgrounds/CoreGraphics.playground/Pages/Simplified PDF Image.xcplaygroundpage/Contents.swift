//: [Previous](@previous)

/*:
Here's an example of creating a PDF image using the same *ImageRenderer* I created previously.  I don't need to know that I need to flip my image when I'm using UIKit specific classes.  I should be able to use the same code, and get the same image out of it.
 
1. Create a ImageRenderer instance.
2. Ask it to create a Data object with a specific size image.
3. In the closure do your normal CGContext drawing.
 
 Done.  Class converts the drawing into a Data object, which can be saved to disk, or loaded in memory to dispay using PDFKit.
*/

import Foundation
import CoreGraphics
import PDFKit

// Let's draw something simple as a pdf image

let size = (200, 200)
var image : Data?

let renderer = ImageRenderer()
image = renderer.data(mode: .pdf, size: CGSize(width: size.0, height: size.1)) { (context) in
    
    drawShape(context, size: size)
}

//: Simple code to load in the PDF data into something we can see.
if let pdfData = image {
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
}


//: [Next](@next)
