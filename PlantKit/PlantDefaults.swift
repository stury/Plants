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
            
    result.append( Plant(name: "Maple_25", branchAngle: 25.0, rule0: "1[0][0]110") )
    result.append( Plant(name: "Maple_45", branchAngle: 45.0, rule0: "1[0][0]110") )
    result.append( Plant(name: "Favorite", branchAngle: 25.0, rule0: "11[1[1[0]]]1[1[0]]1[1[0][1[0]]]") )
    result.append( Plant(name: "SparseLopsided", rule0: "11[1[1[0]]][11[][0]]111[10]") )
    result.append( Plant(name: "Christmas", rule0: "11[[0]][[][0]]10") )
    result.append( Plant(name: "Christmas2", rule0: "11[[0]][[0][0]]10") )
    result.append( Plant(name: "Vase1", rule0: "1[0][0]") )
    result.append( Plant(name: "Vase2", rule0: "1[1[0][0]0][1[0][0]0]") )
    result.append( Plant(name: "Vase3", rule0: "1[1[0][0]][1[0][0]]") )
    result.append( Plant(name: "Vase4", rule0: "1[1[0][0]][1[0][0]]", rule1: "11[0]11") )
    //result.append( Plant(name: "Paisley", rule0: "1[1[1[1[1[1[10]]]]]]0", rule1: "1[0]11[0]1")
    result.append( Plant(name: "Paisley", rule0: "1[1[1[1[1[1[10]]]]]]0", rule1: "11") )
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

    result.append(Rules(name: "quadraticKochIsland", initiator: "F-F-F-F", rules: ["F" : "F-F+F+FF-F-F+F"]))
    result.append(Rules(name: "quadraticModifiedSnowflakeCurve", initiator: "-F", rules: ["F" : "F+F-F-F+F"]))
    result.append(Rules(name: "islandsAndLakes", initiator: "F+F+F+F", rules: ["F" : "F+f-FF+F+FF+Ff+FF-f+FF-F-FF-Ff-FFF", "f":"ffffff"]))
    result.append(Rules(name: "koch_curve_a", initiator: "F-F-F-F", rules: ["F" : "FF-F-F-F-F-F+F"]))
    result.append(Rules(name: "koch_curve_b", initiator: "F-F-F-F", rules: ["F" : "FF-F-F-F-FF"]))
    result.append(Rules(name: "koch_curve_c", initiator: "F-F-F-F", rules: ["F" : "FF-F+F-F-FF"] ))
    result.append(Rules(name: "koch_curve_d", initiator: "F-F-F-F", rules: ["F" : "FF-F--F-F"] ))
    result.append(Rules(name: "koch_curve_e", initiator: "F-F-F-F", rules: ["F" : "F-FF--F-F"] ))
    result.append(Rules(name: "koch_curve_f", initiator: "F-F-F-F", rules: ["F" : "F-F+F-F-F"] ))
    result.append(Rules(name: "hex_curve", initiator: "F+F+F", rules: ["F" : "F+F-F+F"], angle: 60, length: defaultLength, initialDirection: 90 ))
    result.append(Rules(name: "hex_curve_updated", initiator: "H", rules: ["H" : "FT+FT+FT+FT+FT+FT", "T" : "--FH--FH--FH", "F" : "FF"], angle: 60, length: defaultLength, initialDirection: 90, modifier: 1 ))
    result.append(Rules(name: "tri_curve", initiator: "F+F+F", rules: ["F" : "F+F-F+F"], angle: 120, length: defaultLength, initialDirection: 90 ))
    result.append(Rules(name:"triangle_curve", initiator: "F-F-F", rules: ["F" : "F+F-FF"], angle: 120, length: defaultLength, initialDirection: 90 ))
    result.append(Rules(name: "koch_curve_flat_snowflake", initiator: "F", rules: ["F" : "F+F--F+F"], angle: 60, length: defaultLength, initialDirection: 0 ))
    result.append(Rules(name: "koch_curve_snowflake", initiator: "F++F++F", rules: ["F" : "F−F++F−F"], angle: 60, length: defaultLength, initialDirection: 0 ))
    result.append(Rules(name: "koch_curve_snowflake_hex", initiator: "F+F+F+F+F+F", rules: ["F" : "F−F++F−F"], angle: 60, length: defaultLength, initialDirection: 0 ))
    result.append(Rules(name: "koch_curve_anti-snowflake", initiator: "F++F++F", rules: ["F" : "F+F--F+F"], angle: 60, length: 5.0, initialDirection: 0))
    result.append(Rules(name: "scott_destructive_snowflake", initiator: "F+F+F+F+F+F", rules: ["F" : "-F++FF-F"], angle: 60, length: defaultLength, initialDirection: 90 ))
    result.append(Rules(name: "scott_destructive_tri", initiator: "+F--F--F", rules: ["F" : "+F--FF+F"], angle: 60, length: defaultLength, initialDirection: 0 ))
        
    result.append(Rules(name: "dragon-curve", initiator: "L", rules: ["L" : "L+R+", "R" : "-L-R"], angle: 90, length: defaultLength, initialDirection: 90 ))
    result.append(Rules(name: "sierpinski_gasket", initiator: "R", rules: ["L" : "R+L+R", "R" : "L-R-L"], angle: 60, length: defaultLength, initialDirection: 0 ))
        // http://ecademy.agnesscott.edu/~lriddle/ifs/siertri/siertri.htm
        // These seem to only work in certain situations.
    result.append(Rules(name: "sierpinski_gasket_hexagon_outward", initiator: "R-R-R-R-R-R-", rules: ["L" : "R+L+R", "R" : "L-R-L"], angle: 60, length: defaultLength, initialDirection: 0 ))
    result.append(Rules(name: "sierpinski_gasket_hexagon_inward", initiator: "L-L-L-L-L-L-", rules: ["L" : "R+L+R", "R" : "L-R-L"], angle: 60, length: defaultLength, initialDirection: 0 ))
        // Examples of edge-rewriting
    result.append(Rules(name: "hexagonal_gosper_curve", initiator: "L", rules: ["L" : "L+R++R-L--LL-R+", "R" : "-L+RR++R+L--L-R"], angle: 60, length: defaultLength, initialDirection: 0 ))
    result.append(Rules(name: "quadratic-Gosper_curve", initiator: "-R", rules: ["L" : "LL-R-R+L+L-R-RL+R+LLR-L+R+LL+R-LR-R-L+L+RR-", "R" : "+LL-R-R+L+LR+L-RR-L-R+LRR-L-RL+L+R-R-L+L+RR"], angle: 90, length: defaultLength, initialDirection: 0 ))
        // Examples of Node rewriting
    result.append(Rules(name: "hilbert_curve", initiator: "L", rules: ["L" : "+RF-LFL-FR+", "R" : "-LF+RFR+FL-"], angle: 90, length: defaultLength, initialDirection: 90, nodeRewriting: true ))
    result.append(Rules(name: "3x3_macrotile", initiator: "-L", rules: ["L" : "LF+RFR+FL-F-LFLFL-FRFR+", "R" : "-LFLF+RFRFR+F+RF-LFL-FR"], angle: 90, length: defaultLength, initialDirection: 90, nodeRewriting: true ))
    result.append(Rules(name: "4x4_macrotile", initiator: "-L", rules: ["L" : "LFLF+RFR+FLFL-FRF-LFL-FR+F+RF-LFL-FRFRFR+", "R" : "-LFLFLF+RFR+FL-F-LF+RFR+FLF+RFRF-LFL-FRFR"], angle: 90, length: defaultLength, initialDirection: 90, nodeRewriting: true ))
    result.append(Rules(name: "3x3_peano_curve", initiator: "L", rules: ["L" : "LFRFL-F-RFLFR+F+LFRFL", "R" : "RFLFR+F+LFRFL-F-RFLFR"], angle: 90, length: defaultLength, initialDirection: 90, nodeRewriting: true ))
    result.append(Rules(name: "5x5_macrotile", initiator: "L", rules: ["L" : "L+F+R-F-L+F+R-F-L-F-R+F+L-F-R-F-L+F+R-F-L-F-R-F-L+F+R+F+L+F+R-F-L+F+R+F+L-F-R+F+L+F+R-F-L+F+R-F-L", "R" : "R-F-L+F+R-F-L+F+R+F+L-F-R+F+L+F+R-F-L+F+R+F+L+F+R-F-L-F-R-F-L+F+R-F-L-F-R+F+L-F-R-F-L+F+R-F-L+F+R"], angle: 45, length: defaultLength, initialDirection: 45, nodeRewriting: true ))
    result.append(Rules(name: "square-grid-approximation-of-the-Sierpinski-curve", initiator: "F+XF+F+XF", rules: ["X" : "XF-F+F-XF+F+XF-F+F-X", "F":"F"], angle: 90.0, length: defaultLength, initialDirection: 0, nodeRewriting: true, modifier: 1))
//        "scott_curve": (Rules(name: "scott_curve", initiator: "F++F++F++F", rules: ["F" : "-F+F"], angle: 45, length: defaultLength, initialDirection: 90 ),defaultIteration),
        // http://ecademy.agnesscott.edu/~lriddle/ifs/pentigre/pentigre2.htm
    result.append(Rules(name: "McWhorter_Pentigree", initiator: "F", rules: ["F":"+F++F−−−−F−−F++F++F−"], angle: 36, length: defaultLength, initialDirection: 0, nodeRewriting: false, modifier: 1))
        // http://ecademy.agnesscott.edu/~lriddle/ifs/pentigre/pentigreeForm2.htm
    result.append(Rules(name: "McWhorter_Pentigree_2nd_form", initiator: "F++F++F++F++F", rules: ["F":"+F++F−−−−F−−F++F++F−"], angle: 36, length: defaultLength, initialDirection: 0, nodeRewriting: false, modifier: 1))
        // http://ecademy.agnesscott.edu/~lriddle/ifs/pentaden/penta.htm
    result.append(Rules(name: "McWhorter_Pentadentrite", initiator: "F", rules: ["F":"F+F-F--F+F+F"], angle: 72, length: defaultLength, initialDirection: 0, nodeRewriting: false, modifier: 1))
        // http://ecademy.agnesscott.edu/~lriddle/ifs/pentaden/pentadenForm2.htm
    result.append(Rules(name: "McWhorter_Pentadentrite_2nd", initiator: "F+F+F+F+F", rules: ["F":"F+F-F--F+F+F"], angle: 72, length: defaultLength, initialDirection: 0, nodeRewriting: false, modifier: 1))
        // Lévy_Dragon  http://ecademy.agnesscott.edu/~lriddle/ifs/levy/levy.htm
    result.append(Rules(name: "Levy_Dragon", initiator: "F", rules: ["F":"+F−−F+"], angle: 45, length: defaultLength, initialDirection: 0, nodeRewriting: false, modifier: 1))
    result.append(Rules(name: "Levy_Tapestry", initiator: "F++F++F++F++", rules: ["F":"+F−−F+"], angle: 45, length: defaultLength, initialDirection: 0, nodeRewriting: false, modifier: 1))

    result.append(Rules(name: "koch_curve_snowflake", initiator: "F++F++F", rules: ["F" : "F−F++F−F"], angle: 60, length: defaultLength, initialDirection: 0 ))
        
        // https://en.wikipedia.org/wiki/L-system
    result.append(Rules(name: "koch_curve", initiator: "F", rules: ["F" : "F+F−F−F+F"], angle: 90, length: defaultLength, initialDirection: 0 ))
        //    //"F++Ffff+F"
    result.append(Rules(name: "koch_curve_2", initiator: "F", rules: ["F" : "F++Ffff+F"], angle: 90, length: defaultLength, initialDirection: 0 ))
            
            // https://nb.paulbutler.org/l-systems/
            // Based on complex image
    result.append(Rules(name: "complex_image", initiator: "F", rules: ["F" : "+F+F--F+F"], angle: 60, length: defaultLength, initialDirection: 60 ))
            
            //'F', {'F': 'F[-F][+F]'}, 4, 30
    result.append(Rules(name: "simple_branching_tree", initiator: "F", rules: ["F" : "F[-F][+F]"], angle: 30, length: defaultLength, initialDirection: 90 ))
            
            // 'F', {'F': 'FF[++F][-FF]'}, 5, 22
    result.append(Rules(name: "asymetric_branching_tree", initiator: "F", rules: ["F" : "FF[++F][-FF]"], angle: 22, length: defaultLength, initialDirection: 90 ))
            
        // l_plot('A', {'F': 'FF', 'A': 'F[+AF-[A]--A][---A]'}, 5, 22.5)
    result.append(Rules(name: "branching_tree", initiator: "A", rules: ["F": "FF", "A" : "F[+AF-[A]--A][---A]"], angle: 22.5, length: defaultLength, initialDirection: 90 , nodeRewriting: true))

        // http://www.kevs3d.co.uk/dev/lsystems/
        // All working!  There are a couple plants on this site I did not do.
    result.append(Rules(name: "joined_crosses_curve", initiator: "XYXYXYX+XYXYXYX+XYXYXYX+XYXYXYX", rules: ["F": "", "X" : "FX+FX+FXFY-FY-", "Y":"+FX+FXFY-FY-FY"], angle: 90, length: defaultLength, initialDirection: 90 , nodeRewriting: true))
        result.append(Rules(name: "lace", initiator: "W", rules: ["W": "+++X--F--ZFX+", "X" : "---W++F++YFW-", "Y":"+ZFX--F--Z+++", "Z":"-YFW++F++Y---"], angle: 30, length: defaultLength, initialDirection: 90 , nodeRewriting: false))
        // Also try the penrose tiling when you turn on node rewriting, it's interesting what comes out.
    result.append(Rules(name: "penrose_tiling", initiator: "[F]++[F]++[F]++[F]++[F]", rules: ["F": "+GI--HI[---GI--FI]+", "G" : "-FI++GI[+++GI++HI]-", "H":"--GI++++FI[+HI++++GI]--GI", "I":""], angle: 36, length: defaultLength, initialDirection: 0 , nodeRewriting: false))
    result.append(Rules(name: "sierpinski_median_curve", initiator: "L--F--L--F", rules: ["L": "+R-F-R+", "R" : "-L+F+L-"], angle: 45, length: defaultLength, initialDirection: 0 , nodeRewriting: false))
    result.append(Rules(name: "space_filling_curve", initiator: "X", rules: ["X": "-YF+XFX+FY-", "Y" : "+XF-YFY-FX+"], angle: 90, length: defaultLength, initialDirection: 0 , nodeRewriting: true))
        //F=C0FF[C1-F++F][C2+F--F]C3++F--F
    result.append(Rules(name: "kevs_pond_weed", initiator: "F", rules: ["F": "FF[-F++F][+F--F]++F--F"], angle: 27, length: defaultLength, initialDirection: 90 , nodeRewriting: true))
        
        // http://paulbourke.net/fractals/lsys/
    result.append(Rules(name: "pb_bush_1", initiator: "Y", rules: ["X": "X[-FFF][+FFF]FX", "Y":"YFX[+Y][-Y]"], angle: 25.7, length: defaultLength, initialDirection: 90 , nodeRewriting: true))
        
        // axiom = F
        // F -> FF+[+F-F-F]-[-F+F+F]
        // angle = 22.5
    result.append(Rules(name: "pb_bush_2", initiator: "F", rules: ["F": "FF+[+F-F-F]-[-F+F+F]", "Y":"YFX[+Y][-Y]"], angle: 22.5, length: defaultLength, initialDirection: 90 , nodeRewriting: true))
        
        //    axiom = F
        //    F -> F[+FF][-FF]F[-F][+F]F
        //    angle = 35
    result.append(Rules(name: "pb_bush_3", initiator: "F", rules: ["F": "F[+FF][-FF]F[-F][+F]F"], angle: 35, length: defaultLength, initialDirection: 90 , nodeRewriting: true))
            
        //    Attributed to Saupe
        //    axiom = VZFFF
        //    V -> [+++W][---W]YV
        //    W -> +X[-W]Z
        //    X -> -W[+X]Z
        //    Y -> YZ
        //    Z -> [-FFF][+FFF]F
        //    angle = 20
    result.append(Rules(name: "pb_bush_4", initiator: "VZFFF", rules: ["V":"[+++W][---W]YV", "W": "+X[-W]Z", "X":"-W[+X]Z", "Y":"YZ", "Z": "[-FFF][+FFF]F", "F":"F"], angle: 20, length: defaultLength, initialDirection: 90 , nodeRewriting: true))
            
        //    axiom = FX
        //    X -> >[-FX]+FX
        //    angle = 40
     result.append(Rules(name: "pb_bush_5", initiator: "FX", rules: ["F":"FF", "X": ">[-FX]+FX"], angle: 40, length: defaultLength, initialDirection: 90 , nodeRewriting: true))
            
        //    axiom = Y---Y
        //    X -> {F-F}{F-F}--[--X]{F-F}{F-F}--{F-F}{F-F}--
        //    Y -> f-F+X+F-fY
        //    angle = 60
            // This one isn't quite right and doesn't look like what's published on the page.
    result.append(Rules(name: "mango_leaf", initiator: "Y--Y", rules: ["X":"{F-F}{F-F}--[--X]{F-F}{F-F}--{F-F}{F-F}--", "Y": "f-F+X+F-fY"], angle: 60, length: defaultLength, initialDirection: 60 , nodeRewriting: true))

        //    axiom = (-D--D)
        //    A -> F++FFFF--F--FFFF++F++FFFF--F
        //    B -> F--FFFF++F++FFFF--F--FFFF++F
        //    C -> BFA--BFA
        //    D -> CFC--CFC
        //    angle = 45
    result.append(Rules(name: "kolam", initiator: "(-D--D)", rules: ["A":"F++FFFF--F--FFFF++F++FFFF--F", "B": "F--FFFF++F++FFFF--F--FFFF++F", "C": "BFA--BFA", "D":"CFC--CFC"], angle: 45, length: defaultLength, initialDirection: 0 , nodeRewriting: true))
            
        //    axiom = F+XF+F+XF
        //    X -> X{F-F-F}+XF+F+X{F-F-F}+X
        //    angle = 90
    result.append(Rules(name: "snake_kolam", initiator: "F+XF+F+XF", rules: ["X":"X{F-F-F}+XF+F+X{F-F-F}+X", "F": "F"], angle: 90, length: defaultLength, initialDirection: 0 , nodeRewriting: true))

        //    axiom = -X--X
        //    X -> XFX--XFX
        //    angle = 45
    result.append(Rules(name: "krishna_anklets", initiator: "-X--X", rules: ["X":"XFX--XFX", "F": "F"], angle: 45, length: defaultLength, initialDirection: 0 , nodeRewriting: true))
            
        //    axiom = F++F++F++F++F
        //    F -> F++F++F|F-F++F
        //    angle = 36
    result.append(Rules(name: "pentaplexity", initiator: "F++F++F++F++F", rules: ["F": "F++F++F|F-F++F"], angle: 36, length: defaultLength, initialDirection: 0 , nodeRewriting: false))

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
    result.append(Rules(name: "algae_1", initiator: "aF", rules: ["a": "FFFFFv[+++h][---q]fb", "b":"FFFFFv[+++h][---q]fc", "c":"FFFFFv[+++fa]fd", "d":"FFFFFv[+++h][---q]fe", "e":"FFFFFv[+++h][---q]fg", "g":"FFFFFv[---fa]fa", "h":"ifFF", "i":"fFFF[--m]j", "j":"fFFF[--n]k", "k":"fFFF[--o]l", "l":"fFFF[--p]", "m":"fFn", "n":"fFo", "o":"fFp", "p":"fF", "q":"rfF", "r":"fFFF[++m]s", "s":"fFFF[++n]t", "t":"fFFF[++o]u", "u":"fFFF[++p]", "v":"Fv"], angle: 12, length: defaultLength, initialDirection: 90 , nodeRewriting: false))
            
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
    result.append(Rules(name: "algae_2", initiator: "aF", rules: ["a":"FFFFFy[++++n][----t]fb",
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
    result.append(Rules(name: "weed_1", initiator: "F", rules: ["F":"FF-[XY]+[XY]",
                                                      "X":"+FY",
                                                      "Y":"-FX"], angle: 22.5, length: defaultLength, initialDirection: 90 , nodeRewriting: true))
            
        //    axiom = F+F+F
        //    F -> F-F+F
        //    angle = 120
    result.append(Rules(name: "triangle", initiator: "F+F+F", rules: ["F":"F-F+F"], angle: 120, length: defaultLength, initialDirection: 90 , nodeRewriting: true))

        //    axiom = F
        //    F -> F-F+F+F-F
        //    angle = 90
    result.append(Rules(name: "quadratic_snowflake", initiator: "F", rules: ["F":"F-F+F+F-F"], angle: 90, length: defaultLength, initialDirection: 0 , nodeRewriting: false))
    result.append(Rules(name: "enclosed_quadratic_snowflake", initiator: "F+F+F+F", rules: ["F":"F-F+F+F-F"], angle: 90, length: defaultLength, initialDirection: 0 , nodeRewriting: false))
    result.append(Rules(name: "cross_quadratic_snowflake", initiator: "FF+FF+FF+FF", rules: ["F":"F-F+F+F-F"], angle: 90, length: defaultLength, initialDirection: 0 , nodeRewriting: false))

        //    Variation by Hasan Hosam.
        //    December 2018
        //    axiom = FF+FF+FF+FF
        //    F -> F+F-F-F+F
        //    angle = 90
    result.append(Rules(name: "variation_quadratic_snowflake", initiator: "FF+FF+FF+FF", rules: ["F":"F+F-F-F+F"], angle: 90, length: defaultLength, initialDirection: 90 , nodeRewriting: true))

    return result
}
