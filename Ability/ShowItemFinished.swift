//
//  ShowItemFinished.swift
//  Ability
//
//  Created by Jacob Mobin on 3/22/25.
//
import SwiftUI
import SceneKit

struct ShowItemFinished: View {
    var detailedPrompt: String
    var objFileURL: URL?
    var errorMessage: String?

    @State private var descriptionText: String = ""
    @State private var scene = SCNScene()
    @State private var isSavedToLibrary = false
    @State private var isProcessing = false
    @State private var localObjFileURL: URL? // Added this to track the local URL of the file

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)

            VStack(spacing: 30) {
                SceneView(
                    scene: scene,
                    options: [.autoenablesDefaultLighting, .allowsCameraControl]
                )
                .frame(width: 350, height: 350)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 10)
                .padding()
                .onAppear {
                    setupScene()
                    descriptionText = detailedPrompt
                }
                
                TextEditor(text: $descriptionText)
                    .frame(height: 80)
                    .padding()
                    .background(Color.gray.opacity(0.2)) // Subtle background
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                    .padding(.horizontal)

                HStack {
                    Button(action: {
                        // Replace with actual save logic
                        saveToFiles(url: localObjFileURL) { success in
                            isSavedToLibrary = success
                            if success {
                                descriptionText = "" // Clear text after saving
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: isSavedToLibrary ? "checkmark.circle.fill" : "square.and.arrow.down.fill")
                                .font(.headline)
                            Text(isSavedToLibrary ? "Saved" : "Save To Files")
                                .font(.headline)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [
                                isSavedToLibrary ? .green : .teal,
                                isSavedToLibrary ? .green : .purple
                            ]), startPoint: .leading, endPoint: .trailing)
                        )
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                        .disabled(isSavedToLibrary) // Disable after saving
                    }

                    Button(action: {
                        processUserInput()
                    }) {
                        HStack {
                            Image(systemName: "arrow.clockwise") // Refresh icon
                                .font(.headline)
                            Text("Regenerate")
                                .font(.headline)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [.orange, .pink]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                        .disabled(isProcessing)
                    }
                }
                .padding(10)
                .padding(.bottom, 40)

                if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                }
            }
        }
    }

    func setupScene() {
        // Set up the 3D scene using the OBJ file
        if let objURL = objFileURL, let loadedScene = try? SCNScene(url: objURL, options: nil) {
            scene = loadedScene
        } else {
            scene = SCNScene()
            let box = SCNBox(width: 0.5, height: 0.5, length: 0.5, chamferRadius: 0)
            let boxNode = SCNNode(geometry: box)
            scene.rootNode.addChildNode(boxNode)
        }
    }

    mutating func processUserInput() {
        isProcessing = true
        Task {
            do {
                // Replace with your actual process
                let bpyURL = try await generateScriptUsingGroq(from: descriptionText)
                let objURL = try await convertBPYToOBJ(scriptURL: bpyURL)
                
                // Update the state on the main thread
                await MainActor.run {
                    self.localObjFileURL = objURL  // Update the local object file URL
                    self.setupScene()              // Reconfigure the scene with the new object
                    self.isProcessing = false       // Stop processing
                }
            } catch {
                // Handle errors
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isProcessing = false
                }
            }
        }
    }

    func saveToFiles(url: URL?, completion: @escaping (Bool) -> Void) {
        // Save logic
        guard let url = url else {
            completion(false)
            return
        }
        
        print("Saving file to: \(url)")
        completion(true)
    }
}
