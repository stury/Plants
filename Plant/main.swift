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
    
    plant.branchAngle = 25.0
    plant.rules["0"] =  "11[1[1[0]]]1[1[0]]1[1[0][1[0]]]" // Lopsided
    
    //plant.rules["0"] =  "11[1[1[0]]][11[][0]]111[10]"  // SPARSE LOPSIDED
    
    //plant.branchAngle = 25
    //plant.rules["0"] = "11[[0]][[][0]]10" // Christmas
    //plant.rules["0"] = "1[0][0]" // ? Plant
    //plant.rules["0"] = "1[1[1[1[1[1[10]]]]]]0" // Paisley
    //plant.rules["1"] = "11"
    
    //plant.rules["0"] = "1[1[0][0]0][1[0][0]0]" // ? Plant
    //plant.rules["0"] = "1[1[0][0]][1[0][0]]" // ? Plant
    
//    plant.branchAngle = 25.0
//    plant.rules["0"] = "1[1[0]1[0]][1[0]1[0]]" // ? Plant
    
    //let images = plant.iterativePlants(6, crop: true, offset: 50)
    //for (index, plantImage) in images.enumerated() {
    //    // print( "Plant for iteration \(index): \(plant.calculateRules(index))" )
    //    // save the image to the disk!
    //    _ = plantImage.export(name: "plant\(index)_cropped")
    //}


//    plant.branchAngle = 25.7
//    plant.rules["0"] = "1[10]1[10]10" // ? Plant

    if let plantImage = plant.iterativeGrowth(6, offset: 50) {
        _  = plantImage.export( name: "plant_iterative" )
    }

}

let defaultLength = 20.0
let defaultIteration = 4

func drawTurtle( ) {
    let rules : [String:(Rules, Int)] = [
        "quadraticKochIsland": (Rules(initiator: "F-F-F-F", rules: ["F" : "F-F+F+FF-F-F+F"]), 4),
        "quadraticModifiedSnowflakeCurve": (Rules(initiator: "-F", rules: ["F" : "F+F-F-F+F"]),defaultIteration),
         "islandsAndLakes": (Rules(initiator: "F+F+F+F", rules: ["F" : "F+f-FF+F+FF+Ff+FF-f+FF-F-FF-Ff-FFF", "f":"ffffff"]),3),
        "koch_curve_a": (Rules(initiator: "F-F-F-F", rules: ["F" : "FF-F-F-F-F-F+F"]),defaultIteration),
        "koch_curve_b": (Rules(initiator: "F-F-F-F", rules: ["F" : "FF-F-F-F-FF"]),defaultIteration),
        "koch_curve_c": (Rules(initiator: "F-F-F-F", rules: ["F" : "FF-F+F-F-FF"] ),3),
        "koch_curve_d": (Rules(initiator: "F-F-F-F", rules: ["F" : "FF-F--F-F"] ),defaultIteration),
        "koch_curve_e": (Rules(initiator: "F-F-F-F", rules: ["F" : "F-FF--F-F"] ),5),
        "koch_curve_f": (Rules(initiator: "F-F-F-F", rules: ["F" : "F-F+F-F-F"] ),defaultIteration),
        
        "hex_curve": (Rules(initiator: "F+F+F", rules: ["F" : "F+F-F+F"], angle: 60, length: defaultLength, initialDirection: 90 ),defaultIteration),
        "tri_curve": (Rules(initiator: "F+F+F", rules: ["F" : "F+F-F+F"], angle: 120, length: defaultLength, initialDirection: 90 ),defaultIteration),
        "triangle_curve": (Rules(initiator: "F-F-F", rules: ["F" : "F+F-FF"], angle: 120, length: defaultLength, initialDirection: 90 ),defaultIteration),
        "koch_curve_flat_snowflake": (Rules(initiator: "F", rules: ["F" : "F+F--F+F"], angle: 60, length: defaultLength, initialDirection: 0 ),defaultIteration),
        "koch_curve_snowflake":(Rules(initiator: "+F--F--F", rules: ["F" : "F+F--F+F"], angle: 60, length: defaultLength, initialDirection: 0 ),defaultIteration),
        "scott_destructive_snowflake":(Rules(initiator: "F+F+F+F+F+F", rules: ["F" : "-F++FF-F"], angle: 60, length: defaultLength, initialDirection: 90 ),defaultIteration),
        "scott_destructive_tri":(Rules(initiator: "+F--F--F", rules: ["F" : "+F--FF+F"], angle: 60, length: defaultLength, initialDirection: 0 ),defaultIteration),
        
        "dragon-curve":(Rules(initiator: "L", rules: ["L" : "L+R+", "R" : "-L-R"], angle: 90, length: defaultLength, initialDirection: 90 ),10),
        "sierpinski_gasket":(Rules(initiator: "R", rules: ["L" : "R+L+R", "R" : "L-R-L"], angle: 60, length: defaultLength, initialDirection: 0 ),6),
        // Examples of edge-rewriting
        "hexagonal_gosper_curve":(Rules(initiator: "L", rules: ["L" : "L+R++R-L--LL-R+", "R" : "-L+RR++R+L--L-R"], angle: 60, length: defaultLength, initialDirection: 0 ),defaultIteration),
        "quadratic-Gosper_curve":(Rules(initiator: "-R", rules: ["L" : "LL-R-R+L+L-R-RL+R+LLR-L+R+LL+R-LR-R-L+L+RR-", "R" : "+LL-R-R+L+LR+L-RR-L-R+LRR-L-RL+L+R-R-L+L+RR"], angle: 90, length: defaultLength, initialDirection: 0 ),2),
        // Examples of Node rewriting
        "hilbert_curve":(Rules(initiator: "L", rules: ["L" : "+RF-LFL-FR+", "R" : "-LF+RFR+FL-"], angle: 90, length: defaultLength, initialDirection: 90, nodeRewriting: true ),5),
        "3x3_macrotile":(Rules(initiator: "-L", rules: ["L" : "LF+RFR+FL-F-LFLFL-FRFR+", "R" : "-LFLF+RFRFR+F+RF-LFL-FR"], angle: 90, length: defaultLength, initialDirection: 90, nodeRewriting: true ),3),
        "4x4_macrotile":(Rules(initiator: "-L", rules: ["L" : "LFLF+RFR+FLFL-FRF-LFL-FR+F+RF-LFL-FRFRFR+", "R" : "-LFLFLF+RFR+FL-F-LF+RFR+FLF+RFRF-LFL-FRFR"], angle: 90, length: defaultLength, initialDirection: 90, nodeRewriting: true ),2),
        "3x3_peano_curve":(Rules(initiator: "L", rules: ["L" : "LFRFL-F-RFLFR+F+LFRFL", "R" : "RFLFR+F+LFRFL-F-RFLFR"], angle: 90, length: defaultLength, initialDirection: 90, nodeRewriting: true ), 3),
        "5x5_macrotile":(Rules(initiator: "L", rules: ["L" : "L+F+R-F-L+F+R-F-L-F-R+F+L-F-R-F-L+F+R-F-L-F-R-F-L+F+R+F+L+F+R-F-L+F+R+F+L-F-R+F+L+F+R-F-L+F+R-F-L", "R" : "R-F-L+F+R-F-L+F+R+F+L-F-R+F+L+F+R-F-L+F+R+F+L+F+R-F-L-F-R-F-L+F+R-F-L-F-R+F+L-F-R-F-L+F+R-F-L+F+R"], angle: 45, length: defaultLength, initialDirection: 45, nodeRewriting: true ), 2)
    ]
    
    let turtle = Turtle()
    for (ruleName, (currentRule, iterations)) in rules {
        turtle.rules = currentRule
        turtle.border = 50.0
//        if let image = turtle.drawIterativeGrowth( iterations ) {
        if let image = turtle.drawIterativeGrowth( iterations, colors: [Turtle.colorAmberMonitor]) {
            _  = image.export( name: "turtle_iterative_\(ruleName)" )
        }
        if let image = turtle.draw(iterations) {
            _  = image.export( name: "turtle_draw_\(ruleName)" )
        }
    }
    
    // Koch Curve Snowflake:  Rules(initiator: "+F--F--F", rules: ["F" : "F+F--F+F"], angle: 60, length: 20.0, initialDirection: 0 )
    // R-F-L+F+R-F-L+F+R+F+L-F-R+F+L+F+R-F-L+F+R+F+L+F+R-F-L-F-R-F-L+F+R-F-L-F-R+F+L-F-R-F-L+F+R-F-L+F+R
//    turtle.rules = Rules(initiator: "L", rules: ["L" :
//        "+RF-LFL-FR+", "R" : "-LF+RFR+FL-"], angle: 90, length: defaultLength, initialDirection: 90, rewriting: true )
//    if let image = turtle.draw(4, border:50) {
//        _  = image.export( name: "turtle_draw" )
//    }
}

func drawPlantBracketedTurtle() {

    let rules : [String:(Rules, Int)] = [
        "a": (Rules(initiator: "F", rules: ["F" : "F[+F]F[-F]F"], angle:25.7), 5),
        "b": (Rules(initiator: "F", rules: ["F" : "F[+F]F[-F][F]"], angle:20), 5),
        "c": (Rules(initiator: "F", rules: ["F" : "FF-[-F+F+F]+[+F-F-F]"], angle:22.5), 4),
        "d": (Rules(initiator: "X", rules: ["X" : "F[+X]F[-X]+X", "F" : "FF"], angle:20, nodeRewriting: true), 7),
        "e": (Rules(initiator: "X", rules: ["X" : "F[+X][-X]FX", "F" : "FF"], angle:25.7, nodeRewriting: true), 7),
        "f": (Rules(initiator: "X", rules: ["X" : "F-[[X]+X]+F[+FX]-X", "F" : "FF"], angle:22.5, nodeRewriting: true), 5),
        "multirule": (Rules(initiator: "F", rules: ["F" : ["F[+F]F[-F]F","F[+F]F","F[-F]F"]], angle:22.5, nodeRewriting: true), 5)
    ]
    
    let turtle = Turtle()
    turtle.border = 50.0
    for (ruleName, (rule, iterations)) in rules {
        turtle.rules = rule
//        if let image = turtle.drawIterativeGrowth( iterations) {
        if let image = turtle.drawIterativeGrowth( iterations, colors:[Turtle.colorAmberMonitor]) {
            _  = image.export( name: "turtle_iterative_plant_\(ruleName)" )
        }
        if let image = turtle.draw(iterations) {
            _  = image.export( name: "turtle_plant_\(ruleName)" )
        }
    }

}

func stochasticPlant() {
    let turtle = Turtle()
    turtle.border = 50.0
    // Example of a Rule that have multiple possibilities for the replacement of 'F'...  Each replacement is picked randomly when building the plant.
    // This leads to variation in the plant, but it's clear overal that the plants are similar in nature.
    turtle.rules = Rules(initiator: "F", rules: ["F" : ["F[+F]F[-F]F","F[+F]F","F[-F]F"]], angle:22.5, nodeRewriting: true)

    var images = [Image]()
    
    for _ in 0...10 {
        if let image = turtle.drawCropped(6) {
            images.append(image)
        }
    }
    
    if let image = images.arrangedHorizontally() { // , backgroundColor: (1.0, 1.0, 1.0, 1.0) ) {
        _ = image.export( name: "stochastic_plant" )
    }

}

func modifierRule() {
    let turtle = Turtle()
    turtle.border = 50.0

    turtle.rules = Rules(initiator: "+F--F--F", rules: ["F" : "F+F--F+F"], angle: 60, length: 1200, initialDirection: 0, modifier: 3 )
    
//    if let image = turtle.drawIterativeGrowth( iterations, colors:[Turtle.colorAmberMonitor]) {
    if let image = turtle.drawIterativeGrowth( 5 ) {
        _  = image.export( name: "turtle_iterative_modifier" )
    }

}

drawPlant()
drawTurtle()
drawPlantBracketedTurtle()
stochasticPlant()
modifierRule()


