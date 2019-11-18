//
//  Rules.swift
//  Plant
//
//  Created by Scott Tury on 12/2/18.
//  Copyright © 2018 Scott Tury. All rights reserved.
//

import Foundation

/// Class to setup with rules for building up image instances.  
public class Rules : CustomStringConvertible {
    
    public var description: String {
        get {
            // Convert the Plant info to a string
            var result : String = ""
            result += "\(name) Rule Set\n\n"
            result += "δ = \(angle)°\n"
            result += "Initial Direction: \(initialDirection)°\n"
            if nodeRewriting {
                result += "Node Rewriting: \(nodeRewriting)\n"
            }
            result += "\n"
            result += " w : \(initiator)\n"
            var iteration = 1
            for (rule, replacement) in rules {
                let count = replacement.count
                if count == 1 {
                    // Simple case
                    result += "p\(iteration) : \(rule) -> \(replacement[0])\n"
                    iteration += 1
                }
                else {
                    // There are multiple possibilities!
                    let probability = 1.0/Double(count)
                    for possibility in replacement {
                        result += "p\(iteration) : \(rule) - \(String(format:"%.3f", probability)) -> \(possibility)\n"
                        iteration += 1
                    }
                }
            }

            return result
        }
    }
    
    public let name: String
    public let initiator : String
    public let rules : [Character:[String]]
    public let angle : Double
    public let length : Double
    public let initialDirection : Double
    public let nodeRewriting : Bool
    public let modifier : Double   // What to change the length by on each iteration...
    
    public init(name: String, initiator: String, rules: [Character:[String]], angle: Double = 90.0, length: Double = 5.0, initialDirection: Double = 90.0, nodeRewriting: Bool = false, modifier: Double = 1 ) {
        self.name       = name
        self.initiator  = initiator
        self.rules      = rules
        self.angle      = angle
        self.length     = length
        self.initialDirection = initialDirection
        self.nodeRewriting  = nodeRewriting
        self.modifier = modifier
    }

    public convenience init(name: String, initiator: String, rules: [Character:String], angle: Double = 90.0, length: Double = 5.0, initialDirection: Double = 90.0, nodeRewriting: Bool = false, modifier: Double = 1 ) {

        var newRules = [Character:[String]]()
        for (char, string) in rules {
            newRules[char] = [string]
        }

        self.init(name: name, initiator: initiator, rules: newRules, angle: angle, length: length, initialDirection: initialDirection, nodeRewriting: nodeRewriting, modifier: modifier)
    }
//    public init(initiator: String, rules: [Character:String], angle: Double = 90.0, length: Double = 5.0, initialDirection: Double = 90.0, nodeRewriting: Bool = false ) {
//        self.initiator  = initiator
//        var newRules = [Character:[String]]()
//        for (char, string) in rules {
//            newRules[char] = [string]
//        }
//        self.rules      = newRules
//        self.angle      = angle
//        self.length     = length
//        self.initialDirection = initialDirection
//        self.nodeRewriting  = nodeRewriting
//    }

    
    /// calculates the entire rule base based on the number of iterations we want to draw.
    public func calculateRules( for iterations: Int ) -> String {
        var result = initiator
        
        for _ in 0..<iterations {
            var tmpString = ""
            for offset in 0..<result.count {
                // for each character, if I have a rule for it, replace that character with the rule.  Otherwise keep the character.
                let character = result[String.Index(utf16Offset: offset, in: result)]

                if let replacement = rules[character] {
                    if replacement.count == 1 {
                        if let replacement = replacement.first {
                            tmpString.append(replacement)
                        }
                    }
                    else {
                        if let replacement = replacement.randomElement() {
                            tmpString.append(replacement)
                        }
                    }
                }
                else {
                    tmpString.append(character)
                }
            }
            result = tmpString
        }
        
        if nodeRewriting {
            // Ideally I should just remove all of the "L" and "R" characters from the final string...
            // This way we don't have to process them when drawing the rule set.
            // Remove all upper case characters that are not 'F'
            let upperCase = "ABCDEGHIJKLMNOPQRSTUVWXYZ"
            for index in 0..<upperCase.count {
              let character = upperCase[String.Index(utf16Offset: index, in: upperCase)]
              result = result.replacingOccurrences(of: String(character), with: "")
            }
        }
        #if DEBUG
        //print("\(result)")
        #endif
        return result
    }
    
    /// public method for determining the line segment length at a particular iteration.
    public func calculateLength( for iteration: Int ) -> Double {
        var result : Double = length
        
        if modifier > 1 && iteration > 0 {
            for _ in 0..<iteration {
                result = result / modifier
            }
        }
        
        return result
    }
}
