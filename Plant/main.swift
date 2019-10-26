//
//  main.swift
//  Plant
//
//  Created by Scott Tury on 11/30/18.
//  Copyright © 2018 Scott Tury. All rights reserved.
//

import Foundation

let fileWriter = try? FileWriter(additionalOutputDirectory: "Plant")

func plantCollection() ->[String:Plant] {
    var result = [String:Plant]()
            
    result["Maple_25"] = Plant(branchAngle: 25.0, rule0: "1[0][0]110")
    result["Maple_45"] = Plant(branchAngle: 45.0, rule0: "1[0][0]110")
    result["Favorite"] = Plant(branchAngle: 25.0, rule0: "11[1[1[0]]]1[1[0]]1[1[0][1[0]]]")
    result["SparseLopsided"] = Plant(rule0: "11[1[1[0]]][11[][0]]111[10]")
    result["Christmas"] = Plant(rule0: "11[[0]][[][0]]10")
    result["Christmas2"] = Plant(rule0: "11[[0]][[0][0]]10")
    result["Vase1"] = Plant(rule0: "1[0][0]")
    result["Vase2"] = Plant(rule0: "1[1[0][0]0][1[0][0]0]")
    result["Vase3"] = Plant(rule0: "1[1[0][0]][1[0][0]]")
    result["Vase4"] = Plant(rule0: "1[1[0][0]][1[0][0]]", rule1: "11[0]11")
    //result["Paisley"] = Plant(rule0: "1[1[1[1[1[1[10]]]]]]0", rule1: "1[0]11[0]1")
    result["Paisley"] = Plant(rule0: "1[1[1[1[1[1[10]]]]]]0", rule1: "11")
    result["Seaweed"] = Plant(rule0: "1[1[1[1[1[1[10]]]]]]0", rule1: "11[0[0]]")
    result["Thyme"] = Plant(rule0: "1[1[1[1[1[1[10]]]]]]0", rule1: "1[0]1")
    
    return result
}

/**
 This is a sample function based on my origiinal code from 1990!  Just a very basic Plant drawing implementation.
 */
func drawPlant() {
//    let plant = Plant()
//
//    plant.branchAngle = 25.0
//    plant.rules["0"] =  "11[1[1[0]]]1[1[0]]1[1[0][1[0]]]" // Lopsided
    
    let plants = plantCollection()
    for plantDescriptor in plants {
        // Test out the rasterization of the Plant class.
        if let plantImage = plantDescriptor.value.iterativeGrowth(6, offset: 50) {
            fileWriter?.export(type: .png, name: "plant_iterative_\(plantDescriptor.key)", data: plantImage.data())
        }

        if let plantImage = plantDescriptor.value.drawPlant(6) {
            fileWriter?.export(type: .png, name: "plant_iteration_6_\(plantDescriptor.key)", data: plantImage.data())
        }

        // Now test out rendering the image into a PDF.
        plantDescriptor.value.backgroundColor = Turtle.colorBackgroundTransparent
        if let pdfData = plantDescriptor.value.iterativeGrowthPdf(6, offset: 50) {
            fileWriter?.export( type: .pdf, name: "plant_iterative_\(plantDescriptor.key)", data: pdfData )
        }
        if let pdfData = plantDescriptor.value.drawPlantPdf(6) {
            fileWriter?.export(type: .pdf, name: "plant_iteration_6_\(plantDescriptor.key)", data: pdfData)
        }
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
    
    if let image = image, let filename = filename, let pngData = image.data(), let fileWriter = fileWriter  {
        fileWriter.export(fileType: "png", name: filename, data: pngData)
    }
    
    // Now do the same thing, but with the PDF routines...
    turtle.backgroundColor = Turtle.colorBackgroundTransparent
    var pdfData : Data?
    
    if let _ = range.min(), let _ = range.max() {
        pdfData = turtle.drawIterativeGrowthPdf(range)
    }
    
    if let pdfData = pdfData, let filename = filename  {
        fileWriter?.export(fileType: "pdf", name: filename, data: pdfData)
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
    
    if let image = image, let filename = filename  {
        fileWriter?.export(fileType: "png", name: filename, data: image.data())
    }

    // Now do the same for the PDF variants...
    turtle.backgroundColor = Turtle.colorBackgroundTransparent
    var pdfData : Data?
    
    //    if let image = turtle.drawIterativeGrowth( iterations, colors:[Turtle.colorAmberMonitor]) {
    pdfData = turtle.drawCroppedPdf(iteration)
    
    if let filename = filename  {
        fileWriter?.export(fileType: "pdf", name: filename, data: pdfData)
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
        "koch_curve_snowflake":(Rules(initiator: "F++F++F", rules: ["F" : "F−F++F−F"], angle: 60, length: defaultLength, initialDirection: 0 ),defaultIteration),
        "koch_curve_anti-snowflake":(Rules(initiator: "F++F++F", rules: ["F" : "F+F--F+F"], angle: 60, length: 5.0, initialDirection: 0), 5),
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
//        "scott_curve": (Rules(initiator: "F++F++F++F", rules: ["F" : "-F+F"], angle: 45, length: defaultLength, initialDirection: 90 ),defaultIteration),
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
        "Levy_Tapestry":(Rules(initiator: "F++F++F++F++", rules: ["F":"+F−−F+"], angle: 45, length: defaultLength, initialDirection: 0, nodeRewriting: false, modifier: 1), 10),

        "koch_curve_snowflake":(Rules(initiator: "F++F++F", rules: ["F" : "F−F++F−F"], angle: 60, length: defaultLength, initialDirection: 0 ),5),
        
        // https://en.wikipedia.org/wiki/L-system
        "koch_curve":(Rules(initiator: "F", rules: ["F" : "F+F−F−F+F"], angle: 90, length: defaultLength, initialDirection: 0 ),5),
        //    //"F++Ffff+F"
        "koch_curve_2":(Rules(initiator: "F", rules: ["F" : "F++Ffff+F"], angle: 90, length: defaultLength, initialDirection: 0 ),5),
            
            // https://nb.paulbutler.org/l-systems/
            // Based on complex image
        "complex_image":(Rules(initiator: "F", rules: ["F" : "+F+F--F+F"], angle: 60, length: defaultLength, initialDirection: 60 ),5),
            
            //'F', {'F': 'F[-F][+F]'}, 4, 30
        "simple_branching_tree":(Rules(initiator: "F", rules: ["F" : "F[-F][+F]"], angle: 30, length: defaultLength, initialDirection: 90 ),5),
            
            // 'F', {'F': 'FF[++F][-FF]'}, 5, 22
        "asymetric_branching_tree":(Rules(initiator: "F", rules: ["F" : "FF[++F][-FF]"], angle: 22, length: defaultLength, initialDirection: 90 ),5),
            
        // l_plot('A', {'F': 'FF', 'A': 'F[+AF-[A]--A][---A]'}, 5, 22.5)
        "branching_tree":(Rules(initiator: "A", rules: ["F": "FF", "A" : "F[+AF-[A]--A][---A]"], angle: 22.5, length: defaultLength, initialDirection: 90 , nodeRewriting: true),5),

        // http://www.kevs3d.co.uk/dev/lsystems/
        // All working!  There are a couple plants on this site I did not do.
        "joined_crosses_curve":(Rules(initiator: "XYXYXYX+XYXYXYX+XYXYXYX+XYXYXYX", rules: ["F": "", "X" : "FX+FX+FXFY-FY-", "Y":"+FX+FXFY-FY-FY"], angle: 90, length: defaultLength, initialDirection: 90 , nodeRewriting: true),3),
        "lace":(Rules(initiator: "W", rules: ["W": "+++X--F--ZFX+", "X" : "---W++F++YFW-", "Y":"+ZFX--F--Z+++", "Z":"-YFW++F++Y---"], angle: 30, length: defaultLength, initialDirection: 90 , nodeRewriting: false),6),
        // Also try the penrose tiling when you turn on node rewriting, it's interesting what comes out.
        "penrose_tiling":(Rules(initiator: "[F]++[F]++[F]++[F]++[F]", rules: ["F": "+GI--HI[---GI--FI]+", "G" : "-FI++GI[+++GI++HI]-", "H":"--GI++++FI[+HI++++GI]--GI", "I":""], angle: 36, length: defaultLength, initialDirection: 0 , nodeRewriting: false),6),
        "sierpinski_median_curve":(Rules(initiator: "L--F--L--F", rules: ["L": "+R-F-R+", "R" : "-L+F+L-"], angle: 45, length: defaultLength, initialDirection: 0 , nodeRewriting: false),8),
        "space_filling_curve":(Rules(initiator: "X", rules: ["X": "-YF+XFX+FY-", "Y" : "+XF-YFY-FX+"], angle: 90, length: defaultLength, initialDirection: 0 , nodeRewriting: true),6),
        //F=C0FF[C1-F++F][C2+F--F]C3++F--F
        "kevs_pond_weed":(Rules(initiator: "F", rules: ["F": "FF[-F++F][+F--F]++F--F"], angle: 27, length: defaultLength, initialDirection: 90 , nodeRewriting: true),5),
        
        // http://paulbourke.net/fractals/lsys/
        "pb_bush_1":(Rules(initiator: "Y", rules: ["X": "X[-FFF][+FFF]FX", "Y":"YFX[+Y][-Y]"], angle: 25.7, length: defaultLength, initialDirection: 90 , nodeRewriting: true),5),
        
        // axiom = F
        // F -> FF+[+F-F-F]-[-F+F+F]
        // angle = 22.5
        "pb_bush_2":(Rules(initiator: "F", rules: ["F": "FF+[+F-F-F]-[-F+F+F]", "Y":"YFX[+Y][-Y]"], angle: 22.5, length: defaultLength, initialDirection: 90 , nodeRewriting: true),5),
        
        //    axiom = F
        //    F -> F[+FF][-FF]F[-F][+F]F
        //    angle = 35
        "pb_bush_3":(Rules(initiator: "F", rules: ["F": "F[+FF][-FF]F[-F][+F]F"], angle: 35, length: defaultLength, initialDirection: 90 , nodeRewriting: true),5),
            
        //    Attributed to Saupe
        //    axiom = VZFFF
        //    V -> [+++W][---W]YV
        //    W -> +X[-W]Z
        //    X -> -W[+X]Z
        //    Y -> YZ
        //    Z -> [-FFF][+FFF]F
        //    angle = 20
        "pb_bush_4":(Rules(initiator: "VZFFF", rules: ["V":"[+++W][---W]YV", "W": "+X[-W]Z", "X":"-W[+X]Z", "Y":"YZ", "Z": "[-FFF][+FFF]F", "F":"F"], angle: 20, length: defaultLength, initialDirection: 90 , nodeRewriting: true),10),
            
        //    axiom = FX
        //    X -> >[-FX]+FX
        //    angle = 40
        "pb_bush_5":(Rules(initiator: "FX", rules: ["F":"FF", "X": ">[-FX]+FX"], angle: 40, length: defaultLength, initialDirection: 90 , nodeRewriting: true),7),
            
        //    axiom = Y---Y
        //    X -> {F-F}{F-F}--[--X]{F-F}{F-F}--{F-F}{F-F}--
        //    Y -> f-F+X+F-fY
        //    angle = 60
            // This one isn't quite right and doesn't look like what's published on the page.
        "mango_leaf":(Rules(initiator: "Y--Y", rules: ["X":"{F-F}{F-F}--[--X]{F-F}{F-F}--{F-F}{F-F}--", "Y": "f-F+X+F-fY"], angle: 60, length: defaultLength, initialDirection: 60 , nodeRewriting: true),8),

        //    axiom = (-D--D)
        //    A -> F++FFFF--F--FFFF++F++FFFF--F
        //    B -> F--FFFF++F++FFFF--F--FFFF++F
        //    C -> BFA--BFA
        //    D -> CFC--CFC
        //    angle = 45
        "kolam":(Rules(initiator: "(-D--D)", rules: ["A":"F++FFFF--F--FFFF++F++FFFF--F", "B": "F--FFFF++F++FFFF--F--FFFF++F", "C": "BFA--BFA", "D":"CFC--CFC"], angle: 45, length: defaultLength, initialDirection: 0 , nodeRewriting: true),3),
            
        //    axiom = F+XF+F+XF
        //    X -> X{F-F-F}+XF+F+X{F-F-F}+X
        //    angle = 90
        "snake_kolam":(Rules(initiator: "F+XF+F+XF", rules: ["X":"X{F-F-F}+XF+F+X{F-F-F}+X", "F": "F"], angle: 90, length: defaultLength, initialDirection: 0 , nodeRewriting: true),5),

        //    axiom = -X--X
        //    X -> XFX--XFX
        //    angle = 45
        "krishna_anklets":(Rules(initiator: "-X--X", rules: ["X":"XFX--XFX", "F": "F"], angle: 45, length: defaultLength, initialDirection: 0 , nodeRewriting: true),5),
            
        //    axiom = F++F++F++F++F
        //    F -> F++F++F|F-F++F
        //    angle = 36
        "pentaplexity":(Rules(initiator: "F++F++F++F++F", rules: ["F": "F++F++F|F-F++F"], angle: 36, length: defaultLength, initialDirection: 0 , nodeRewriting: false),4),

        //    axiom = aF
        //    a -> FFFFFv[+++h][---q]fb
        //    b -> FFFFFv[+++h][---q]fc
        //    c -> FFFFFv[+++fa]fd
        //    d -> FFFFFv[+++h][---q]fe
        //    e -> FFFFFv[+++h][---q]fg
        //    g -> FFFFFv[---fa]fa
        //    h -> ifFF
        //    i -> fFFF[--m]j
        //    j -> fFFF[--n]k
        //    k -> fFFF[--o]l
        //    l -> fFFF[--p]
        //    m -> fFn
        //    n -> fFo
        //    o -> fFp
        //    p -> fF
        //    q -> rfF
        //    r -> fFFF[++m]s
        //    s -> fFFF[++n]t
        //    t -> fFFF[++o]u
        //    u -> fFFF[++p]
        //    v -> Fv
        //    angle = 12
        "algae_1":(Rules(initiator: "aF", rules: ["a": "FFFFFv[+++h][---q]fb", "b":"FFFFFv[+++h][---q]fc", "c":"FFFFFv[+++fa]fd", "d":"FFFFFv[+++h][---q]fe", "e":"FFFFFv[+++h][---q]fg", "g":"FFFFFv[---fa]fa", "h":"ifFF", "i":"fFFF[--m]j", "j":"fFFF[--n]k", "k":"fFFF[--o]l", "l":"fFFF[--p]", "m":"fFn", "n":"fFo", "o":"fFp", "p":"fF", "q":"rfF", "r":"fFFF[++m]s", "s":"fFFF[++n]t", "t":"fFFF[++o]u", "u":"fFFF[++p]", "v":"Fv"], angle: 12, length: defaultLength, initialDirection: 90 , nodeRewriting: false),10),
            
        //    axiom = aF
        //    a -> FFFFFy[++++n][----t]fb
        //    b -> +FFFFFy[++++n][----t]fc
        //    c -> FFFFFy[++++n][----t]fd
        //    d -> -FFFFFy[++++n][----t]fe
        //    e -> FFFFFy[++++n][----t]fg
        //    g -> FFFFFy[+++fa]fh
        //    h -> FFFFFy[++++n][----t]fi
        //    i -> +FFFFFy[++++n][----t]fj
        //    j -> FFFFFy[++++n][----t]fk
        //    k -> -FFFFFy[++++n][----t]fl
        //    l -> FFFFFy[++++n][----t]fm
        //    m -> FFFFFy[---fa]fa
        //    n -> ofFFF
        //    o -> fFFFp
        //    p -> fFFF[-s]q
        //    q -> fFFF[-s]r
        //    r -> fFFF[-s]
        //    s -> fFfF
        //    t -> ufFFF
        //    u -> fFFFv
        //    v -> fFFF[+s]w
        //    w -> fFFF[+s]x
        //    x -> fFFF[+s]
        //    y -> Fy
        //    angle = 12
        "algae_2":(Rules(initiator: "aF", rules: ["a":"FFFFFy[++++n][----t]fb",
                                                      "b":"+FFFFFy[++++n][----t]fc",
                                                      "c":"FFFFFy[++++n][----t]fd",
                                                      "d":"-FFFFFy[++++n][----t]fe",
                                                      "e":"FFFFFy[++++n][----t]fg",
                                                      "g":"FFFFFy[+++fa]fh",
                                                      "h":"FFFFFy[++++n][----t]fi",
                                                      "i":"+FFFFFy[++++n][----t]fj",
                                                      "j":"FFFFFy[++++n][----t]fk",
                                                      "k":"-FFFFFy[++++n][----t]fl",
                                                      "l":"FFFFFy[++++n][----t]fm",
                                                      "m":"FFFFFy[---fa]fa",
                                                      "n":"ofFFF",
                                                      "o":"fFFFp",
                                                      "p":"fFFF[-s]q",
                                                      "q":"fFFF[-s]r",
                                                      "r":"fFFF[-s]",
                                                      "s":"fFfF",
                                                      "t":"ufFFF",
                                                      "u":"fFFFv",
                                                      "v":"fFFF[+s]w",
                                                      "w":"fFFF[+s]x",
                                                      "x":"fFFF[+s]",
                                                      "y":"Fy"], angle: 12, length: defaultLength, initialDirection: 90 , nodeRewriting: false),10),
            
        //    axiom = F
        //    F -> FF-[XY]+[XY]
        //    X -> +FY
        //    Y -> -FX
        //    angle = 22.5
        "weed_1":(Rules(initiator: "F", rules: ["F":"FF-[XY]+[XY]",
                                                      "X":"+FY",
                                                      "Y":"-FX"], angle: 22.5, length: defaultLength, initialDirection: 90 , nodeRewriting: true),6),
            
        //    axiom = F+F+F
        //    F -> F-F+F
        //    angle = 120
        "triangle":(Rules(initiator: "F+F+F", rules: ["F":"F-F+F"], angle: 120, length: defaultLength, initialDirection: 90 , nodeRewriting: true),6),

        //    axiom = F
        //    F -> F-F+F+F-F
        //    angle = 90
        "quadratic_snowflake":(Rules(initiator: "F", rules: ["F":"F-F+F+F-F"], angle: 90, length: defaultLength, initialDirection: 0 , nodeRewriting: false),4),
        "enclosed_quadratic_snowflake":(Rules(initiator: "F+F+F+F", rules: ["F":"F-F+F+F-F"], angle: 90, length: defaultLength, initialDirection: 0 , nodeRewriting: false),4),
         "cross_quadratic_snowflake":(Rules(initiator: "FF+FF+FF+FF", rules: ["F":"F-F+F+F-F"], angle: 90, length: defaultLength, initialDirection: 0 , nodeRewriting: false),4),

        //    Variation by Hasan Hosam.
        //    December 2018
        //    axiom = FF+FF+FF+FF
        //    F -> F+F-F-F+F
        //    angle = 90
        "variation_quadratic_snowflake":(Rules(initiator: "FF+FF+FF+FF", rules: ["F":"F+F-F-F+F"], angle: 90, length: defaultLength, initialDirection: 90 , nodeRewriting: true),4)
    ]
    
    let turtle = Turtle()
    for (ruleName, (currentRule, iterations)) in rules {
        turtle.backgroundColor = Turtle.colorBackgroundBlack
        turtle.rules = currentRule
        turtle.border = 50.0
//        if let image = turtle.drawIterativeGrowth( iterations ) {
        if let image = turtle.drawIterativeGrowth( iterations, colors: [Turtle.colorAmberMonitor]) {
            fileWriter?.export(fileType: "png", name: "turtle_iterative_\(ruleName)", data: image.data())
        }
        if let image = turtle.draw(iterations) {
            fileWriter?.export(fileType: "png", name: "turtle_draw_\(ruleName)", data: image.data())
        }

        // Also write out PDF variants
        turtle.backgroundColor = Turtle.colorBackgroundTransparent
        if let image = turtle.drawIterativeGrowthPdf( iterations, colors: [Turtle.colorAmberMonitor] ) {
            fileWriter?.export(fileType: "pdf", name: "turtle_iterative_\(ruleName)", data: image)
        }
        if let image = turtle.drawPdf(iterations) {
            fileWriter?.export(fileType: "pdf", name: "turtle_draw_\(ruleName)", data: image)
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
        turtle.backgroundColor = Turtle.colorBackgroundBlack
//        if let image = turtle.drawIterativeGrowth( iterations) {
        if let image = turtle.drawIterativeGrowth( iterations, colors:[Turtle.colorAmberMonitor]) {
            fileWriter?.export(fileType: "png", name: "turtle_iterative_plant_\(ruleName)", data: image.data())
        }
        if let image = turtle.draw(iterations) {
            fileWriter?.export(fileType: "png", name: "turtle_plant_\(ruleName)", data: image.data())
        }
        
        // Output PDF images as well!
        turtle.backgroundColor = Turtle.colorBackgroundTransparent
        if let image = turtle.drawIterativeGrowthPdf( iterations, colors:[Turtle.colorAmberMonitor] ) {
            fileWriter?.export(fileType: "pdf", name: "turtle_iterative_plant_\(ruleName)", data: image)
        }
        if let image = turtle.drawPdf(iterations) {
            fileWriter?.export(fileType: "pdf", name: "turtle_plant_\(ruleName)", data: image)
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
        fileWriter?.export(fileType: "png", name: "stochastic_plant", data: image.data())
    }

    // Let's do the same with PDF
    turtle.backgroundColor = Turtle.colorBackgroundTransparent
    var pdfImages = [Data]()
    
    for _ in 0...10 {
        if let image = turtle.drawCroppedPdf(6) {
            pdfImages.append(image)
        }
    }
    
    if let image = pdfImages.arrangedHorizontally() { // , backgroundColor: (1.0, 1.0, 1.0, 1.0) ) {
        fileWriter?.export(fileType: "pdf", name: "stochastic_plant", data: image)
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
        fileWriter?.export(fileType: "png", name: "turtle_iterative_modifier", data: image.data())
    }

    // Now test out the PDF methods
    turtle.backgroundColor = Turtle.colorBackgroundTransparent
    if let image = turtle.drawIterativeGrowthPdf( 5, mode: .top ) {
        fileWriter?.export(fileType: "pdf", name: "turtle_iterative_modifier", data: image)
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
        fileWriter?.export(fileType: "png", name: "turtle_iterative_serpinski_carpet", data: image.data())
    }

    // Test out the same thing with PDF
    turtle.backgroundColor = Turtle.colorBackgroundTransparent
    if let image = turtle.drawIterativeGrowthPdf( 6, mode: .bottom ) {
        fileWriter?.export(fileType: "pdf", name: "turtle_iterative_serpinski_carpet", data: image)
    }

}

drawPlant()
//drawTurtle()
//drawPlantBracketedTurtle()
//stochasticPlant()
//modifierRule()
//serpinskiCarpet()
//
//// This rule set needs node rewriting to remove the extra letters in the final rule set to draw.
////n = 3, δ = 60°
////{XF+F+XF+F+XF+F}
////X → XF+F+XF−F−F−XF−F+F+F−F+F+F−X
//_ = drawIterativeRules(Rules(initiator: "{XF+F+XF+F+XF+F}", rules: ["X" : "XF+F+XF−F−F−XF−F+F+F−F+F+F−X"], angle: 60,  length: 600, initialDirection: 0, nodeRewriting: true, modifier: 2), range: 0..<6, filename: "sample")
//
//// Attempt at twin dragon:
//// http://ecademy.agnesscott.edu/~lriddle/ifs/heighway/twindragon.htm
//_ = drawIterativeRules(Rules(initiator: "FX----FX", rules: ["X" : "+FX--FY+", "Y": "-FX++FY-", "F":"Z" ], angle: 45,  length: defaultLength, initialDirection: 0, nodeRewriting: true, modifier: 1), range: 0..<12, filename: "twin-dragon")
//
//// Attempt at terdragon:
//// http://ecademy.agnesscott.edu/~lriddle/ifs/heighway/terdragon.htm
//_ = drawIterativeRules(Rules(initiator: "F", rules: ["F" : "+F----F++++F-" ], angle: 30,  length: defaultLength, initialDirection: 0, nodeRewriting: false, modifier: 1), range: 0..<6, filename: "terdragon")
//
//// Attempt at Sierpinski Gadget:
//// http://ecademy.agnesscott.edu/~lriddle/ifs/siertri/siertri.htm
//_ = drawIterativeRules(Rules(initiator: "F+F+F", rules: ["F" : "F+F-F-F+F" ], angle: 120,  length: defaultLength, initialDirection: 0, nodeRewriting: false, modifier: 1), range: 0..<6, filename: "Sierpinski_Gasket")
//_ = drawIterativeRules(Rules(initiator: "FX", rules: ["F" : "Z", "X":"+FY-FX-FY+", "Y":"-FX+FY+FX-" ], angle: 60,  length: defaultLength, initialDirection: 0, nodeRewriting: true, modifier: 1), range: 0..<6, filename: "Sierpinski_Gasket_nodeRewriting")
//
