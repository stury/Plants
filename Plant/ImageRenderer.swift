import CoreGraphics
import ImageIO
#if os(macOS)
import Cocoa
import CoreServices
#else
import UIKit
import MobileCoreServices
#endif
#if os(macOS) || os(iOS)
import Quartz
#endif

public enum ImageRenderEnum : String {
    case png, pdf, jpg // jpeg2000, etc.
}

public class ImageRenderer {
    public var backgroundColor : (CGFloat, CGFloat, CGFloat, CGFloat)
    
    public init(_ backgroundColor:(CGFloat, CGFloat, CGFloat, CGFloat) = (1.0, 1.0, 1.0, 1.0) ) {
        self.backgroundColor = backgroundColor
    }
    
    // MARK: - Writing
    public func export(type: ImageRenderEnum, name: String = "maze", data: Data) {
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        if let documentURL = URL(string: "\(name).\(type.rawValue)", relativeTo: URL(fileURLWithPath: documentsPath)) {
            self.write(documentURL, data: data)
        }
    }

    /// Just a helper method to write a data blob out to the disk
    public func write( _ url:URL, data: Data? ) {
        if let fileData = data {
            do {
                try fileData.write(to: url)
                print( "Wrote file to \(url)" )
            }
            catch {
                print( "ERROR when writing data out to disk.  \(error)" )
            }
        }
    }
    /// Just a helper method to write a data blob out to the disk
    public func write( _ path:String, data: Data? ) {
        write(URL(fileURLWithPath: path), data: data)
    }
    
    public func asyncWrite( _ url: URL, data: Data?, completion: @escaping (()->Void) ) {
        DispatchQueue.global().async { [weak self] in
            if let strongSelf = self {
                strongSelf.write(url, data: data)
                completion()
            }
        }
    }
    
    public func asyncWrite( _ path: String, data: Data?, completion: @escaping (()->Void) ) {
        asyncWrite(URL(fileURLWithPath: path), data: data, completion: completion)
    }
    
    // MARK: - Creating
    
    public func raster( size: CGSize, drawing: (CGContext)->Void ) -> Image? {
        var result : Image? = nil
        
        result = Image.image(size: size, color: backgroundColor, drawing: drawing)
        
        return result
    }
    
    // Allows you to load in any CoreImage known file, and create an Image out of it.
    public func raster( _ data: Data ) -> [Image] {
        var result = [Image]()
        
        let cgImages = loadCGImageFromData( data )
        for cgImage in cgImages {
            // convert each cgImage into a Image!
            result.append(Image(cgImage: cgImage))
        }
        
        return result
    }
    
    // Allows you to load in any CoreImage known file, and create an Image out of it.
    public func raster( _ url: URL ) -> [Image] {
        var result = [Image]()
        if let data = try? Data(contentsOf: url) {
            result = raster( data )
        }
        else {
            result = [Image]()
        }
        return result
    }
    
    public func raster( _ path: String ) -> [Image] {
        return raster( URL(fileURLWithPath: path) )
    }
    
    public func data( mode: ImageRenderEnum, size: CGSize, drawing: (CGContext)->Void ) -> Data? {
        var result : Data? = nil
        
        switch mode {
        case .png:
            if let image = raster(size: size, drawing: drawing) {
                // Now convert this image into a data blob for the type needed....
                #if os(macOS)
                result = macOSImageData( image, storageType: .png )
                #else // os(iOS) || os(tvOS) || os(watchOS)
                result = image.pngData()
                #endif
            }
        case .jpg:
            if let image = raster(size: size, drawing: drawing) {
                // Now convert this image into a data blob for the type needed....
                #if os(macOS)
                result = macOSImageData( image, storageType: .jpeg )
                #else // os(iOS) || os(tvOS) || os(watchOS)
                result = image.jpegData(compressionQuality: 0.8)
                #endif
            }
            
        case .pdf:
            result = Image.pdf(size: size, color: backgroundColor, drawing: drawing)
        }
        
        return result
    }

    #if os(macOS) || os(iOS)
    public func pdf( size: CGSize, drawing: (CGContext)->Void ) -> PDFDocument? {
        var result : PDFDocument? = nil
        if let data = data( mode: .pdf, size: size, drawing: drawing ) {
            result = PDFDocument(data: data)
        }
        return result
    }
    #endif
    
    // MARK: - Utility
    
    #if os(macOS)
    /// macOS only private function to pull out the bitmap data in a particular format.
    private func macOSImageData(_ image: Image, storageType: NSBitmapImageRep.FileType ) -> Data? {
        var result : Data? = nil
        if let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) {
            let bitmap = NSBitmapImageRep(cgImage: cgImage)
            result = bitmap.representation(using: storageType, properties: [:])
        }
        return result
    }
    #endif
    
    
    private func loadCGImageFromData( _ data: Data) -> [CGImage] {
        var result: [CGImage] = [CGImage]()
        
        var imageSource : CGImageSource?
        
        // Setup the options if you want them.  The options here are for caching the image
        // in a decoded form.and for using floating-point values if the image format supports them.
        let options = [ kCGImageSourceShouldCache:kCFBooleanTrue as CFTypeRef,
                        kCGImageSourceShouldAllowFloat: kCFBooleanTrue as CFTypeRef ]
        
        // Create an image source from the URL.
        imageSource = CGImageSourceCreateWithData(data as CFData, options as CFDictionary)
        
        // Make sure the image source exists before continuing
        if let imageSource = imageSource {
            
            if let type = CGImageSourceGetType(imageSource) as String? {
                
                print( "imageSource type is \(type)")
                // If it's a PDF, we need to load in the file differently.
                if type == kUTTypePDF as String {
                    // Need to do something different here...
                    if let dataProvider = CGDataProvider(data: data as CFData) {
                        if let pdfReference = CGPDFDocument(dataProvider) {
                            let numberOfPages = pdfReference.numberOfPages
                            var mediaBox: CGRect
                            for index in 1...numberOfPages {
                                guard let page = pdfReference.page(at:index) else {
                                    NSLog("Error occurred in creating page")
                                    return result
                                }
                                mediaBox = page.getBoxRect(.mediaBox)
                                // Create a CGImage or Context, and draw the PDF into it?
                                
                                // Need to create a CGContext, then draw the PDFPage into the context.
                                if let context = Image.context(size: (Int(mediaBox.width), Int(mediaBox.height)), color: (1.0, 1.0, 1.0, 0.0)) {
                                    context.drawPDFPage( page )
                                    if let image = context.makeImage() {
                                        result.append( image )
                                    }
                                }
                            }
                        }
                    }
                }
                else {
                    let totalItems = CGImageSourceGetCount( imageSource )
                    print( "\(totalItems) in the image source...")
                    for index in 0..<totalItems {
                        // Create an image from the first item in the image source.
                        print("Attempting to create an image at index \(index)" )
                        let image = CGImageSourceCreateImageAtIndex(imageSource, index, nil)
                        // Make sure the image exists before continuing
                        if let image = image {
                            result.append( image )
                        }
                        else {
                            print("Image not created from image source.")
                        }
                    }
                }
            }
        }
        else {
            print( "Image source is NULL.")
        }
        
        return result
    }
    
}
