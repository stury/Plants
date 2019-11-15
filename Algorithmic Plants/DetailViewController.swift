//
//  DetailViewController.swift
//  Algorithmic Plants
//
//  Created by Scott Tury on 11/9/19.
//  Copyright © 2019 Scott Tury. All rights reserved.
//

import UIKit
import PlantKit
import PDFKit

class DetailViewController: UIViewController {
    
    let processingQueue = DispatchQueue(label: "DetailViewProcessing")
    
    @IBOutlet weak var detailView: UIView!
    var pdfView : PDFView! = nil
    
    @IBOutlet weak var incrementIteration: UIButton!
    @IBOutlet weak var decrementIteration: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var detailItem: Any? {
        didSet {
            // Reset the currentIteration...
            currentIteration = 4
            // Update the view.
            configureView()
        }
    }

    private var lowestIteration : Int {
        get {
            if let _ = detailItem as? Rules {
                return 0
            }
            else {
                return 1
            }
        }
    }
    
    var currentIteration : Int = 4 {
        didSet {
            if let _ = decrementIteration {
                
                if currentIteration == lowestIteration {
                    decrementIteration.isEnabled = false
                }
                else if decrementIteration.isEnabled == false {
                    decrementIteration.isEnabled = true
                }
            }
        }
    }
    
    func createAndSetupPdfView(_ detail: UIView) -> PDFView {
        let pdfView = PDFView(frame: detail.frame)
        pdfView.autoScales = true
        detail.addSubview(pdfView)
        
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: pdfView,
            attribute: .leading,
            relatedBy: .equal,
            toItem: detail,
            attribute: .leading,
            multiplier: 1.0,
            constant: 0.0).isActive = true

        NSLayoutConstraint(item: pdfView,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: detail,
            attribute: .trailing,
            multiplier: 1.0,
            constant: 0.0).isActive = true

        NSLayoutConstraint(item: pdfView,
            attribute: .top,
            relatedBy: .equal,
            toItem: detail,
            attribute: .top,
            multiplier: 1.0,
            constant: 0.0).isActive = true

        NSLayoutConstraint(item: pdfView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: detail,
            attribute: .bottom,
            multiplier: 1.0,
            constant: 0.0).isActive = true

        return pdfView
    }
    
    func debugPDFView() {
        #if DEBUG
        if let pdfView = pdfView {
            print("pdfView = \(pdfView)/npdfView.subviews = \(pdfView.subviews)\n----------")
        }
        #endif
    }
    
    func updateDocument(_ data: Data) {
        if let document = PDFDocument(data: data), let page = document.page(at: 0) {
            let bounds = page.bounds(for: .mediaBox)
            print( "page mediaBox size = \(bounds.size)")
            
            pdfView?.document = document
            pdfView?.autoScales = true
                        
            activityIndicator.stopAnimating()
            debugPDFView()
        }
    }
    
    func updatePlant(_ plant: Plant) {
        if let data = plant.croppedPlantPdf(currentIteration) {
            // set the view Document!
            DispatchQueue.main.async { [weak self] in
                self?.updateDocument(data)
            }
        }
    }
    
    func updateRules(_ rules:Rules ) {
        let turtle = Turtle()
        turtle.rules = rules
        if let data = turtle.drawCroppedPdf(currentIteration) {
            DispatchQueue.main.async { [weak self] in
                self?.updateDocument(data)
            }
        }
    }
    
    func updatePDF() {
        
        // Generate the image to show in the PDFView!
        if let plant = detailItem as? Plant {
            activityIndicator.startAnimating()
            processingQueue.async { [weak self] in
                self?.updatePlant(plant)
            }
        }
        else if let iterativeFunc = detailItem as? Rules {
            activityIndicator.startAnimating()
            processingQueue.async { [weak self] in
                self?.updateRules(iterativeFunc)
            }
        }
        else {
            print( "Unknown Item!" )
        }
    }
    
    func configureView() {
        
        // Update the user interface for the detail item.
        if let detail = detailView {
            // Have we setup the PDFView?  If not, set it up.
            if pdfView == nil {
                activityIndicator.style = .large
                pdfView = createAndSetupPdfView(detail)
            }
                
            updatePDF()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
        
    }

    @IBAction func decrementAction(_ sender: UIButton) {
        currentIteration -= 1
        configureView()
    }
    
    @IBAction func incrementAction(_ sender: UIButton) {
        currentIteration += 1
        configureView()
    }
}

