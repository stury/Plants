import Foundation

let defaultLength = 10.0
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
    // 'F', {'F': 'FF[++F][-FF]'}, 5, 22
//    "asymetric_branching_tree":(Rules(initiator: "F", rules: ["F" : "FF[++F][-FF]"], angle: 22, length: defaultLength, initialDirection: 90 ),5),
        
//    "koch_curve_snowflake":(Rules(initiator: /*"F++F++F"*/ "F", rules: ["F" : "F−F++F−F"], angle: 60, length: defaultLength, initialDirection: 0 ),5),

//    "koch_curve_variant_1_stars":(Rules(initiator: "F", rules: ["F" : "F+F--F+F--F+F"], angle: 60, length: defaultLength, initialDirection: 30 ),5),
//
//    "koch_curve_variant_1_ornate":(Rules(initiator: "F", rules: ["F" : "F+F--F+F--F+F"], angle: 45, length: defaultLength, initialDirection: 67 ),4),
    
//    "Cesaro's Triangle Sweep":(Rules(initiator: "F+F+F+F", rules: ["F" : "F+F--F+F"], angle: 85, length: defaultLength, initialDirection: 0 ),5),
    
    "Polya's Triangle Sweep":(Rules(initiator: "F|f+F|f+F|f+F|f", rules: ["F":"F+F--F+F"], angle: 45, length: defaultLength, initialDirection: 0 ),4),
    
]

var images = [Image]()

for (ruleName, (currentRule, iterations)) in rules {
    images.append(contentsOf: draw(ruleName: ruleName, currentRule: currentRule, iterations: iterations))
}

