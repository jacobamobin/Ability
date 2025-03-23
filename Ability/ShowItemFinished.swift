//
//  ShowItemFinished.swift
//  Ability
//
//  Created by Jacob Mobin on 3/22/25.
//
import SwiftUI
import SceneKit

// MARK: - Finished View
struct ShowItemFinished: View {
    var detailedPrompt: String
    var objFileURL: URL?
    var errorMessage: String?
    
    @State private var descriptionText: String = ""
    @State private var scene = SCNScene()
    @State private var isSavedToLibrary = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30) {
                    // SceneView that displays the loaded OBJ model.
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
                        // Pre-fill text editor with the detailed prompt.
                        descriptionText = detailedPrompt
                    }
                    
                    // Text editor for the generated description.
                    TextEditor(text: $descriptionText)
                    
                        .frame(height: 80)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(
                                            LinearGradient(
                                                gradient: Gradient(colors: [.purple, .blue]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 5
                                        )
                                )
                                .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 5)
                        )
                        .padding(.horizontal)
                        .overlay(
                            HStack(spacing: 10) {
                                // Microphone Button
                                Button(action: {
                                    UIApplication.shared.windows.first?.endEditing(true)
                                    // Pull up keyboard for dictation (if supported)
                                    UIApplication.shared.sendAction(#selector(UIResponder.becomeFirstResponder), to: nil, from: nil, for: nil)
                                }) {
                                    Image(systemName: "mic.fill")
                                        .font(.title3)
                                        .foregroundColor(.white)
                                        .frame(width: 50, height: 50)
                                        .background(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color(hex: "5661d4"), Color(hex: "4465d6")]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .clipShape(Circle())
                                        .shadow(radius: 5)
                                }
                                
                                // Done Button
                                Button(action: {
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                }) {
                                    Text("Make Edits")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(width: 120, height: 50)
                                        .background(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color(hex: "4366d8"), Color(hex: "0b6fe7")]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .cornerRadius(25)
                                        .shadow(radius: 5)
                                }
                            }
                                .padding(8)
                                .offset(x: -17, y: 32),
                            alignment: .bottomTrailing
                        ).padding(.bottom, 20)
                    
                    // Action buttons.
                    HStack {
                        Button(action: {
                            // Save to files action.
                        }) {
                            HStack {
                                Image(systemName: "square.and.arrow.down.fill")
                                    .font(.headline)
                                Text("Save To Files")
                                    .font(.headline)
                                    .lineLimit(1)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [.teal, .purple]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                        }
                        
                        Button(action: {
                            isSavedToLibrary = true
                        }) {
                            HStack {
                                Image(systemName: "books.vertical.fill")
                                    .font(.headline)
                                Text("Save To Library")
                                    .lineLimit(1)
                                    .font(.headline)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: isSavedToLibrary ? [.gray, .gray] : [.orange, .pink]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                            .disabled(isSavedToLibrary)
                        }
                    }
                }
                .padding()
            }
        }
    }

    private func setupScene() {
        // Your logic to load the 3D model into SceneKit
        guard let url = objFileURL else { return }
        let scene = SCNScene(named: url.path)
        self.scene = scene ?? SCNScene()
    }
}

#Preview {
    ShowItemFinished(
        detailedPrompt: "Your generated prompt goes here...",
        objFileURL: nil,
        errorMessage: nil
    )
}
