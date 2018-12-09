//
//  Rules.swift
//  Plant
//
//  Created by Scott Tury on 12/2/18.
//  Copyright © 2018 Scott Tury. All rights reserved.
//

import Foundation

/// Class to setup with rules for building up image instances.  
public class Rules {
    public let initiator : String
    public let rules : [Character:[String]]
    public let angle : Double
    public let length : Double
    public let initialDirection : Double
    public let nodeRewriting : Bool
    
    public init(initiator: String, rules: [Character:[String]], angle: Double = 90.0, length: Double = 5.0, initialDirection: Double = 90.0, nodeRewriting: Bool = false ) {
        self.initiator  = initiator
        self.rules      = rules
        self.angle      = angle
        self.length     = length
        self.initialDirection = initialDirection
        self.nodeRewriting  = nodeRewriting
    }

    convenience init(initiator: String, rules: [Character:String], angle: Double = 90.0, length: Double = 5.0, initialDirection: Double = 90.0, nodeRewriting: Bool = false ) {

        var newRules = [Character:[String]]()
        for (char, string) in rules {
            newRules[char] = [string]
        }

        self.init(initiator: initiator, rules: newRules, angle: angle, length: length, initialDirection: initialDirection, nodeRewriting: nodeRewriting)
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
                let character = result[String.Index(encodedOffset: offset)]
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
                let character = upperCase[String.Index(encodedOffset: index)]
                result = result.replacingOccurrences(of: String(character), with: "")
            }
        }
        return result
    }
    
}
