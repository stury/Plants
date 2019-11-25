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
    
    let processingQueue = DispatchQueue(label: "DetailViewProcessing", qos: .default /*.userInitiated*/, autoreleaseFrequency: .inherit ) 
    
    @IBOutlet weak var detailView: UIView!
    var pdfView : PDFView! = nil
    var pdfData : Data? = nil
    var turtleColor : (Double, Double, Double, Double)?
    
    @IBOutlet weak var incrementIteration: UIBarButtonItem!
    @IBOutlet weak var decrementIteration: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var iterationLabel: UILabel!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var infoButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!

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
            updateButtons()
            // Set the iteration label
            if let iterationLabel = iterationLabel {
                iterationLabel.text = "n=\(currentIteration)"
            }
        }
    }
    
    var screenBackgroundColor : (CGFloat, CGFloat, CGFloat, CGFloat) = (1.0, 1.0, 1.0, 0.0)
    
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
//        if let pdfView = pdfView {
//            print("pdfView = \(pdfView)/npdfView.subviews = \(pdfView.subviews)\n----------")
//        }
        #endif
    }
    
    func updateDocument(_ data: Data) {
        pdfData = data
        if let document = PDFDocument(data: data) {
//            #if DEBUG
//            if let page = document.page(at: 0) {
//            let bounds = page.bounds(for: .mediaBox)
//            print( "page mediaBox size = \(bounds.size)")
//            }
//            #endif
            
            pdfView?.document = document
            pdfView?.autoScales = true
                        
            activityIndicator.stopAnimating()
            debugPDFView()
        }
    }
    
    func updatePlant(_ plant: Plant) {
        plant.backgroundColor = screenBackgroundColor
        if let data = plant.croppedPlantPdf(currentIteration) {
            // set the view Document!
            DispatchQueue.main.async { [weak self] in
                self?.updateDocument(data)
            }
        }
    }
    
    func updateRules(_ rules:Rules ) {
        
        let turtle = Turtle()
        turtle.backgroundColor = screenBackgroundColor
        if let turtleColor = turtleColor {
            turtle.color = (turtleColor.0, turtleColor.1, turtleColor.2)
        }
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

    func updateButtons() {
        if let _ = detailItem {
            // Enable Buttons!
            incrementIteration?.isEnabled = true
            infoButton.isEnabled = true
            shareButton.isEnabled = true

            if currentIteration == lowestIteration {
                decrementIteration?.isEnabled = false
            }
            else if decrementIteration?.isEnabled == false {
                decrementIteration?.isEnabled = true
            }
        }
        else {
            // Disable the bar buttons!
            incrementIteration?.isEnabled = false
            decrementIteration?.isEnabled = false
            infoButton.isEnabled = false
            shareButton.isEnabled = false
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
            
            if let settingsButton = settingsButton {
                if let _ = detailItem as? Rules {
                    settingsButton.isEnabled = true
                }
            }
        }
        updateButtons()
    }

    func updateScreenBackgroundColor() {
//        if #available(iOS 13, *) {
//            if traitCollection.userInterfaceStyle == .dark {
//                screenBackgroundColor = (0.1098, 0.1098, 0.1176, 1.0)
//            }
//            else {
//                screenBackgroundColor =  (1.0, 1.0, 1.0, 0.0)
//            }
//        } else {
//            screenBackgroundColor =  (1.0, 1.0, 1.0, 0.0)
//        }
        screenBackgroundColor =  (1.0, 1.0, 1.0, 0.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateScreenBackgroundColor()
        configureView()
    }

    @IBAction func decrementAction(_ sender: UIBarButtonItem) {
        currentIteration -= 1
        configureView()
    }
    
    @IBAction func incrementAction(_ sender: UIBarButtonItem) {
        currentIteration += 1
        configureView()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        updateScreenBackgroundColor()
        updatePDF()
    }
    
    @IBAction func onAction(_ sender: UIBarButtonItem) {
        // Open up the Action sheet, with the Image in the list of what you want to share.
        var items = [Any]()
        var applicationActivities = [UIActivity]()
        var createdFile : URL?
        
        #if targetEnvironment(macCatalyst)
        // Code specific to Mac.  Mac doesn't understand the raw data, nor the PDFDocument...  Write it out to disk, and send the URL.  This gives you most of the share options, but not "Save to Photos".  You can only get that if your first item was a UIImage (rasterized!)
        var name = "share"
        if let detailItem = detailItem as? Plant {
            if let detailName = detailItem.name {
                name = detailName
            }
        }
        else if let detailItem = detailItem as? Rules {
            name = detailItem.name
        }

        if let writer = try? FileWriter(directory: .cachesDirectory, domainMask: .userDomainMask, additionalOutputDirectory: "Temp") {
            if let url = writer.export(fileType: "pdf", name: name, data: pdfData) {
                createdFile = url
                items.append(url.standardizedFileURL as NSURL)
            }
        }

//        // Passing a UIImage to the items ensures that the Add To Photos appears in the drop down.  But they seem to need to be first in the list in that case.
//        let renderer = ImageRenderer()
//            let images = renderer.raster(pdfData)
//            for image in images {
//                items.append(image)
//            }
//        }
        applicationActivities.append(SaveFileActivity())
        #else
        // It appears that the share activity understands the raw PDF data, but not a PDFDocument object.
        if let data = pdfData {
            items.append( data )
        }
        //        iOS doesn't seem to understand a PDFDocument as a share item.  Only the Data.
        //        if let document = pdfView.document {
        //            items.append( document )
        //        }
        #endif

        
        // If we don't have anything to act upon, don't open the Action Sheet.
        if items.count > 0 {
            let activityVC = UIActivityViewController(activityItems: items, applicationActivities: applicationActivities)
            if UIDevice.current.userInterfaceIdiom == .pad {
                //On iPad, you must present the view controller in a popover.
                activityVC.modalPresentationStyle = .popover
                // Remember to setup the Popover based on where you're activating it from...
                if let popOver = activityVC.popoverPresentationController {
                  //popOver.sourceView = UIView
                  //popOver.sourceRect =
                  popOver.barButtonItem = sender
                }
                
            }
            else if UIDevice.current.userInterfaceIdiom == .phone {
                // On iPhone and iPod touch, you must present it modally.
                activityVC.modalPresentationStyle = .overCurrentContext //.currentContext
            }
            if let url = createdFile, url.isFileURL {
                // Interesting Side note:  The UIActivityViewController doesn't seem to call the completion block if the user doesn't select an item to share with.
                // This seems to be at odds with the documentation about what it should do...
                // Maybe I should see if we get a willAppear to capture the cancel case...
                let path = url.path
//                print("Temporary file created: \(path).  Setting the completionWithItemsHandler...")
                activityVC.completionWithItemsHandler = { (activityType, completed, returnedItems, error) -> Void in
                    let fileManager = FileManager.default
//                    print( "completionWithItemsHandler called.  path = \(path)" )
                    if fileManager.fileExists(atPath: path) {
//                        print( "deleting \(path)" )
                        try? fileManager.removeItem(atPath: path)
                    }
                    else {
//                        print( "path did not exist!" )
                    }
                }
            }
            self.present(activityVC, animated: true) {
                print("Presented VC!")
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showInfo" {
            if let infoVC = segue.destination as? InfoViewController {
                infoVC.rules        = detailItem
                infoVC.iteration    = currentIteration
            }
        }
        else if segue.identifier == "settings" {
            print( "loading the Settings VC..." )
            
        }
        
    }

    override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        print( "unwinding seque:  \(String(describing: unwindSegue.identifier)) \(unwindSegue.destination) -> \(subsequentVC)" )
    }

    @IBAction func onUnwind(_ sender: UIStoryboardSegue) {
        // Unwind segue happening...
        
    }
}

