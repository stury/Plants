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
func drawPlant() {
    let plant = Plant()
    
    //plant.branchAngle = 25.0
    //plant.rules["0"] = "1[0][0]110" // Maple leaf
    
    //plant.branchAngle = 25.0
    //plant.rules["0"] =  "11[1[1[0]]]1[1[0]]1[1[0][1[0]]]" // Lopsided
    
    //plant.rules["0"] =  "11[1[1[0]]][11[][0]]111[10]"  // SPARSE LOPSIDED
    
    //plant.branchAngle = 25
    //plant.rules["0"] = "11[[0]][[][0]]10" // Christmas
    //plant.rules["0"] = "1[0][0]" // ? Plant
    //plant.rules["0"] = "1[1[1[1[1[1[10]]]]]]0" // Paisley
    //plant.rules["1"] = "11"
    
    //plant.rules["0"] = "1[1[0][0]0][1[0][0]0]" // ? Plant
    //plant.rules["0"] = "1[1[0][0]][1[0][0]]" // ? Plant
    
    plant.branchAngle = 25.0
    plant.rules["0"] = "1[1[0]1[0]][1[0]1[0]]" // ? Plant
    
    //let images = plant.iterativePlants(6, crop: true, offset: 50)
    //for (index, plantImage) in images.enumerated() {
    //    // print( "Plant for iteration \(index): \(plant.calculateRules(index))" )
    //    // save the image to the disk!
    //    _ = plantImage.export(name: "plant\(index)_cropped")
    //}
    
    
    if let plantImage = plant.iterativeGrowth(8, offset: 50) {
        _  = plantImage.export( name: "plant_iterative" )
    }

}

func drawTurtle( ) {
    let rules : [String:Rules] = [
        "quadraticKochIsland": Rules(initiator: "F-F-F-F", rules: ["F" : "F-F+F+FF-F-F+F"]),
        "quadraticModifiedSnowflakeCurve": Rules(initiator: "-F", rules: ["F" : "F+F-F-F+F"]),
         "islandsAndLakes": Rules(initiator: "F+F+F+F", rules: ["F" : "F+f-FF+F+FF+Ff+FF-f+FF-F-FF-Ff-FFF", "f":"ffffff"]),
        "koch_curve_a": Rules(initiator: "F-F-F-F", rules: ["F" : "FF-F-F-F-F-F+F"]),
        "koch_curve_b": Rules(initiator: "F-F-F-F", rules: ["F" : "FF-F-F-F-FF"]),
        "koch_curve_c": Rules(initiator: "F-F-F-F", rules: ["F" : "FF-F+F-F-FF"] ),
        "koch_curve_d":Rules(initiator: "F-F-F-F", rules: ["F" : "FF-F--F-F"] ),
        "koch_curve_e":Rules(initiator: "F-F-F-F", rules: ["F" : "F-FF--F-F"] ),
        "koch_curve_f":Rules(initiator: "F-F-F-F", rules: ["F" : "F-F+F-F-F"] )
    ]
    
    let turtle = Turtle()
    for (ruleName, currentRule) in rules {
        turtle.rules = currentRule
        if let image = turtle.drawIterativeGrowth(4, border: 50) {
            _  = image.export( name: "turtle_iterative_\(ruleName)" )
        }
    }
    
//    if let image = turtle.draw(4, border:50) {
//        _  = image.export( name: "turtle_draw" )
//    }
}

drawPlant()
drawTurtle()
