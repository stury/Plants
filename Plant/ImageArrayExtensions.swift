//
//  ImageArrayExtensions.swift
//  Plant
//
//  Created by Scott Tury on 12/8/18.
//  Copyright © 2018 Scott Tury. All rights reserved.
//

import Foundation

enum ImageHorizontalMode {
    case bottom;
    case center;
    case top;
}

/// Extension to an Array of Imaghe objects so I can operate on the array of items more simply.
extension Array where Element:Image {
    
    /// This method will take all of the images in the array and try to create a new image with th econtents of all of them aligned horizonatlly one right after the other.  If successful, and Image will be returned.
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
        if let context = Image.context(size: imageSize, color: backgroundColor) {
            
            //print( imageSize )
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
            
            if let cgImage = context.makeImage() {
                result = Image(cgImage: cgImage)
            }
        }
        
        return result
    }
}
