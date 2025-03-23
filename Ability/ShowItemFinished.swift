//
//  ShowItemFinished.swift
//  Ability
//
//  Created by Jacob Mobin on 3/22/25.
//

import SwiftUI
import SceneKit

struct ShowItemFinished: View {
    @State private var description: String = ""
    @State private var scene = SCNScene()
    @State private var isSavedToLibrary = false // Track if the button is pressed

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            VStack (spacing: 30){
                /*
                Text("Item")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding() */

                SceneView(scene: scene)
                    .frame(width: 350, height: 350)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 10)
                    .padding()
                    .onAppear {
                        setupScene()
                    }

                // REDO TEXT
                TextEditor(text: $description)
                    .frame(height: 80)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.white)
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
                            .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 5)
                    )
                    .padding(.horizontal)
                    .overlay(
                        HStack(spacing: 10) {
                            
                            // Microphone Button
                            Button(action: {
                                //UIApplication.shared.openKeyboardForDictation()
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
                                //UIApplication.shared.endEditing()
                            }) {
                                Text("Make Changes")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(width: 140, height: 50)
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
                
                
                // BUTTONS
                HStack {
                    Button(action: {
                        // Generate Model Action
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
                                endPoint: .trailing)
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
                                endPoint: .trailing)
                        )
                        .foregroundColor(.white) // Grey out text when pressed
                        .cornerRadius(12)
                        .shadow(radius: 5)
                        .disabled(isSavedToLibrary) // Disable the button when pressed
                    }
                    
                }.padding(10)
                    .padding(.bottom, 40)
            }
            
        }
    }

    func setupScene() {
        // Create a simple square (replace with your actual model)
        let box = SCNBox(width: 0.5, height: 0.5, length: 0.5, chamferRadius: 0)
        let boxNode = SCNNode(geometry: box)
        scene.rootNode.addChildNode(boxNode)

        // Position the camera (adjust as needed)
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 2)
        scene.rootNode.addChildNode(cameraNode)
    }
}

#Preview {
    ShowItemFinished()
}
