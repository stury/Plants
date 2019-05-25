//
//  main.swift
//  Plant
//
//  Created by Scott Tury on 11/30/18.
//  Copyright © 2018 Scott Tury. All rights reserved.
//

import Foundation


/**
 This is a sample function based on my origiinal code from 1990!  Just a very basic Plant drawing implementation.
 */
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

// MARK: - Generic drawing methods

/**
 This function renders sequential images with a range to a file.
 - parameter rules: The rule to render
 - parameter range: The range of generations of the rule you want to generate
 - parameter filename: optional filename you want to use to save the image.
 */
func drawIterativeRules( _ rules: Rules, range: Range<Int>, filename: String? ) -> Image? {
    
    let turtle = Turtle()
    turtle.border = 50.0
    turtle.rules = rules
    
    var image : Image?
    
    if let _ = range.min(), let _ = range.max() {
        //    if let image = turtle.drawIterativeGrowth( iterations, colors:[Turtle.colorAmberMonitor]) {
        image = turtle.drawIterativeGrowth( range, mode: .bottom )
    }
    else {
        
    }
    
    if let image = image, let filename = filename {
        _  = image.export( name: filename )
    }
    
    return image
}

/**
 This function renders sequential images with a range to a file.
 - parameter rules: The rule to render
 - parameter iterations: Assumes you want to generate the iterations from 0..<iterations specified.
 - parameter filename: optional filename you want to use to save the image.
 */
func drawIterativeRules( _ rules: Rules, iterations: Int, filename: String? ) -> Image? {
    return drawIterativeRules( rules, range: 0..<iterations, filename: filename )
}

/**
 This function renders a specific iteration of the given Rules.
 - parameter rules: The rule to render
 - parameter iteration: The iteration/generation of the ruleset you want to render.
 - parameter filename: optional filename you want to use to save the image.
 */
func drawIteration( _ rules: Rules, iteration: Int, filename: String? ) -> Image? {
    let turtle = Turtle()
    turtle.border = 50.0
    turtle.rules = rules
    
    var image : Image?
    
    //    if let image = turtle.drawIterativeGrowth( iterations, colors:[Turtle.colorAmberMonitor]) {
    image = turtle.drawCropped(iteration) //draw(iteration)
    
    if let image = image, let filename = filename {
        _  = image.export( name: filename )
    }
    
    return image
}

// MARK: -

/// default segment length
let defaultLength = 20.0
/// default iteration to generate
let defaultIteration = 4

/**
 This function runs through a bunch of predefined Rules, and renders each of them to a file.
 */
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
//        "hex_curve_updated": (Rules(initiator: "F+F+F+F+F+F", rules: ["F" : "--FX--FX--FX--FX--FX--FX", "X" : "F+F+F+F+F+F"], angle: 60, length: 1000, initialDirection: 90, modifier: 2 ),defaultIteration),
//        "hex_curve_updated": (Rules(initiator: "F+F+F+F+F+F", rules: ["F" : "--F+F+F+F+F+FX", "X" : "F+F+F+F+F+F"], angle: 60, length: 1000, initialDirection: 90, modifier: 2 ),defaultIteration),
//        "hex_curve_updated": (Rules(initiator: "F+F+F+F+F+F", rules: ["F" : "+[--F+F+F+F+F+F+][+F]"], angle: 60, length: 100, initialDirection: 90 ),defaultIteration),
        "hex_curve_updated": (Rules(initiator: "H", rules: ["H" : "FT+FT+FT+FT+FT+FT", "T" : "--FH--FH--FH", "F" : "FF"], angle: 60, length: defaultLength, initialDirection: 90, modifier: 1 ),8),

        "tri_curve": (Rules(initiator: "F+F+F", rules: ["F" : "F+F-F+F"], angle: 120, length: defaultLength, initialDirection: 90 ),defaultIteration),
        "triangle_curve": (Rules(initiator: "F-F-F", rules: ["F" : "F+F-FF"], angle: 120, length: defaultLength, initialDirection: 90 ),defaultIteration),
        "koch_curve_flat_snowflake": (Rules(initiator: "F", rules: ["F" : "F+F--F+F"], angle: 60, length: defaultLength, initialDirection: 0 ),defaultIteration),
        "koch_curve_snowflake":(Rules(initiator: "+F--F--F", rules: ["F" : "F+F--F+F"], angle: 60, length: defaultLength, initialDirection: 0 ),defaultIteration),
        "scott_destructive_snowflake":(Rules(initiator: "F+F+F+F+F+F", rules: ["F" : "-F++FF-F"], angle: 60, length: defaultLength, initialDirection: 90 ),defaultIteration),
        "scott_destructive_tri":(Rules(initiator: "+F--F--F", rules: ["F" : "+F--FF+F"], angle: 60, length: defaultLength, initialDirection: 0 ),defaultIteration),
        
        "dragon-curve":(Rules(initiator: "L", rules: ["L" : "L+R+", "R" : "-L-R"], angle: 90, length: defaultLength, initialDirection: 90 ),10),
        "sierpinski_gasket":(Rules(initiator: "R", rules: ["L" : "R+L+R", "R" : "L-R-L"], angle: 60, length: defaultLength, initialDirection: 0 ),6),
        // http://ecademy.agnesscott.edu/~lriddle/ifs/siertri/siertri.htm
        // These seem to only work in certain situations.
        "sierpinski_gasket_hexagon_outward":(Rules(initiator: "R-R-R-R-R-R-", rules: ["L" : "R+L+R", "R" : "L-R-L"], angle: 60, length: defaultLength, initialDirection: 0 ),7),
        "sierpinski_gasket_hexagon_inward":(Rules(initiator: "L-L-L-L-L-L-", rules: ["L" : "R+L+R", "R" : "L-R-L"], angle: 60, length: defaultLength, initialDirection: 0 ),7),
        // Examples of edge-rewriting
        "hexagonal_gosper_curve":(Rules(initiator: "L", rules: ["L" : "L+R++R-L--LL-R+", "R" : "-L+RR++R+L--L-R"], angle: 60, length: defaultLength, initialDirection: 0 ),defaultIteration),
        "quadratic-Gosper_curve":(Rules(initiator: "-R", rules: ["L" : "LL-R-R+L+L-R-RL+R+LLR-L+R+LL+R-LR-R-L+L+RR-", "R" : "+LL-R-R+L+LR+L-RR-L-R+LRR-L-RL+L+R-R-L+L+RR"], angle: 90, length: defaultLength, initialDirection: 0 ),2),
        // Examples of Node rewriting
        "hilbert_curve":(Rules(initiator: "L", rules: ["L" : "+RF-LFL-FR+", "R" : "-LF+RFR+FL-"], angle: 90, length: defaultLength, initialDirection: 90, nodeRewriting: true ),5),
        "3x3_macrotile":(Rules(initiator: "-L", rules: ["L" : "LF+RFR+FL-F-LFLFL-FRFR+", "R" : "-LFLF+RFRFR+F+RF-LFL-FR"], angle: 90, length: defaultLength, initialDirection: 90, nodeRewriting: true ),3),
        "4x4_macrotile":(Rules(initiator: "-L", rules: ["L" : "LFLF+RFR+FLFL-FRF-LFL-FR+F+RF-LFL-FRFRFR+", "R" : "-LFLFLF+RFR+FL-F-LF+RFR+FLF+RFRF-LFL-FRFR"], angle: 90, length: defaultLength, initialDirection: 90, nodeRewriting: true ),2),
        "3x3_peano_curve":(Rules(initiator: "L", rules: ["L" : "LFRFL-F-RFLFR+F+LFRFL", "R" : "RFLFR+F+LFRFL-F-RFLFR"], angle: 90, length: defaultLength, initialDirection: 90, nodeRewriting: true ), 3),
        "5x5_macrotile":(Rules(initiator: "L", rules: ["L" : "L+F+R-F-L+F+R-F-L-F-R+F+L-F-R-F-L+F+R-F-L-F-R-F-L+F+R+F+L+F+R-F-L+F+R+F+L-F-R+F+L+F+R-F-L+F+R-F-L", "R" : "R-F-L+F+R-F-L+F+R+F+L-F-R+F+L+F+R-F-L+F+R+F+L+F+R-F-L-F-R-F-L+F+R-F-L-F-R+F+L-F-R-F-L+F+R-F-L+F+R"], angle: 45, length: defaultLength, initialDirection: 45, nodeRewriting: true ), 2)
        ,
        "square-grid-approximation-of-the-Sierpinski-curve":(Rules(initiator: "F+XF+F+XF", rules: ["X" : "XF-F+F-XF+F+XF-F+F-X", "F":"F"], angle: 90.0, length: defaultLength, initialDirection: 0, nodeRewriting: true, modifier: 1), 4),
        "scott_curve": (Rules(initiator: "F++F++F++F", rules: ["F" : "-F+F"], angle: 45, length: defaultLength, initialDirection: 90 ),defaultIteration),
        // http://ecademy.agnesscott.edu/~lriddle/ifs/pentigre/pentigre2.htm
        "McWhorter_Pentigree":(Rules(initiator: "F", rules: ["F":"+F++F−−−−F−−F++F++F−"], angle: 36, length: defaultLength, initialDirection: 0, nodeRewriting: false, modifier: 1), 4),
        // http://ecademy.agnesscott.edu/~lriddle/ifs/pentigre/pentigreeForm2.htm
        "McWhorter_Pentigree_2nd_form":(Rules(initiator: "F++F++F++F++F", rules: ["F":"+F++F−−−−F−−F++F++F−"], angle: 36, length: defaultLength, initialDirection: 0, nodeRewriting: false, modifier: 1), 4),
        // http://ecademy.agnesscott.edu/~lriddle/ifs/pentaden/penta.htm
        "McWhorter_Pentadentrite":(Rules(initiator: "F", rules: ["F":"F+F-F--F+F+F"], angle: 72, length: defaultLength, initialDirection: 0, nodeRewriting: false, modifier: 1), 4),
        // http://ecademy.agnesscott.edu/~lriddle/ifs/pentaden/pentadenForm2.htm
        "McWhorter_Pentadentrite_2nd":(Rules(initiator: "F+F+F+F+F", rules: ["F":"F+F-F--F+F+F"], angle: 72, length: defaultLength, initialDirection: 0, nodeRewriting: false, modifier: 1), 4),
        // Lévy_Dragon  http://ecademy.agnesscott.edu/~lriddle/ifs/levy/levy.htm
        "Levy_Dragon":(Rules(initiator: "F", rules: ["F":"+F−−F+"], angle: 45, length: defaultLength, initialDirection: 0, nodeRewriting: false, modifier: 1), 10),
        "Levy_Tapestry":(Rules(initiator: "F++F++F++F++", rules: ["F":"+F−−F+"], angle: 45, length: defaultLength, initialDirection: 0, nodeRewriting: false, modifier: 1), 10)


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

/**
 This function renders some simmple 2D plant structures using the Turtle commands.
 */
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

/**
 This function renders 10 different iterations of the same plant rules.  Each plant should grow a bit differently.
 */
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

/**
 This function shows an example Rule set using the modifier rules.  Modifier meand you are trying to generate the
 resulting images for each generation at the same over all size.  So each iteration you divide the length by the
 modifier value.
 */
func modifierRule() {
    let turtle = Turtle()
    turtle.border = 50.0

    turtle.rules = Rules(initiator: "+F--F--F", rules: ["F" : "F+F--F+F"], angle: 60, length: 1200, initialDirection: 0, modifier: 3 )
    
//    if let image = turtle.drawIterativeGrowth( iterations, colors:[Turtle.colorAmberMonitor]) {
    if let image = turtle.drawIterativeGrowth( 5, mode: .top ) {
        _  = image.export( name: "turtle_iterative_modifier" )
    }
}

/**
 This function renders the Serpinski Carpet.
 */
func serpinskiCarpet() {
    let turtle = Turtle()
    turtle.border = 50.0

    // Serpinsk Carpet, but there are extra lines through the empty sections.  (See below for a better one.)
//    turtle.rules = Rules(initiator: "F", rules: ["F" : "F+F-F-F-G+F+F+F-F", "G":"GGG"], angle: 90, length: 1200, initialDirection: 45, modifier: 3 )

    // Serpinsk Carpet, corrected.
    // http://ecademy.agnesscott.edu/~lriddle/ifs/carpet/carpet.htm
    turtle.rules = Rules(initiator: "F", rules: ["F" : "F+F−F−F−f+F+F+F−F", "f":"fff"], angle: 90,  length: 2400, initialDirection: 45, modifier: 3)

    // This one is really interesting, but not what I was looking for.  Snake?
    //turtle.rules = Rules(initiator: "F", rules: ["F" : "F+F−F−F−fGf+F+F+F−F", "G":"GGG"], angle: 90, length: 2400, initialDirection: 45, modifier: 3 )

    
    //    if let image = turtle.drawIterativeGrowth( iterations, colors:[Turtle.colorAmberMonitor]) {
    if let image = turtle.drawIterativeGrowth( 6, mode: .bottom ) {
        _  = image.export( name: "turtle_iterative_serpinski_carpet" )
    }
}

drawPlant()
drawTurtle()
drawPlantBracketedTurtle()
stochasticPlant()
modifierRule()
serpinskiCarpet()

// This rule set needs node rewriting to remove the extra letters in the final rule set to draw.
//n = 3, δ = 60°
//{XF+F+XF+F+XF+F}
//X → XF+F+XF−F−F−XF−F+F+F−F+F+F−X
_ = drawIterativeRules(Rules(initiator: "{XF+F+XF+F+XF+F}", rules: ["X" : "XF+F+XF−F−F−XF−F+F+F−F+F+F−X"], angle: 60,  length: 600, initialDirection: 0, nodeRewriting: true, modifier: 2), range: 0..<6, filename: "sample")

// Attempt at twin dragon:
// http://ecademy.agnesscott.edu/~lriddle/ifs/heighway/twindragon.htm
_ = drawIterativeRules(Rules(initiator: "FX----FX", rules: ["X" : "+FX--FY+", "Y": "-FX++FY-", "F":"Z" ], angle: 45,  length: defaultLength, initialDirection: 0, nodeRewriting: true, modifier: 1), range: 0..<12, filename: "twin-dragon")

// Attempt at terdragon:
// http://ecademy.agnesscott.edu/~lriddle/ifs/heighway/terdragon.htm
_ = drawIterativeRules(Rules(initiator: "F", rules: ["F" : "+F----F++++F-" ], angle: 30,  length: defaultLength, initialDirection: 0, nodeRewriting: false, modifier: 1), range: 0..<6, filename: "terdragon")

// Attempt at Sierpinski Gadget:
// http://ecademy.agnesscott.edu/~lriddle/ifs/siertri/siertri.htm
_ = drawIterativeRules(Rules(initiator: "F+F+F", rules: ["F" : "F+F-F-F+F" ], angle: 120,  length: defaultLength, initialDirection: 0, nodeRewriting: false, modifier: 1), range: 0..<6, filename: "Sierpinski_Gasket")
_ = drawIterativeRules(Rules(initiator: "FX", rules: ["F" : "Z", "X":"+FY-FX-FY+", "Y":"-FX+FY+FX-" ], angle: 60,  length: defaultLength, initialDirection: 0, nodeRewriting: true, modifier: 1), range: 0..<6, filename: "Sierpinski_Gasket_nodeRewriting")

