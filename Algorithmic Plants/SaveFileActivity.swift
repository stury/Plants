//
//  SaveFileActivity.swift
//  Digital Plants
//
//  Created by Scott Tury on 11/24/19.
//  Copyright © 2019 Scott Tury. All rights reserved.
//

import UIKit
import CoreImage
import MobileCoreServices

class SaveFileActivity: UIActivity {

 
    override var activityType: UIActivity.ActivityType? {
        get {
            return .init("Save File")
        }
    }
    
    override var activityTitle: String? {
        get {
            return NSLocalizedString("Save File", comment: "Save Item to File")
        }
    }
    
    override var activityImage: UIImage? {
        get {
            return UIImage(named: "PDFDocument")
        }
    }
    
    /// Simple function to determine if a Data object is a PDF file.
    func isPDFData( data: Data ) -> Bool {
        var result = false
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
                
                //print( "imageSource type is \(type)")
                // If it's a PDF, we need to load in the file differently.
                if type == kUTTypePDF as String {
                    result = true
                }
            }
        }
        return result
    }
                
    // Method to determine which item we can process in this activity.
    func canProcessItems(withActivityItems activityItems: [Any]) -> [Any] {
        var result : [Any] = [Any]()
    
        for item in activityItems {
            if let data = item as? Data, isPDFData(data: data) {
                result.append(data)
            }
            else if let url = item as? URL {
                if  url.isFileURL && url.pathExtension == "pdf" {
                    result.append(url)
                }
            }
        }
        return result
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        var result : Bool = false
        
        let items = canProcessItems(withActivityItems: activityItems)
        result = items.count > 0
        
        return result
    }
    
    var pdfData : Data?
    var pdfFile : URL?
    var viewController : UIDocumentPickerViewController?
    
    override func prepare(withActivityItems activityItems: [Any]) {
        let items = canProcessItems(withActivityItems: activityItems)
        for item in items {
            if let item = item as? Data {
                if pdfData == nil {
                    pdfData = item
                }
            }
            else if let item = item as? URL {
                if pdfFile == nil {
                    pdfFile = item
                }
            }
        }
        
        if let pdfFile = pdfFile {
            // So we are keeping track of the items we need to export to a file.
            // Prefer the file to the Data object.
            // Present the save controller. We've set it to `exportToService` in order
            // to export the data -- OLD COMMENT
            viewController = UIDocumentPickerViewController(url: pdfFile, in: UIDocumentPickerMode.exportToService)
        }
        else if let pdfData = pdfData {
            // Export the data to the system, then use that to construct the Document Picker.
            let fileManager = FileManager.default

            do {
                let tempURL = fileManager.temporaryDirectory.appendingPathComponent("L-System .pdf")

                // Write the data out into the file
                try pdfData.write(to: tempURL)

                // Present the save controller. We've set it to `exportToService` in order
                // to export the data -- OLD COMMENT
                viewController = UIDocumentPickerViewController(url: tempURL, in: UIDocumentPickerMode.exportToService)
            }
            catch {
                print( "Oops!  Error when trying to export the PDFData! \(error)" )
            }
        }

    }
    
    override class var activityCategory: UIActivity.Category {
        get {
            return .action //.share
        }
    }
    
    override var activityViewController: UIViewController? {
        get {
            return viewController
        }
    }
    
}
