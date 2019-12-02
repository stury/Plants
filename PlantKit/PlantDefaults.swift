//
//  PlantDefaults.swift
//  PlantKit
//
//  Created by Scott Tury on 11/9/19.
//  Copyright © 2019 Scott Tury. All rights reserved.
//

import Foundation

/**
 This function will return a collection of default Plant objects, already configured.
 */
public func defaultPlantCollection() ->[Plant] {
    var result = [Plant]()
            
    result.append( Plant(name: "Maple 25", branchAngle: 25.0, rule0: "1[0][0]110") )
    result.append( Plant(name: "Maple 45", branchAngle: 45.0, rule0: "1[0][0]110") )
    result.append( Plant(name: "Maple 65", branchAngle: 65.0, rule0: "1[0][0]110") )
    result.append( Plant(name: "Favorite", branchAngle: 25.0, rule0: "11[1[1[0]]]1[1[0]]1[1[0][1[0]]]") )
    result.append( Plant(name: "Sparse Lopsided", rule0: "11[1[1[0]]][11[][0]]111[10]") )
    result.append( Plant(name: "Onesided Pine", rule0: "11[[0]][[][0]]10") )
    result.append( Plant(name: "Pine", rule0: "11[[0]][[0][0]]10") )
    result.append( Plant(name: "Vase1", rule0: "1[0][0]") )
    result.append( Plant(name: "Vase2", rule0: "1[1[0][0]0][1[0][0]0]") )
    result.append( Plant(name: "Vase3", rule0: "1[1[0][0]][1[0][0]]") )
    result.append( Plant(name: "Vase4", rule0: "1[1[0][0]][1[0][0]]", rule1: "11[0]11") )
    result.append( Plant(name: "Paisley", rule0: "1[1[1[1[1[1[10]]]]]]0", rule1: "1[0]11[0]1") )
    //result.append( Plant(name: "Paisley", rule0: "1[1[1[1[1[1[10]]]]]]0", rule1: "11") )
    result.append( Plant(name: "Seaweed", rule0: "1[1[1[1[1[1[10]]]]]]0", rule1: "11[0[0]]") )
    result.append( Plant(name: "Thyme", rule0: "1[1[1[1[1[1[10]]]]]]0", rule1: "1[0]1") )
    
    return result
}

/**
 This function will return a collection of default Fractal (Classic Iterated System) objects, already configured.
 */
public func defaultFractalCollection() ->[Rules] {
    var result = [Rules]()

    /// default segment length
    let defaultLength = 20.0

    // Sample Plants
    result.append(Rules(name: "a", initiator: "F", rules: ["F" : "F[+F]F[-F]F"], angle:25.7))
    result.append(Rules(name: "b", initiator: "F", rules: ["F" : "F[+F]F[-F][F]"], angle:20))
    result.append(Rules(name: "c", initiator: "F", rules: ["F" : "FF-[-F+F+F]+[+F-F-F]"], angle:22.5))
    result.append(Rules(name: "d", initiator: "X", rules: ["X" : "F[+X]F[-X]+X", "F" : "FF"], angle:20, nodeRewriting: true))
    result.append(Rules(name: "e", initiator: "X", rules: ["X" : "F[+X][-X]FX", "F" : "FF"], angle:25.7, nodeRewriting: true))
    result.append(Rules(name: "f", initiator: "X", rules: ["X" : "F-[[X]+X]+F[+FX]-X", "F" : "FF"], angle:22.5, nodeRewriting: true))
//    result.append(Rules(name: "multirule", initiator: "F", rules: ["F" : ["F[+F]F[-F]F","F[+F]F","F[-F]F"]], angle:22.5, nodeRewriting: true))
    
    result.append(Rules(name: "stochastic plant (multirule)", initiator: "F", rules: ["F" : ["F[+F]F[-F]F","F[+F]F","F[-F]F"]], angle:22.5, nodeRewriting: true))

    //https://nb.paulbutler.org/l-systems/
    //'F', {'F': 'F[-F][+F]'}, 4, 30
    result.append(Rules(name: "simple branching tree", initiator: "F", rules: ["F" : "F[-F][+F]"], angle: 30, length: defaultLength, initialDirection: 90 ))
            
            // 'F', {'F': 'FF[++F][-FF]'}, 5, 22
    result.append(Rules(name: "asymetric branching tree", initiator: "F", rules: ["F" : "FF[++F][-FF]"], angle: 22, length: defaultLength, initialDirection: 90 ))
            
        // l_plot('A', {'F': 'FF', 'A': 'F[+AF-[A]--A][---A]'}, 5, 22.5)
    result.append(Rules(name: "branching tree", initiator: "A", rules: ["F": "FF", "A" : "F[+AF-[A]--A][---A]"], angle: 22.5, length: defaultLength, initialDirection: 90 , nodeRewriting: true))

    
    // von Koch Snowflake Demos
    result.append(Rules(name: "koch curve flat snowflake", initiator: "F", rules: ["F" : "F+F--F+F"], angle: 60, length: defaultLength, initialDirection: 0, defaultIteration: 3 ))
    result.append(Rules(name: "koch curve snowflake", initiator: "F++F++F", rules: ["F" : "F−F++F−F"], angle: 60, length: defaultLength, initialDirection: 0, defaultIteration: 3 ))
    result.append(Rules(name: "koch curve snowflake hex", initiator: "F+F+F+F+F+F", rules: ["F" : "F−F++F−F"], angle: 60, length: defaultLength, initialDirection: 0, defaultIteration: 3 ))
    result.append(Rules(name: "koch curve anti-snowflake", initiator: "F++F++F", rules: ["F" : "F+F--F+F"], angle: 60, length: 5.0, initialDirection: 0))

    // Sierpinski Demos
    // Attempt at Sierpinski Gadget:
    // http://ecademy.agnesscott.edu/~lriddle/ifs/siertri/siertri.htm
    result.append(Rules(name: "Sierpinski Gadget", initiator: "F+F+F", rules: ["F" : "F+F-F-F+F" ], angle: 120,  length: defaultLength, initialDirection: 0, nodeRewriting: false, modifier: 1))
    result.append(Rules(name: "Sierpinski Gasket nodeRewriting", initiator: "FX", rules: ["F" : "Z", "X":"+FY-FX-FY+", "Y":"-FX+FY+FX-" ], angle: 60,  length: defaultLength, initialDirection: 0, nodeRewriting: true, modifier: 1))
    // Serpinsk Carpet, corrected.
    // http://ecademy.agnesscott.edu/~lriddle/ifs/carpet/carpet.htm
    result.append(Rules(name:"serpinsk carpet", initiator: "F", rules: ["F" : "F+F−F−F−f+F+F+F−F", "f":"fff"], angle: 90,  length: 2400, initialDirection: 45, modifier: 3))

    // Space Filling Curves
    result.append(Rules(name: "hilbert curve", initiator: "L", rules: ["L" : "+RF-LFL-FR+", "R" : "-LF+RFR+FL-"], angle: 90, length: defaultLength, initialDirection: 90, nodeRewriting: true ))
    result.append(Rules(name: "3x3 macrotile", initiator: "-L", rules: ["L" : "LF+RFR+FL-F-LFLFL-FRFR+", "R" : "-LFLF+RFRFR+F+RF-LFL-FR"], angle: 90, length: defaultLength, initialDirection: 90, nodeRewriting: true, defaultIteration: 2 ))
    result.append(Rules(name: "4x4 macrotile", initiator: "-L", rules: ["L" : "LFLF+RFR+FLFL-FRF-LFL-FR+F+RF-LFL-FRFRFR+", "R" : "-LFLFLF+RFR+FL-F-LF+RFR+FLF+RFRF-LFL-FRFR"], angle: 90, length: defaultLength, initialDirection: 90, nodeRewriting: true, defaultIteration: 2 ))
    result.append(Rules(name: "3x3 peano_curve", initiator: "L", rules: ["L" : "LFRFL-F-RFLFR+F+LFRFL", "R" : "RFLFR+F+LFRFL-F-RFLFR"], angle: 90, length: defaultLength, initialDirection: 90, nodeRewriting: true, defaultIteration: 2 ))
    result.append(Rules(name: "5x5 macrotile", initiator: "L", rules: ["L" : "L+F+R-F-L+F+R-F-L-F-R+F+L-F-R-F-L+F+R-F-L-F-R-F-L+F+R+F+L+F+R-F-L+F+R+F+L-F-R+F+L+F+R-F-L+F+R-F-L", "R" : "R-F-L+F+R-F-L+F+R+F+L-F-R+F+L+F+R-F-L+F+R+F+L+F+R-F-L-F-R-F-L+F+R-F-L-F-R+F+L-F-R-F-L+F+R-F-L+F+R"], angle: 45, length: defaultLength, initialDirection: 45, nodeRewriting: true, defaultIteration: 2 ))

    // Dragon Curve
    result.append(Rules(name: "dragon-curve", initiator: "L", rules: ["L" : "L+R+", "R" : "-L-R"], angle: 90, length: defaultLength, initialDirection: 90, defaultIteration: 8 ))
        // Lévy_Dragon  http://ecademy.agnesscott.edu/~lriddle/ifs/levy/levy.htm
    result.append(Rules(name: "Levy Dragon", initiator: "F", rules: ["F":"+F−−F+"], angle: 45, length: defaultLength, initialDirection: 0, nodeRewriting: false, modifier: 1, defaultIteration: 8))
    result.append(Rules(name: "Levy Tapestry", initiator: "F++F++F++F++", rules: ["F":"+F−−F+"], angle: 45, length: defaultLength, initialDirection: 0, nodeRewriting: false, modifier: 1, defaultIteration: 6))
    // Attempt at twin dragon:
    // http://ecademy.agnesscott.edu/~lriddle/ifs/heighway/twindragon.htm
    result.append(Rules(name: "twin dragon", initiator: "FX----FX", rules: ["X" : "+FX--FY+", "Y": "-FX++FY-", "F":"Z" ], angle: 45,  length: defaultLength, initialDirection: 0, nodeRewriting: true, modifier: 1, defaultIteration: 8))

    // Attempt at terdragon:
    // http://ecademy.agnesscott.edu/~lriddle/ifs/heighway/terdragon.htm
    result.append(Rules(name: "terdragon", initiator: "F", rules: ["F" : "+F----F++++F-" ], angle: 30,  length: defaultLength, initialDirection: 0, nodeRewriting: false, modifier: 1))

        // http://www.kevs3d.co.uk/dev/lsystems/
        // Also try the penrose tiling when you turn on node rewriting, it's interesting what comes out.
    result.append(Rules(name: "penrose tiling", initiator: "[F]++[F]++[F]++[F]++[F]", rules: ["F": "+GI--HI[---GI--FI]+", "G" : "-FI++GI[+++GI++HI]-", "H":"--GI++++FI[+HI++++GI]--GI", "I":""], angle: 36, length: defaultLength, initialDirection: 0 , nodeRewriting: false, defaultIteration: 3))

    // These two show how just a small change in the rule, can yield a very different outcome than what you were expecting!
    result.append(Rules(name:"koch curve variant 1 stars", initiator: "F", rules: ["F" : "F+F--F+F--F+F"], angle: 60, length: defaultLength, initialDirection: 30, defaultIteration: 3 ))
    
    result.append(Rules(name: "koch curve variant 1 ornate", initiator: "F", rules: ["F" : "F+F--F+F--F+F"], angle: 45, length: defaultLength, initialDirection: 67 ))

    /* Other ones I can show... */
    
    // Other Sierpinski types, not really needed for demo.
    result.append(Rules(name: "sierpinski gasket", initiator: "R", rules: ["L" : "R+L+R", "R" : "L-R-L"], angle: 60, length: defaultLength, initialDirection: 0 ))
        // http://ecademy.agnesscott.edu/~lriddle/ifs/siertri/siertri.htm
        // These seem to only work in certain situations.
    result.append(Rules(name: "sierpinski gasket hexagon outward", initiator: "R-R-R-R-R-R-", rules: ["L" : "R+L+R", "R" : "L-R-L"], angle: 60, length: defaultLength, initialDirection: 0 ))
    result.append(Rules(name: "sierpinski gasket hexagon inward", initiator: "L-L-L-L-L-L-", rules: ["L" : "R+L+R", "R" : "L-R-L"], angle: 60, length: defaultLength, initialDirection: 0 ))

    result.append(Rules(name: "square grid approximation of the Sierpinski Curve", initiator: "F+XF+F+XF", rules: ["X" : "XF-F+F-XF+F+XF-F+F-X", "F":"F"], angle: 90.0, length: defaultLength, initialDirection: 0, nodeRewriting: true, modifier: 1, defaultIteration: 3))

    result.append(Rules(name: "Sierpinski median curve", initiator: "L--F--L--F", rules: ["L": "+R-F-R+", "R" : "-L+F+L-"], angle: 45, length: defaultLength, initialDirection: 0 , nodeRewriting: false))

    
    result.append(Rules(name: "Quadratic Koch Island", initiator: "F-F-F-F", rules: ["F" : "F-F+F+FF-F-F+F"], defaultIteration: 2))
    result.append(Rules(name: "Quadratic Modified Snowflake Curve", initiator: "-F", rules: ["F" : "F+F-F-F+F"], defaultIteration: 3))
    result.append(Rules(name: "Islands And Lakes", initiator: "F+F+F+F", rules: ["F" : "F+f-FF+F+FF+Ff+FF-f+FF-F-FF-Ff-FFF", "f":"ffffff"], defaultIteration: 2))
    result.append(Rules(name: "Koch curve a", initiator: "F-F-F-F", rules: ["F" : "FF-F-F-F-F-F+F"], defaultIteration: 3))
    result.append(Rules(name: "Koch curve b", initiator: "F-F-F-F", rules: ["F" : "FF-F-F-F-FF"], defaultIteration: 3))
    result.append(Rules(name: "Koch curve c", initiator: "F-F-F-F", rules: ["F" : "FF-F+F-F-FF"], defaultIteration: 3 ))
    result.append(Rules(name: "Koch curve d", initiator: "F-F-F-F", rules: ["F" : "FF-F--F-F"] , defaultIteration: 3))
    result.append(Rules(name: "Koch curve e", initiator: "F-F-F-F", rules: ["F" : "F-FF--F-F"] , defaultIteration: 3))
    result.append(Rules(name: "Koch curve f", initiator: "F-F-F-F", rules: ["F" : "F-F+F-F-F"] ))
    result.append(Rules(name: "hex curve", initiator: "F+F+F", rules: ["F" : "F+F-F+F"], angle: 60, length: defaultLength, initialDirection: 90, defaultIteration: 3 ))
    result.append(Rules(name: "hex curve updated", initiator: "H", rules: ["H" : "FT+FT+FT+FT+FT+FT", "T" : "--FH--FH--FH", "F" : "FF"], angle: 60, length: defaultLength, initialDirection: 90, modifier: 1 ))
    result.append(Rules(name: "tri curve", initiator: "F+F+F", rules: ["F" : "F+F-F+F"], angle: 120, length: defaultLength, initialDirection: 90 ))
    result.append(Rules(name:"triangle curve", initiator: "F-F-F", rules: ["F" : "F+F-FF"], angle: 120, length: defaultLength, initialDirection: 90, defaultIteration: 3 ))
    result.append(Rules(name: "scott destructive snowflake", initiator: "F+F+F+F+F+F", rules: ["F" : "-F++FF-F"], angle: 60, length: defaultLength, initialDirection: 90, defaultIteration: 3 ))
    result.append(Rules(name: "scott destructive tri", initiator: "+F--F--F", rules: ["F" : "+F--FF+F"], angle: 60, length: defaultLength, initialDirection: 0, defaultIteration: 3 ))
    result.append(Rules(name: "scott destructive tri fill", initiator: "{+F--F--F}", rules: ["F" : "+F--FF+F"], angle: 60, length: defaultLength, initialDirection: 0, defaultIteration: 3 ))
    result.append(Rules(name: "scott destructive tri fill alt", initiator: "+F--F--F", rules: ["F" : "{+F--FF+F}"], angle: 60, length: defaultLength, initialDirection: 0, defaultIteration: 3 ))

        // Examples of edge-rewriting
    result.append(Rules(name: "hexagonal gosper curve", initiator: "L", rules: ["L" : "L+R++R-L--LL-R+", "R" : "-L+RR++R+L--L-R"], angle: 60, length: defaultLength, initialDirection: 0, defaultIteration: 3 ))
    result.append(Rules(name: "quadratic Gosper curve", initiator: "-R", rules: ["L" : "LL-R-R+L+L-R-RL+R+LLR-L+R+LL+R-LR-R-L+L+RR-", "R" : "+LL-R-R+L+LR+L-RR-L-R+LRR-L-RL+L+R-R-L+L+RR"], angle: 90, length: defaultLength, initialDirection: 0, defaultIteration: 2 ))
        // Examples of Node rewriting
//        "scott_curve": (Rules(name: "scott_curve", initiator: "F++F++F++F", rules: ["F" : "-F+F"], angle: 45, length: defaultLength, initialDirection: 90 ),defaultIteration),
        // http://ecademy.agnesscott.edu/~lriddle/ifs/pentigre/pentigre2.htm
    result.append(Rules(name: "McWhorter Pentigree", initiator: "F", rules: ["F":"+F++F−−−−F−−F++F++F−"], angle: 36, length: defaultLength, initialDirection: 0, nodeRewriting: false, modifier: 1, defaultIteration: 3))
        // http://ecademy.agnesscott.edu/~lriddle/ifs/pentigre/pentigreeForm2.htm
    result.append(Rules(name: "McWhorter Pentigree 2nd form", initiator: "F++F++F++F++F", rules: ["F":"+F++F−−−−F−−F++F++F−"], angle: 36, length: defaultLength, initialDirection: 0, nodeRewriting: false, modifier: 1, defaultIteration: 3))
        // http://ecademy.agnesscott.edu/~lriddle/ifs/pentaden/penta.htm
    result.append(Rules(name: "McWhorter Pentadentrite", initiator: "F", rules: ["F":"F+F-F--F+F+F"], angle: 72, length: defaultLength, initialDirection: 0, nodeRewriting: false, modifier: 1, defaultIteration: 3))
        // http://ecademy.agnesscott.edu/~lriddle/ifs/pentaden/pentadenForm2.htm
    result.append(Rules(name: "McWhorter Pentadentrite 2nd", initiator: "F+F+F+F+F", rules: ["F":"F+F-F--F+F+F"], angle: 72, length: defaultLength, initialDirection: 0, nodeRewriting: false, modifier: 1, defaultIteration: 3))

    result.append(Rules(name: "Koch curve snowflake", initiator: "F++F++F", rules: ["F" : "F−F++F−F"], angle: 60, length: defaultLength, initialDirection: 0, defaultIteration: 3 ))
        
        // https://en.wikipedia.org/wiki/L-system
    result.append(Rules(name: "Koch curve", initiator: "F", rules: ["F" : "F+F−F−F+F"], angle: 90, length: defaultLength, initialDirection: 0, defaultIteration: 3 ))
        //    //"F++Ffff+F"
    result.append(Rules(name: "Koch curve 2", initiator: "F", rules: ["F" : "F+Ffff+F"], angle: 90, length: defaultLength, initialDirection: 0 ))
            
            // https://nb.paulbutler.org/l-systems/
            // Based on complex image
    result.append(Rules(name: "complex image", initiator: "F", rules: ["F" : "+F+F--F+F"], angle: 60, length: defaultLength, initialDirection: 60, defaultIteration: 5 ))
            

        // http://www.kevs3d.co.uk/dev/lsystems/
        // All working!  There are a couple plants on this site I did not do.
    result.append(Rules(name: "joined crosses curve", initiator: "XYXYXYX+XYXYXYX+XYXYXYX+XYXYXYX", rules: ["F": "", "X" : "FX+FX+FXFY-FY-", "Y":"+FX+FXFY-FY-FY"], angle: 90, length: defaultLength, initialDirection: 90 , nodeRewriting: true, defaultIteration: 2))
        result.append(Rules(name: "lace", initiator: "W", rules: ["W": "+++X--F--ZFX+", "X" : "---W++F++YFW-", "Y":"+ZFX--F--Z+++", "Z":"-YFW++F++Y---"], angle: 30, length: defaultLength, initialDirection: 90 , nodeRewriting: false))
    result.append(Rules(name: "space filling curve", initiator: "X", rules: ["X": "-YF+XFX+FY-", "Y" : "+XF-YFY-FX+"], angle: 90, length: defaultLength, initialDirection: 0 , nodeRewriting: true))
        //F=C0FF[C1-F++F][C2+F--F]C3++F--F
    result.append(Rules(name: "kevs pond weed", initiator: "F", rules: ["F": "FF[-F++F][+F--F]++F--F"], angle: 27, length: defaultLength, initialDirection: 90 , nodeRewriting: true))
        
        // http://paulbourke.net/fractals/lsys/
    result.append(Rules(name: "pb bush 1", initiator: "Y", rules: ["X": "X[-FFF][+FFF]FX", "Y":"YFX[+Y][-Y]"], angle: 25.7, length: defaultLength, initialDirection: 90 , nodeRewriting: true))
        
        // axiom = F
        // F -> FF+[+F-F-F]-[-F+F+F]
        // angle = 22.5
    result.append(Rules(name: "pb bush 2", initiator: "F", rules: ["F": "FF+[+F-F-F]-[-F+F+F]", "Y":"YFX[+Y][-Y]"], angle: 22.5, length: defaultLength, initialDirection: 90 , nodeRewriting: true))
        
        //    axiom = F
        //    F -> F[+FF][-FF]F[-F][+F]F
        //    angle = 35
    result.append(Rules(name: "pb bush 3", initiator: "F", rules: ["F": "F[+FF][-FF]F[-F][+F]F"], angle: 35, length: defaultLength, initialDirection: 90 , nodeRewriting: true))
            
        //    Attributed to Saupe
        //    axiom = VZFFF
        //    V -> [+++W][---W]YV
        //    W -> +X[-W]Z
        //    X -> -W[+X]Z
        //    Y -> YZ
        //    Z -> [-FFF][+FFF]F
        //    angle = 20
    result.append(Rules(name: "pb bush 4", initiator: "VZFFF", rules: ["V":"[+++W][---W]YV", "W": "+X[-W]Z", "X":"-W[+X]Z", "Y":"YZ", "Z": "[-FFF][+FFF]F", "F":"F"], angle: 20, length: defaultLength, initialDirection: 90 , nodeRewriting: true))
            
        //    axiom = FX
        //    X -> >[-FX]+FX
        //    angle = 40
     result.append(Rules(name: "pb bush 5", initiator: "FX", rules: ["F":"FF", "X": ">[-FX]+FX"], angle: 40, length: defaultLength, initialDirection: 90 , nodeRewriting: true))
            
        //    axiom = Y---Y
        //    X -> {F-F}{F-F}--[--X]{F-F}{F-F}--{F-F}{F-F}--
        //    Y -> f-F+X+F-fY
        //    angle = 60
            // This one isn't quite right and doesn't look like what's published on the page.
    result.append(Rules(name: "mango leaf", initiator: "Y--Y", rules: ["X":"{F-F}{F-F}--[--X]{F-F}{F-F}--{F-F}{F-F}--", "Y": "f-F+X+F-fY"], angle: 60, length: defaultLength, initialDirection: 60 , nodeRewriting: true))

        //    axiom = (-D--D)
        //    A -> F++FFFF--F--FFFF++F++FFFF--F
        //    B -> F--FFFF++F++FFFF--F--FFFF++F
        //    C -> BFA--BFA
        //    D -> CFC--CFC
        //    angle = 45
    result.append(Rules(name: "kolam", initiator: "(-D--D)", rules: ["A":"F++FFFF--F--FFFF++F++FFFF--F", "B": "F--FFFF++F++FFFF--F--FFFF++F", "C": "BFA--BFA", "D":"CFC--CFC"], angle: 45, length: defaultLength, initialDirection: 0 , nodeRewriting: true, defaultIteration: 3))
            
        //    axiom = F+XF+F+XF
        //    X -> X{F-F-F}+XF+F+X{F-F-F}+X
        //    angle = 90
    result.append(Rules(name: "snake kolam", initiator: "F+XF+F+XF", rules: ["X":"X{F-F-F}+XF+F+X{F-F-F}+X", "F": "F"], angle: 90, length: defaultLength, initialDirection: 0 , nodeRewriting: true, defaultIteration: 3))

        //    axiom = -X--X
        //    X -> XFX--XFX
        //    angle = 45
    result.append(Rules(name: "krishna anklets", initiator: "-X--X", rules: ["X":"XFX--XFX", "F": "F"], angle: 45, length: defaultLength, initialDirection: 0 , nodeRewriting: true, defaultIteration: 3))
            
        //    axiom = F++F++F++F++F
        //    F -> F++F++F|F-F++F
        //    angle = 36
    result.append(Rules(name: "pentaplexity", initiator: "F++F++F++F++F", rules: ["F": "F++F++F|F-F++F"], angle: 36, length: defaultLength, initialDirection: 0 , nodeRewriting: false, defaultIteration: 2))

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
    result.append(Rules(name: "algae 1", initiator: "aF", rules: ["a": "FFFFFv[+++h][---q]fb", "b":"FFFFFv[+++h][---q]fc", "c":"FFFFFv[+++fa]fd", "d":"FFFFFv[+++h][---q]fe", "e":"FFFFFv[+++h][---q]fg", "g":"FFFFFv[---fa]fa", "h":"ifFF", "i":"fFFF[--m]j", "j":"fFFF[--n]k", "k":"fFFF[--o]l", "l":"fFFF[--p]", "m":"fFn", "n":"fFo", "o":"fFp", "p":"fF", "q":"rfF", "r":"fFFF[++m]s", "s":"fFFF[++n]t", "t":"fFFF[++o]u", "u":"fFFF[++p]", "v":"Fv"], angle: 12, length: defaultLength, initialDirection: 90 , nodeRewriting: false))
            
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
    result.append(Rules(name: "algae 2", initiator: "aF", rules: ["a":"FFFFFy[++++n][----t]fb",
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
                                                      "y":"Fy"], angle: 12, length: defaultLength, initialDirection: 90 , nodeRewriting: false))
            
        //    axiom = F
        //    F -> FF-[XY]+[XY]
        //    X -> +FY
        //    Y -> -FX
        //    angle = 22.5
    result.append(Rules(name: "weed 1", initiator: "F", rules: ["F":"FF-[XY]+[XY]",
                                                      "X":"+FY",
                                                      "Y":"-FX"], angle: 22.5, length: defaultLength, initialDirection: 90 , nodeRewriting: true))
            
        //    axiom = F+F+F
        //    F -> F-F+F
        //    angle = 120
    result.append(Rules(name: "triangle", initiator: "F+F+F", rules: ["F":"F-F+F"], angle: 120, length: defaultLength, initialDirection: 90 , nodeRewriting: true))

        //    axiom = F
        //    F -> F-F+F+F-F
        //    angle = 90
    result.append(Rules(name: "quadratic snowflake", initiator: "F", rules: ["F":"F-F+F+F-F"], angle: 90, length: defaultLength, initialDirection: 0 , nodeRewriting: false, defaultIteration: 3))
    result.append(Rules(name: "enclosed quadratic snowflake", initiator: "F+F+F+F", rules: ["F":"F-F+F+F-F"], angle: 90, length: defaultLength, initialDirection: 0 , nodeRewriting: false, defaultIteration: 3))
    result.append(Rules(name: "cross quadratic snowflake", initiator: "FF+FF+FF+FF", rules: ["F":"F-F+F+F-F"], angle: 90, length: defaultLength, initialDirection: 0 , nodeRewriting: false, defaultIteration: 3))

        //    Variation by Hasan Hosam.
        //    December 2018
        //    axiom = FF+FF+FF+FF
        //    F -> F+F-F-F+F
        //    angle = 90
    result.append(Rules(name: "variation quadratic snowflake", initiator: "FF+FF+FF+FF", rules: ["F":"F+F-F-F+F"], angle: 90, length: defaultLength, initialDirection: 90 , nodeRewriting: true, defaultIteration: 3))

    
    // This rule set needs node rewriting to remove the extra letters in the final rule set to draw.
    //n = 3, δ = 60°
    //{XF+F+XF+F+XF+F}
    //X → XF+F+XF−F−F−XF−F+F+F−F+F+F−X
    result.append(Rules(name: "hexagonal pyramid", initiator: "{XF+F+XF+F+XF+F}", rules: ["X" : "XF+F+XF−F−F−XF−F+F+F−F+F+F−X"], angle: 60,  length: 600, initialDirection: 0, nodeRewriting: true, modifier: 2, defaultIteration: 2))
    
    // Note I can probably delete this one, since it's the Koch Snowflake.
    // result.append(Rules(name: "modifier_rule", initiator: "+F--F--F", rules: ["F" : "F+F--F+F"], angle: 60, length: 1200, initialDirection: 0, modifier: 3 ))

    
    result.append(Rules(name:"Cesaro's Triangle Sweep", initiator: "F+F+F+F", rules: ["F" : "F+F--F+F"], angle: 85, length: defaultLength, initialDirection: 0, defaultIteration: 3 ))

    return result
}
