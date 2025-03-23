//
//  Generate3DModelChat.swift
//  Ability
//
//  Created by Jacob Mobin on 3/22/25.
//

import Foundation
import SwiftUI

// MARK: - Error Definitions
enum GenerateBPYScriptError: Error {
  case invalidAPIKey
  case generationFailed(String)
  case conversionFailed(String)
  case networkError(String)
  case missingAPIKey
}

// MARK: - Generate BPY using Groq API
func getAPIKey() -> String? {
  // Load the keys.plist file
  guard let path = Bundle.main.path(forResource: "keys", ofType: "plist"),
        let xml = FileManager.default.contents(atPath: path),
        let plist = try? PropertyListDecoder().decode([String: String].self, from: xml),
        let apiKey = plist["Q"] else {
    return nil
  }
  return apiKey
}

func generateScriptUsingGroq(from userInput: String) async throws -> URL {
  guard let groqApiKey = getAPIKey() else {
    throw GenerateBPYScriptError.missingAPIKey
  }
  
  // Construct the prompt for Groq
  let sysprompt = """
  Generate a Blender Python (bpy) script for a 3D model based on the following description. The script should create a functional 3D object within Blender, using the bpy library to define geometry.

  Ensure that the generated model follows these guidelines:
  - Start with proper imports: "import bpy" at the top of the script
  - Use bpy to create a mesh with basic simple topology
  - Use realistic dimensions and ensure the object is properly scaled
  - The object should be a simple mesh only
  - DO NOT create materials, textures, or any surface appearance properties
  - DO NOT include any camera setup or lighting configurations
  - DO NOT include any rendering configurations
  - Make the script completely basic and minimal
  - Use only the most basic Blender operations (no advanced modifiers)
  - Avoid using math.pi - use 3.14159 instead
  - Define all variables before using them
  - Clean up the scene at the beginning by removing all existing objects
  - Keep the geometry very simple - just basic shapes
  
  Description: \(userInput)
  
  Provide ONLY the Python code with no additional text or explanation.
  """
    
    let prompt = "generate a Blender Python (bpy) script for a 3D model based on the following description. Description \(userInput)"
  
  // Prepare request data
  let requestData: [String: Any] = [
    "model": "qwen-2.5-32b",
    "messages": [
      [
        "role": "system",
        "content": "You are an expert in creating Blender Python scripts. You generate clean, error-free code for 3D modeling. \(sysprompt)"
      ],
      [
        "role": "user",
        "content": prompt
      ]
    ],
    "max_tokens": 4000,
    "temperature": 0.1
  ]
  
  // Convert request data to JSON
  let jsonData = try JSONSerialization.data(withJSONObject: requestData, options: [])
  
  // Create URL request
  let url = URL(string: "https://api.groq.com/openai/v1/chat/completions")!
  var request = URLRequest(url: url)
  request.httpMethod = "POST"
  request.setValue("application/json", forHTTPHeaderField: "Content-Type")
  request.setValue("Bearer \(groqApiKey)", forHTTPHeaderField: "Authorization")
  request.httpBody = jsonData
  
  // Perform API request
  let (data, response) = try await URLSession.shared.data(for: request)
  
  // Check response status
  guard let httpResponse = response as? HTTPURLResponse else {
    throw GenerateBPYScriptError.networkError("Invalid response")
  }
  
  if httpResponse.statusCode != 200 {
    let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
    throw GenerateBPYScriptError.generationFailed("API request failed: \(errorMessage)")
  }
  
  // Parse the response
  let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
  
  guard
    let choices = jsonResponse?["choices"] as? [[String: Any]],
    let firstChoice = choices.first,
    let message = firstChoice["message"] as? [String: Any],
    let content = message["content"] as? String
  else {
    throw GenerateBPYScriptError.generationFailed("Invalid response format")
  }
  
  // Clean up the content to extract the script
  var scriptContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
  
  // Remove markdown code block markers if present
  if scriptContent.hasPrefix("```python") {
    scriptContent = String(scriptContent.dropFirst("```python".count))
  } else if scriptContent.hasPrefix("```") {
    scriptContent = String(scriptContent.dropFirst("```".count))
  }
  
  if scriptContent.hasSuffix("```") {
    scriptContent = String(scriptContent.dropLast("```".count))
  }
  
  scriptContent = scriptContent.trimmingCharacters(in: .whitespacesAndNewlines)
  
  // Save the script to a file
  let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("generated_model.py")
  try scriptContent.write(to: fileURL, atomically: true, encoding: .utf8)
  
  print("Groq-generated BPY script saved to: \(fileURL.path)")
  
  return fileURL
}

// MARK: - Convert BPY to OBJ using the conversion API
func convertBPYToOBJ(scriptURL: URL) async throws -> URL {
  print("Converting BPY script to OBJ...")
  
  // Read the script content
  let scriptContent = try String(contentsOf: scriptURL, encoding: .utf8)
  
  // Create multipart form data request
  let apiURL = URL(string: "https://714c-2606-8ac0-200-994-f730-e4ef-3d44-9f70.ngrok-free.app/convert")!
  
  var request = URLRequest(url: apiURL)
  request.httpMethod = "POST"
  
  let boundary = UUID().uuidString
  request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
  
  var body = Data()
  
  // Add the script parameter
  body.append("--\(boundary)\r\n".data(using: .utf8)!)
  body.append("Content-Disposition: form-data; name=\"script\"\r\n\r\n".data(using: .utf8)!)
  body.append(scriptContent.data(using: .utf8)!)
  body.append("\r\n".data(using: .utf8)!)
  
  // Add the filename parameter
  body.append("--\(boundary)\r\n".data(using: .utf8)!)
  body.append("Content-Disposition: form-data; name=\"filename\"\r\n\r\n".data(using: .utf8)!)
  body.append("generated_model.obj".data(using: .utf8)!)
  body.append("\r\n".data(using: .utf8)!)
  
  // Close the boundary
  body.append("--\(boundary)--\r\n".data(using: .utf8)!)
  
  request.httpBody = body
  
  // Perform the request
  let (data, response) = try await URLSession.shared.data(for: request)
  
  guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
    let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
    throw GenerateBPYScriptError.conversionFailed("Failed to convert BPY to OBJ: \(errorMessage)")
  }
  
  // Save the OBJ data to a file
  let objFileURL = FileManager.default.temporaryDirectory.appendingPathComponent("generated_model.obj")
  try data.write(to: objFileURL)
  
  print("OBJ file saved to: \(objFileURL.path)")
  
  return objFileURL
}

// MARK: - SwiftUI View
struct BPYToOBJView: View {
  @State private var modelDescription = """
    
     2 Chopsticks side by side with rings connected to the chopsticks in the middle, chopstick assistive device, not overlapped, side by side, wth real life dimensions
  
  """
  @State private var bpyURL: URL?
  @State private var objURL: URL?
  @State private var isGenerating = false
  @State private var errorMessage: String?
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 16) {
        Text("3D Model Generator")
          .font(.title)
          .padding(.bottom, 8)
        
        Text("Enter a description of the 3D model you want to create:")
          .font(.headline)
        
        TextEditor(text: $modelDescription)
          .frame(minHeight: 200)
          .padding(4)
          .overlay(
            RoundedRectangle(cornerRadius: 8)
              .stroke(Color.gray.opacity(0.5), lineWidth: 1)
          )
        
        Button(action: {
          Task {
            await generateModel()
          }
        }) {
          Text("Generate Model")
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding()
            .background(isGenerating ? Color.gray : Color.blue)
            .cornerRadius(8)
        }
        .disabled(isGenerating)
        .padding(.top, 8)
        
        if let errorMessage = errorMessage {
          Text("Error: \(errorMessage)")
            .foregroundColor(.red)
        }
        
        if let objURL = objURL {
          Text("OBJ File generated at: \(objURL.path)")
            .font(.body)
            .padding(.top, 8)
        }
      }
      .padding()
    }
  }
  
  func generateModel() async {
    isGenerating = true
    errorMessage = nil
    
    do {
      // Generate BPY script
      bpyURL = try await generateScriptUsingGroq(from: modelDescription)
      
      // Convert BPY to OBJ
      if let bpyURL = bpyURL {
        objURL = try await convertBPYToOBJ(scriptURL: bpyURL)
      }
    } catch {
      errorMessage = error.localizedDescription
    }
    
    isGenerating = false
  }
}

struct BPYToOBJView_Previews: PreviewProvider {
  static var previews: some View {
    BPYToOBJView()
  }
}
