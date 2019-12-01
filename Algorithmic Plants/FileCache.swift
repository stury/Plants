//
//  FileCache.swift
//  Digital Plants
//
//  Created by Scott Tury on 12/1/19.
//  Copyright © 2019 Scott Tury. All rights reserved.
//

import Foundation
import PlantKit

class FileCache {

    private let fileWriter : FileWriter?
    private let fileManager = FileManager.default
    
    init(_ cacheName: String) {
        fileWriter = try? FileWriter(directory: .cachesDirectory, domainMask: .userDomainMask, additionalOutputDirectory: cacheName)
        
        #if DEBUG
        // For Debug purposes, clear the cache when we are started.  This way we can test the caching.
        //clear()
        #endif
    }
    
    /// This method will load in an item from the cache.
    func load(fileType: String, name: String) -> Data? {
        var result: Data? = nil
        
        if let fileWriter = fileWriter {
            if let url = URL(string: "\(name).\(fileType)", relativeTo: URL(fileURLWithPath: fileWriter.computedPath)) {
                let path = url.path
                if fileManager.fileExists(atPath: path) {
                    result = try? Data.init(contentsOf: url)
                }
            }
        }
        
        return result
    }
    
    /// This method will save a data object to the cache directory.
    func save(fileType: String, name: String, data: Data?) -> URL? {
        var result : URL?
        if let fileWriter = fileWriter {
            result = fileWriter.export(fileType: fileType, name: name, data: data)
        }
        return result
    }
    
    /// This method will clear the accumulated cache contents!
    func clear() {
        if let fileWriter = fileWriter {
             let url = URL(fileURLWithPath: fileWriter.computedPath)
            if let files = try? fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .includesDirectoriesPostOrder) {
                for fileUrl in files {
                    try? fileManager.removeItem(at: fileUrl)
                }
            }
        }
    }
}
