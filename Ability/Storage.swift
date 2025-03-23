//
//  Storage.swift
//  Ability
//
//  Created by Jacob Mobin on 3/23/25.
//

import Foundation
import SwiftUI

// MARK: - Save OBJ File
func saveOBJFile(data: Data, fileName: String) -> URL? {
    let fileManager = FileManager.default
    guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
        print("Could not find documents directory")
        return nil
    }
    
    let fileURL = documentsDirectory.appendingPathComponent("\(fileName).obj")
    
    do {
        try data.write(to: fileURL)
        print("File saved to: \(fileURL)")
        return fileURL
    } catch {
        print("Error saving OBJ file: \(error)")
        return nil
    }
}

// MARK: - Save Item Name and File Path
func saveItem(name: String, objData: Data) {
    guard let fileURL = saveOBJFile(data: objData, fileName: name) else { return }
    
    let itemData: [String: String] = [
        "name": name,
        "path": fileURL.path
    ]
    
    UserDefaults.standard.set(itemData, forKey: name)
    print("Item saved successfully.")
}

// MARK: - Load Item
func loadItem(name: String) -> URL? {
    guard let itemData = UserDefaults.standard.dictionary(forKey: name),
          let filePath = itemData["path"] as? String else {
        print("Item not found.")
        return nil
    }
    
    return URL(fileURLWithPath: filePath)
}

/*
// MARK: - Example Usage
// Sample Data for an OBJ file (replace with actual .obj data)
let sampleOBJData = Data("sample obj data".utf8)

// Saving Item
saveItem(name: "SampleItem", objData: sampleOBJData)

// Loading Item
if let fileURL = loadItem(name: "SampleItem") {
    print("Loaded OBJ file at: \(fileURL)")
} else {
    print("Failed to load OBJ file.")
}
 */
