//
//  MasterTableViewCell.swift
//  Digital Plants
//
//  Created by Scott Tury on 11/30/19.
//  Copyright © 2019 Scott Tury. All rights reserved.
//

import UIKit
import PlantKit
import ImageRenderer


class MasterTableViewCell: UITableViewCell {

    static let generator = ThumbnailGenerator()
    static let fileCache = FileCache("Thumbnails")
    static let renderer = ImageRenderer()
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var thumbnail : UIImageView!

    /// Method to get the title from the item.  One place where this transformation takes place.
    func title( from item: Any? ) -> String {
        let title : String
        if let item = item {
            // When the item is set, we need to configure the cell correctly.
            if let plant = item as? Plant {
                if let name = plant.name {
                    title = name
                }
                else {
                    title = ""
                }
            }
            else if let rules = item as? Rules {
                title = rules.name
            }
            else {
                title = "Unknown"
            }
        }
        else {
            title = "Unknown"
        }
        return title
    }
        
    /// This method will get the thumbnail - either from cache, or generating it asyncronously.
    func getThumbnail( from item: Any? ) {
        if let item = item {
            let cellTitle = title( from: item )
            // First see if the cache has the item already rendered!
            if let friendly = cellTitle.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) {
                if let data = MasterTableViewCell.fileCache.load(fileType: "png", name: friendly) {
                    // Great!  We have a cahced value, let's use that as the image!
                    let images = MasterTableViewCell.renderer.raster(data)
                    if images.count > 0 {
                        thumbnail.image = images[0]
                    }
                }
                else {
                    // Did not have a cached image.  So let's create the thumbnail!
                    MasterTableViewCell.generator.generate(with: item) { [weak self] (image) in
                        if let image = image {
                            // Save the image to the cache!
                            _ = MasterTableViewCell.fileCache.save(fileType: "png", name: friendly, data: image.data())
                            
                            // If this thumbmnail is still for this cell, set it!
                            let currentTitle = self?.title(from: self?.item)
                            if currentTitle == cellTitle {
                                self?.thumbnail.image = image
                            }
                        }
                    }
                }
            }
        }
    }
    
    var item : Any? {
        didSet {
            if let item = item {
                let cellTitle = title(from: item)
                titleLabel.text = cellTitle
                detailLabel.text = ""
                    
                // Need to set the thumbnail image!
                getThumbnail( from: item )
            }
            else {
                // Zero out all the cell items!
                titleLabel.text = ""
                detailLabel.text = ""
                thumbnail.image = nil
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        item = nil
    }

}
