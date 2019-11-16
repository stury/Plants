//
//  InfoViewController.swift
//  Plant
//
//  Created by Scott Tury on 11/16/19.
//  Copyright © 2019 Scott Tury. All rights reserved.
//

import UIKit
import PlantKit

class InfoViewController: UIViewController {

    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var ruleTextDescription : UITextView!
    
    var rules : Any? = nil
        
    // Convert the rule that's been set, into a textual representation that we can display.
    func createDescription() -> String {
        if let plant = rules as? Plant {
            return plant.description
        }
        else if let rules = rules as? Rules {
            // Convert the Rules object into a nice text string.
            return rules.description
        }
        return "Unknown item!  \n\nNo description available. \n\n\(String(describing: rules))"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let description = createDescription()
        if ruleTextDescription != nil {
            ruleTextDescription.text = description
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
