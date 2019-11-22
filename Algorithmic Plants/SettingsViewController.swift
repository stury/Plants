//
//  SettingsViewController.swift
//  Digital Plants
//
//  Created by Scott Tury on 11/21/19.
//  Copyright © 2019 Scott Tury. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet var currentColorView : UIView!
    @IBOutlet var colorPickerView : ColorPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let colorPickerView = colorPickerView {
            
            colorPickerView.onColorDidChange = { [weak self] color in
                DispatchQueue.main.async {

                    // use picked color for your needs here...
                    self?.currentColorView.backgroundColor = color
                    
//                    // Can I convert the Color to a series of Doubles?
//                    if let safeSelf = self {
//                        let myColor = safeSelf.convertColor( color.cgColor )
//                        print( myColor )
//                    }
                }
            }
        }
        
//        if let navigationController = navigationController {
//
//        }
    }
    
    func convertColor( _ cgColor: CGColor) -> ( CGFloat, CGFloat, CGFloat, CGFloat) {

        var red     : CGFloat = 0.0
        var green   : CGFloat = 0.0
        var blue    : CGFloat = 0.0
        var alpha   : CGFloat = 1.0
        
        print( cgColor.colorSpace.debugDescription )
        print( "cgColor Components: \(cgColor.numberOfComponents)" )
        if cgColor.numberOfComponents == 4 {
            if let components = cgColor.components {
                for (index, component) in components.enumerated() {
                    switch ( index ) {
                    case 0:
                        red = component
                    case 1:
                        green = component
                    case 2:
                        blue = component
                    case 3:
                        alpha = component
                    default:
                        print("We should NEVER get here!")
                    }
                }
            }
        }
        else {
            print( "I haven't dealt with this before!" )
        }
        
        return (red, green, blue, alpha)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        print( "\(String(describing: segue.identifier)) \(segue.destination)" )
        
        if let currentColorView = currentColorView, let color = currentColorView.backgroundColor {
            _ = convertColor(color.cgColor)
        }
    }

    override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        print( "unwinding seque:  \(String(describing: unwindSegue.identifier)) \(unwindSegue.destination) -> \(subsequentVC)" )
        
        if let currentColorView = currentColorView, let color = currentColorView.backgroundColor {
            _ = convertColor(color.cgColor)
        }
    }
    
    @IBAction func resetAction(_ sender: UIButton) {
        // Reset the color to the original default value!
        
    }
}