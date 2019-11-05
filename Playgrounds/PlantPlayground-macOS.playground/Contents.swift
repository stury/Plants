import Cocoa

var str = "Hello, playground"

let defaultLength = 20.0
let fileWriter = try? FileWriter("Plant")
/**
 Simple function for drawing the contents of a rule at a particular interation level, and return the resulting Images.
 - parameter ruleName: The name of the Rule you;re passing in.
 - parameter currentRules: The Rule set to draw
 - parameter iterations: The max iteration to draw for this set.
 - returns: An array of Images.
 */
func draw( ruleName:String, currentRule: Rules, iterations: Int) -> [Image] {
    var result = [Image]()
    
    let turtle = Turtle()
    turtle.backgroundColor = Turtle.colorBackgroundBlack
    turtle.rules = currentRule
    turtle.border = 50.0
    
    //        if let image = turtle.drawIterativeGrowth( iterations ) {
    if let image = turtle.drawIterativeGrowth( iterations, colors: [Turtle.colorAmberMonitor]) {
        result.append(image)
        fileWriter?.export(fileType: "png", name: "turtle_iterative_\(ruleName)", data: image.data())
    }
    if let image = turtle.draw(iterations) {
        result.append(image)
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
    
    return result
}

/// default iteration to generate
let defaultIteration = 4

let rules : [String:(Rules, Int)] = [
//    "koch_curve_snowflake":(Rules(initiator: "F++F++F", rules: ["F" : "F−F++F−F"], angle: 60, length: defaultLength, initialDirection: 0 ),5)
//"koch_curve_snowflake":(Rules(initiator: "F++F++F", rules: ["F" : "F−F++F−F"], angle: 60, length: defaultLength, initialDirection: 0 ),5)
//    // https://en.wikipedia.org/wiki/L-system
//    "koch_curve":(Rules(initiator: "F", rules: ["F" : "F+F−F−F+F"], angle: 90, length: defaultLength, initialDirection: 0 ),5)
//    //"F++Ffff+F"
//    "koch_curve":(Rules(initiator: "F", rules: ["F" : "F++Ffff+F"], angle: 90, length: defaultLength, initialDirection: 0 ),5)
    
    // https://nb.paulbutler.org/l-systems/
    // Based on complex image
//    "complex_image":(Rules(initiator: "F", rules: ["F" : "+F+F--F+F"], angle: 60, length: defaultLength, initialDirection: 60 ),5)
    
    //'F', {'F': 'F[-F][+F]'}, 4, 30
//    "simple_branching_tree":(Rules(initiator: "F", rules: ["F" : "F[-F][+F]"], angle: 30, length: defaultLength, initialDirection: 90 ),5)
    
    // 'F', {'F': 'FF[++F][-FF]'}, 5, 22
//    "asymetric_branching_tree":(Rules(initiator: "F", rules: ["F" : "FF[++F][-FF]"], angle: 22, length: defaultLength, initialDirection: 90 ),5)
    
    // l_plot('A', {'F': 'FF', 'A': 'F[+AF-[A]--A][---A]'}, 5, 22.5)
    //"branching_tree":(Rules(initiator: "A", rules: ["F": "FF", "A" : "F[+AF-[A]--A][---A]"], angle: 22.5, length: defaultLength, initialDirection: 90 , nodeRewriting: true),5)

    // http://www.kevs3d.co.uk/dev/lsystems/
    // All working!  There are a couple plants on this site I did not do.
    // "joined_crosses_curve":(Rules(initiator: "XYXYXYX+XYXYXYX+XYXYXYX+XYXYXYX", rules: ["F": "", "X" : "FX+FX+FXFY-FY-", "Y":"+FX+FXFY-FY-FY"], angle: 90, length: defaultLength, initialDirection: 90 , nodeRewriting: true),3)
    //"lace":(Rules(initiator: "W", rules: ["W": "+++X--F--ZFX+", "X" : "---W++F++YFW-", "Y":"+ZFX--F--Z+++", "Z":"-YFW++F++Y---"], angle: 30, length: defaultLength, initialDirection: 90 , nodeRewriting: false),6)
    // Also try the penrose tiling when you turn on node rewriting, it's interesting what comes out.
    //"penrose_tiling":(Rules(initiator: "[F]++[F]++[F]++[F]++[F]", rules: ["F": "+GI--HI[---GI--FI]+", "G" : "-FI++GI[+++GI++HI]-", "H":"--GI++++FI[+HI++++GI]--GI", "I":""], angle: 36, length: defaultLength, initialDirection: 0 , nodeRewriting: false),6)
    //"sierpinski_median_curve":(Rules(initiator: "L--F--L--F", rules: ["L": "+R-F-R+", "R" : "-L+F+L-"], angle: 45, length: defaultLength, initialDirection: 0 , nodeRewriting: false),8)
    //"space_filling_curve":(Rules(initiator: "X", rules: ["X": "-YF+XFX+FY-", "Y" : "+XF-YFY-FX+"], angle: 90, length: defaultLength, initialDirection: 0 , nodeRewriting: true),6)
    //F=C0FF[C1-F++F][C2+F--F]C3++F--F
    //"kevs_pond_weed":(Rules(initiator: "F", rules: ["F": "FF[-F++F][+F--F]++F--F"], angle: 27, length: defaultLength, initialDirection: 90 , nodeRewriting: true),5)
    
    
    // http://paulbourke.net/fractals/lsys/
    //"pb_bush_1":(Rules(initiator: "Y", rules: ["X": "X[-FFF][+FFF]FX", "Y":"YFX[+Y][-Y]"], angle: 25.7, length: defaultLength, initialDirection: 90 , nodeRewriting: true),5)
    
    // axiom = F
    // F -> FF+[+F-F-F]-[-F+F+F]
    // angle = 22.5
//    "pb_bush_2":(Rules(initiator: "F", rules: ["F": "FF+[+F-F-F]-[-F+F+F]", "Y":"YFX[+Y][-Y]"], angle: 22.5, length: defaultLength, initialDirection: 90 , nodeRewriting: true),5)
    
//    axiom = F
//    F -> F[+FF][-FF]F[-F][+F]F
//    angle = 35
//    "pb_bush_3":(Rules(initiator: "F", rules: ["F": "F[+FF][-FF]F[-F][+F]F"], angle: 35, length: defaultLength, initialDirection: 90 , nodeRewriting: true),5)
    
//    Attributed to Saupe
//    axiom = VZFFF
//    V -> [+++W][---W]YV
//    W -> +X[-W]Z
//    X -> -W[+X]Z
//    Y -> YZ
//    Z -> [-FFF][+FFF]F
//    angle = 20
//    "pb_bush_4":(Rules(initiator: "VZFFF", rules: ["V":"[+++W][---W]YV", "W": "+X[-W]Z", "X":"-W[+X]Z", "Y":"YZ", "Z": "[-FFF][+FFF]F", "F":"F"], angle: 20, length: defaultLength, initialDirection: 90 , nodeRewriting: true),10)
    
//    axiom = FX
//    X -> >[-FX]+FX
//    angle = 40
//    "pb_bush_5":(Rules(initiator: "FX", rules: ["F":"FF", "X": ">[-FX]+FX"], angle: 40, length: defaultLength, initialDirection: 90 , nodeRewriting: true),7)
    
//    axiom = Y---Y
//    X -> {F-F}{F-F}--[--X]{F-F}{F-F}--{F-F}{F-F}--
//    Y -> f-F+X+F-fY
//    angle = 60
    // This one isn't quite right and doesn't look like what's published on the page.
//    "mango_leaf":(Rules(initiator: "Y--Y", rules: ["X":"{F-F}{F-F}--[--X]{F-F}{F-F}--{F-F}{F-F}--", "Y": "f-F+X+F-fY"], angle: 60, length: defaultLength, initialDirection: 60 , nodeRewriting: true),8)

    
//    axiom = (-D--D)
//    A -> F++FFFF--F--FFFF++F++FFFF--F
//    B -> F--FFFF++F++FFFF--F--FFFF++F
//    C -> BFA--BFA
//    D -> CFC--CFC
//    angle = 45
    //"kolam":(Rules(initiator: "(-D--D)", rules: ["A":"F++FFFF--F--FFFF++F++FFFF--F", "B": "F--FFFF++F++FFFF--F--FFFF++F", "C": "BFA--BFA", "D":"CFC--CFC"], angle: 45, length: defaultLength, initialDirection: 0 , nodeRewriting: true),3)
    
//    axiom = F+XF+F+XF
//    X -> X{F-F-F}+XF+F+X{F-F-F}+X
//    angle = 90
//    "snake_kolam":(Rules(initiator: "F+XF+F+XF", rules: ["X":"X{F-F-F}+XF+F+X{F-F-F}+X", "F": "F"], angle: 90, length: defaultLength, initialDirection: 0 , nodeRewriting: true),5)

//    axiom = -X--X
//    X -> XFX--XFX
//    angle = 45
//    "krishna_anklets":(Rules(initiator: "-X--X", rules: ["X":"XFX--XFX", "F": "F"], angle: 45, length: defaultLength, initialDirection: 0 , nodeRewriting: true),5)
    
//    axiom = F++F++F++F++F
//    F -> F++F++F|F-F++F
//    angle = 36
//    "pentaplexity":(Rules(initiator: "F++F++F++F++F", rules: ["F": "F++F++F|F-F++F"], angle: 36, length: defaultLength, initialDirection: 0 , nodeRewriting: false),4)

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
//    "algae_1":(Rules(initiator: "aF", rules: ["a": "FFFFFv[+++h][---q]fb", "b":"FFFFFv[+++h][---q]fc", "c":"FFFFFv[+++fa]fd", "d":"FFFFFv[+++h][---q]fe", "e":"FFFFFv[+++h][---q]fg", "g":"FFFFFv[---fa]fa", "h":"ifFF", "i":"fFFF[--m]j", "j":"fFFF[--n]k", "k":"fFFF[--o]l", "l":"fFFF[--p]", "m":"fFn", "n":"fFo", "o":"fFp", "p":"fF", "q":"rfF", "r":"fFFF[++m]s", "s":"fFFF[++n]t", "t":"fFFF[++o]u", "u":"fFFF[++p]", "v":"Fv"], angle: 12, length: defaultLength, initialDirection: 90 , nodeRewriting: false),10)
    
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
//    "algae_2":(Rules(initiator: "aF", rules: ["a":"FFFFFy[++++n][----t]fb",
//                                              "b":"+FFFFFy[++++n][----t]fc",
//                                              "c":"FFFFFy[++++n][----t]fd",
//                                              "d":"-FFFFFy[++++n][----t]fe",
//                                              "e":"FFFFFy[++++n][----t]fg",
//                                              "g":"FFFFFy[+++fa]fh",
//                                              "h":"FFFFFy[++++n][----t]fi",
//                                              "i":"+FFFFFy[++++n][----t]fj",
//                                              "j":"FFFFFy[++++n][----t]fk",
//                                              "k":"-FFFFFy[++++n][----t]fl",
//                                              "l":"FFFFFy[++++n][----t]fm",
//                                              "m":"FFFFFy[---fa]fa",
//                                              "n":"ofFFF",
//                                              "o":"fFFFp",
//                                              "p":"fFFF[-s]q",
//                                              "q":"fFFF[-s]r",
//                                              "r":"fFFF[-s]",
//                                              "s":"fFfF",
//                                              "t":"ufFFF",
//                                              "u":"fFFFv",
//                                              "v":"fFFF[+s]w",
//                                              "w":"fFFF[+s]x",
//                                              "x":"fFFF[+s]",
//                                              "y":"Fy"], angle: 12, length: defaultLength, initialDirection: 90 , nodeRewriting: false),10)
    
//    axiom = F
//    F -> FF-[XY]+[XY]
//    X -> +FY
//    Y -> -FX
//    angle = 22.5
//    "weed_1":(Rules(initiator: "F", rules: ["F":"FF-[XY]+[XY]",
//                                              "X":"+FY",
//                                              "Y":"-FX"], angle: 22.5, length: defaultLength, initialDirection: 90 , nodeRewriting: true),6)
    
//    axiom = F+F+F
//    F -> F-F+F
//    angle = 120
//    "triangle":(Rules(initiator: "F+F+F", rules: ["F":"F-F+F"], angle: 120, length: defaultLength, initialDirection: 90 , nodeRewriting: true),6)

//    axiom = F
//    F -> F-F+F+F-F
//    angle = 90
//    "quadratic_snowflake":(Rules(initiator: "F", rules: ["F":"F-F+F+F-F"], angle: 90, length: defaultLength, initialDirection: 0 , nodeRewriting: false),4)
 //   "enclosed_quadratic_snowflake":(Rules(initiator: "F+F+F+F", rules: ["F":"F-F+F+F-F"], angle: 90, length: defaultLength, initialDirection: 0 , nodeRewriting: false),4),
    "cross_quadratic_snowflake":(Rules(initiator: "FF+FF+FF+FF", rules: ["F":"F-F+F+F-F"], angle: 90, length: defaultLength, initialDirection: 0 , nodeRewriting: false),4)

//    Variation by Hasan Hosam.
//    December 2018
//    axiom = FF+FF+FF+FF
//    F -> F+F-F-F+F
//    angle = 90
//    "variation_quadratic_snowflake":(Rules(initiator: "FF+FF+FF+FF", rules: ["F":"F+F-F-F+F"], angle: 90, length: defaultLength, initialDirection: 90 , nodeRewriting: true),4)
    
//    "koch_curve_snowflake_hex":(Rules(initiator: "F+F+F+F+F+F", rules: ["F" : "F−F++F−F"], angle: 60, length: defaultLength, initialDirection: 0 ),defaultIteration)
]

var images = [Image]()

for (ruleName, (currentRule, iterations)) in rules {
    images.append(contentsOf: draw(ruleName: ruleName, currentRule: currentRule, iterations: iterations))
}

