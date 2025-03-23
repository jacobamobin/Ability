//
//  GetName.swift
//  Ability
//
//  Created by Jacob Mobin on 3/22/25.
//

import Foundation
import GoogleGenerativeAI

func summarizeProject(userInput: String) async throws -> String {
    // Load API key from keys.plist
    guard let apiKey = getAPIKeyFromPlist() else {
        return "Error: API key not found."
    }

    let model = GenerativeModel(name: "gemini-1.5-flash-latest", apiKey: apiKey)

    let prompt = """
    You are an AI that specializes in identifying key concepts from user descriptions. 
    Given a detailed description of a 3D model, return a concise 2-3 word summary of what the object is.

    Example Inputs and Outputs:
    
    "A prosthetic hand with adjustable fingers for gripping objects." → "Prosthetic Hand"
    "A custom wheelchair attachment that allows better movement on rough terrain." → "Wheelchair Attachment"
    "A pen holder designed for people with arthritis to grip pens comfortably." → "Ergonomic Pen Holder"

    User's description: \(userInput)

    Output only the 2-3 word summary with no extra text.
"""

    do {
        let modelOutput = try await model.generateContent(prompt)
        return modelOutput.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "Unknown"
    } catch {
        return "Error generating summary: \(error.localizedDescription)"
    }
}

// Helper function to load the API key from keys.plist
func getAPIKeyFromPlist() -> String? {
    guard let path = Bundle.main.path(forResource: "keys", ofType: "plist"),
          let xml = FileManager.default.contents(atPath: path),
          let plist = try? PropertyListSerialization.propertyList(from: xml, options: [], format: nil) as? [String: String],
          let apiKey = plist["G"] else {
        return nil
    }
    return apiKey
}
