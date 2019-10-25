import Cocoa

var str = "Hello, playground"

let defaultLength = 20.0
let fileWriter = try? FileWriter("Plant")
/**
 Simple function for drawing the contents of a rule at a particular interation level, and return the resulting Images.
 -param ruleName The name of the Rule you;re passing in.
 -param currentRules The Rule set to draw
 -param iterations The max iteration to draw for this set.
 -return An array of Images.
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
    
    // https://nb.paulbutler.org/l-systems/
    //'F', {'F': 'F[-F][+F]'}, 4, 30
//    "simple_branching_tree":(Rules(initiator: "F", rules: ["F" : "F[-F][+F]"], angle: 30, length: defaultLength, initialDirection: 90 ),5)
    
    // https://nb.paulbutler.org/l-systems/
    // 'F', {'F': 'FF[++F][-FF]'}, 5, 22
//    "asymetric_branching_tree":(Rules(initiator: "F", rules: ["F" : "FF[++F][-FF]"], angle: 22, length: defaultLength, initialDirection: 90 ),5)
    
    // https://nb.paulbutler.org/l-systems/
    // l_plot('A', {'F': 'FF', 'A': 'F[+AF-[A]--A][---A]'}, 5, 22.5)
    "branching_tree":(Rules(initiator: "A", rules: ["F": "FF", "A" : "F[+AF-[A]--A][---A]"], angle: 22.5, length: defaultLength, initialDirection: 90 , nodeRewriting: true),5)

    
    
]

var images = [Image]()

for (ruleName, (currentRule, iterations)) in rules {
    images.append(contentsOf: draw(ruleName: ruleName, currentRule: currentRule, iterations: iterations))
}

