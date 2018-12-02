//
//  main.swift
//  Plant
//
//  Created by Scott Tury on 11/30/18.
//  Copyright © 2018 Scott Tury. All rights reserved.
//

import Foundation

// Sample code to generate a plant...
// ----------------------------------

let plant = Plant()

plant.branchAngle = 25.0
//plant.rules["0"] = "1[0][0]110" // Maple leaf

//plant.branchAngle = 25.0
//plant.rules["0"] =  "11[1[1[0]]]1[1[0]]1[1[0][1[0]]]" // Lopsided

//plant.rules["0"] =  "11[1[1[0]]][11[][0]]111[10]"  // SPARSE LOPSIDED

//plant.branchAngle = 25
//plant.rules["0"] = "11[[0]][[][0]]10" // Christmas
//plant.rules["0"] = "1[0][0]" // ? Plant
//plant.rules["0"] = "1[1[1[1[1[1[10]]]]]]0" // Paisley
//plant.rules["1"] = "11"

//let images = plant.iterativePlants(6, crop: true, offset: 50)
//for (index, plantImage) in images.enumerated() {
//    // print( "Plant for iteration \(index): \(plant.calculateRules(index))" )
//    // save the image to the disk!
//    _ = plantImage.export(name: "plant\(index)_cropped")
//}


if let plantImage = plant.iterativeGrowth(6, offset: 50) {
    _  = plantImage.export( name: "plant_iterative" )
}

