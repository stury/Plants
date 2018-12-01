//
//  main.swift
//  Plant
//
//  Created by Scott Tury on 11/30/18.
//  Copyright © 2018 Scott Tury. All rights reserved.
//

import Foundation

/// simple method to allow us to export an image to the disk.
func image(with image: Image, name: String = "maze") -> Image? {
    
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    if let documentURL = URL(string: "\(name).png", relativeTo: URL(fileURLWithPath: documentsPath)) {
        image.output(documentURL)
    }
    
    return image
}

// Sample code to generate a plant...
// ----------------------------------

let plant = Plant()

//plant.branchAngle = 30.0
//plant.rules["0"] = "1[0][0]110"
plant.branchAngle = 25.0
plant.rules["0"] =  "11[1[1[0]]]1[1[0]]1[1[0][1[0]]]" // "11[1[1[0]]][11[][0]]111[10]"

for i in 0...6 {
    print( "Plant for iteration \(i): \(plant.calculateRules(i))" )
    if let plantImage = plant.drawPlant(i) {
        print("limit left: \(plant.limitLeft), left: \(plant.limitRight)")
        if let cropImage = plantImage.crop(CGRect(x: plant.limitLeft, y: 0, width: (plant.limitRight - plant.limitLeft), height: plantImage.size.height)) {

            // save the image to the disk!
            _ = image(with: cropImage, name: "plant\(i)_cropped")
        }
        else {
            // save the image to the disk!
            _ = image(with: plantImage, name: "plant\(i)")
        }
    }
}

