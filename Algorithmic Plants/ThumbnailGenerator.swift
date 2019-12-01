//
//  ThumbnailGenerator.swift
//  Digital Plants
//
//  Created by Scott Tury on 11/28/19.
//  Copyright © 2019 Scott Tury. All rights reserved.
//

import Foundation
import CoreGraphics
import PlantKit

class ThumbnailGenerator {
    
    public var backgroundColor : (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
    
    public var size : CGSize = CGSize(width:80, height:80)
    
    // NOTE:  This is a FIFO DispatchQueue.  Can we use a concurrent Queue?
    // We should also use a File based cache to teh cell thumbnails as well.
    // And we will need to fix the ones that are very slow when generating thumbnails.
    private let processingQueue = DispatchQueue(label: "ThumbnailProcessing", qos: .background, autoreleaseFrequency: .inherit )
    private let renderer = ImageRenderer()
    
    func aspectResize(_ image: Image) -> Image? {
        renderer.backgroundColor = backgroundColor
        let thumbnail = renderer.raster(size: size, drawing: { [weak self] (context) in
            // draw the image inside the size wanted...
            let aspect : CGFloat
            if let strongSelf = self {
                if  image.size.width > image.size.height {
                    aspect = 1.0 / (image.size.width / strongSelf.size.width)
                }
                else {
                    aspect = 1.0 / (image.size.height / strongSelf.size.height)
                }

                // Now I can generate the new image size...
                let newSize = CGSize(width: floor(image.size.width*aspect), height: floor(image.size.height*aspect))
                
                if let cgImage = image.cgImage {
                    context.draw(cgImage, in: CGRect(x: ((strongSelf.size.width-newSize.width)/2.0), y: ((strongSelf.size.height-newSize.height)/2.0), width: newSize.width, height: newSize.height))
                }
            }
        })
        return thumbnail
    }
    
    func generate(with item: Plant, completion: @escaping (Image?)->Void ) {
        // I dont' think Plant() is threadsafe....  Do this on the main thread!
        processingQueue.sync { [weak self] in
            var result : Image? = nil
            if let strongSelf = self, let image = item.drawPlant(item.defaultIteration) {
                result = strongSelf.aspectResize( image )
            }
            // Edge case:  Nothing to send back!
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    func generate(with item: Rules, completion: @escaping (Image?)->Void ) {
        processingQueue.async { [weak self] in
            var result : Image? = nil
            let turtle = Turtle()
            turtle.rules = item
            if let strongSelf = self {
                turtle.backgroundColor = strongSelf.backgroundColor
                if let image = turtle.draw(item.defaultIteration) {
                    result = strongSelf.aspectResize( image )
                }
            }
            
            // Edge case:  Nothing to send back!
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    func generate(with item: Any, completion: @escaping (Image?)->Void ) {
        
        // Generate the image to show in the PDFView!
        if let plant = item as? Plant {
            generate(with: plant, completion: completion)
        }
        else if let rules = item as? Rules {
            generate(with: rules, completion: completion)
        }
        else {
            print( "Unknown Item!" )
        }
    }

}
