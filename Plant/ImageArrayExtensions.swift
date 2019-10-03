//
//  ImageArrayExtensions.swift
//  Plant
//
//  Created by Scott Tury on 12/8/18.
//  Copyright © 2018 Scott Tury. All rights reserved.
//

import Foundation
import CoreGraphics

enum ImageHorizontalMode {
    case bottom;
    case center;
    case top;
}

// MARK: - Image Array Extension

/// Extension to an Array of Image objects so I can operate on the array of items more simply.
extension Array where Element:Image {
    
    /// This method will take all of the images in the array and try to create a new image with the contents of all of them aligned horizonatlly one right after the other.  If successful, an Image will be returned.
    func arrangedHorizontally( backgroundColor: (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 1.0), mode: ImageHorizontalMode = .bottom ) -> Image? {
        var result : Image? = nil
        
        // Append all of the images together!
        var maxWidth : Int = 0
        var height : Int = 0
        
        // go through the images to figure out the width/height we will need for our composite image.
        for image in self {
            //print( "Plant for iteration \(i): \(plant.calculateRules(i))" )
            maxWidth += Int(image.size.width)
            height = Swift.max(height, Int(image.size.height))
        }
        
        // Once we have all of the cropped images, we should be able to calculate the size of the full image, and generate it.
        let imageSize = ( maxWidth, height )
        let renderer = ImageRenderer(backgroundColor)
        result = renderer.raster(size: CGSize(width: imageSize.0, height: imageSize.1), drawing: { (context) in
            // now I can iterate through all of the images and generate one image that incorporates them all!
            var offset : CGFloat = 0.0
            for image in self {
                if let cgImage = image.cgImage {
                    let rect : CGRect
                    switch ( mode ) {
                    case .bottom:
                        rect = CGRect(x: offset, y: 0.0, width: image.size.width, height: image.size.height)
                    case .center:
                        rect = CGRect(x: offset, y: (CGFloat(height) - image.size.height)/2.0, width: image.size.width, height: image.size.height)
                    case .top:
                        rect = CGRect(x: offset, y: (CGFloat(height) - image.size.height), width: image.size.width, height: image.size.height)
                    }

                    //print( rect )
                    context.draw(cgImage, in: rect)
                    offset += image.size.width
                }
            }
        })
                    
        return result
    }
}

// MARK: - PDF Data Array Extension

/// Extension to an Array of PDF Data objects, so I can operate on the array of items more simply.
extension Array where Element==Data {
    
    /// This method will take all of the pdf Data in the array and try to create a new image with the contents of all of them aligned horizonatlly one right after the other.  If successful, a pdf data blob will be returned.
    func arrangedHorizontally( backgroundColor: (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 1.0), mode: ImageHorizontalMode = .bottom ) -> Data? {
        var result : Data? = nil
        
        // Append all of the images together!
        var maxWidth : Int = 0
        var height : Int = 0
                
        // go through the images to figure out the width/height we will need for our composite image.
        for plantImage in self {
            //print( "Plant for iteration \(i): \(plant.calculateRules(i))" )
            // NEED to open this as a PDF Docuent to find out it's size...
            if let provider = CGDataProvider(data: plantImage as CFData),
                let document = CGPDFDocument(provider),
                let page = document.page(at:1)
            {
                let boxRect = page.getBoxRect(.mediaBox)
                
                print( "pdf plant width:\(boxRect.width) height:\(boxRect.height)" )
                maxWidth += Int(boxRect.width)
                height = Swift.max(height, Int(boxRect.height))
            }
        }

        // Once we have all of the cropped images, we should be able to calculate the size of the full image, and generate it.
        let imageSize = ( maxWidth, height )
        print( "iterative pdf size: \(imageSize)" )
        
        let renderer = ImageRenderer(backgroundColor)
        result = renderer.data(mode: .pdf, size: CGSize(width: imageSize.0, height: imageSize.1)) { (context) in
            // now I can iterate through all of the images and generate one image that incorporates them all!
            var offset : CGFloat = 0.0
            for image in self {

                if let provider = CGDataProvider(data: image as CFData),
                    let document = CGPDFDocument(provider),
                    let page = document.page(at:1)
                {
                    let imageRect = page.getBoxRect(.mediaBox)
                    // transform the page over the current offset, and then draw the page.

                    // Calculate where we need to draw!
                    let rect : CGRect
                    switch ( mode ) {
                    case .bottom:
                        rect = CGRect(x: offset, y: 0.0, width: imageRect.size.width, height: imageRect.size.height)
                    case .center:
                        rect = CGRect(x: offset, y: (CGFloat(height) - imageRect.size.height)/2.0, width: imageRect.size.width, height: imageRect.size.height)
                    case .top:
                        rect = CGRect(x: offset, y: (CGFloat(height) - imageRect.size.height), width: imageRect.size.width, height: imageRect.size.height)
                    }

                    print(" translating by \(offset)")
                    context.translateBy(x: rect.origin.x, y: rect.origin.y)
                    context.drawPDFPage( page )
                    // reset the translation...
                    context.translateBy(x: -rect.origin.x, y: -rect.origin.y)

                    offset += rect.size.width
                }
            }
        }
        
        return result
    }
}
