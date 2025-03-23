//
//  ShowItem.swift
//  Ability
//
//  Created by Jacob Mobin on 3/22/25.
//

import SwiftUI
import GoogleGenerativeAI

enum GenerationStage {
    case idea
    case model
    case finished
}

struct ShowItem: View {
    @Binding var description: String
    @Binding var selectedImages: [UIImage]
    
    @State private var stage: GenerationStage = .idea
    @State private var detailedPrompt: String = ""
    @State private var objFileURL: URL?
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            ZStack {
                // A modern gradient background.
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                // Display the current stage with smooth transitions.
                Group {
                    switch stage {
                    case .idea:
                        AnimatedScreenView(
                            title: "Generating Ideas",
                            subhead: "Processing your description and images...",
                            imageName: "Gemini"
                        )
                    case .model:
                        AnimatedScreenView(
                            title: "Making Ideas Real",
                            subhead: "Generating 3D model from your prompt...",
                            imageName: "rocket-image"
                        )
                    case .finished:
                        // Transition to the finished file.
                        ShowItemFinished(
                            detailedPrompt: detailedPrompt,
                            objFileURL: objFileURL,
                            errorMessage: errorMessage
                        )
                    }
                }
                .transition(.opacity)
                .animation(.easeInOut(duration: 1.5), value: stage)
            }
            .onAppear {
                // Start the generation chain asynchronously.
                Task {
                    do {
                        // STEP 1: Generate the detailed prompt using the user's description and images.
                        let prompt = try await generate3dPrompt(userInput: description, images: selectedImages)
                        detailedPrompt = prompt
                        print("Detailed prompt: \(prompt)")
                        
                        // Transition to the "model" stage.
                        withAnimation {
                            stage = .model
                        }
                        
                        // STEP 2: Generate the BPY script from the detailed prompt using Groq.
                        let bpyURL = try await generateScriptUsingGroq(from: prompt)
                        
                        // STEP 3: Convert the BPY script into an OBJ file.
                        objFileURL = try await convertBPYToOBJ(scriptURL: bpyURL)
                        
                        // Transition to finished stage.
                        withAnimation {
                            stage = .finished
                        }
                    } catch {
                        errorMessage = error.localizedDescription
                        // If an error occurs, transition to finished to show error info.
                        withAnimation {
                            stage = .finished
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Animated Screen View
struct AnimatedScreenView: View {
    var title: String
    var subhead: String
    var imageName: String
    
    @State private var imageScale: CGFloat = 0.5
    @State private var textOffset: CGFloat = 50
    @State private var textOpacity: Double = 0.0
    
    var body: some View {
        ZStack {
            GlowEffect()
                .offset(y: -17)
            VStack(spacing: 20) {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .scaleEffect(imageScale)
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                    .onAppear {
                        withAnimation(.easeOut(duration: 1.5)) {
                            // Use a case-insensitive check.
                            if imageName.lowercased() == "gemini" {
                                imageScale = 1.5
                            } else {
                                imageScale = 2.0
                            }
                        }
                    }
                
                VStack(spacing: 10) {
                    Text(title)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.black)
                        .transition(.slide)
                    
                    Text(subhead)
                        .font(.headline)
                        .foregroundColor(.black.opacity(0.85))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        .transition(.opacity)
                }
                .offset(y: textOffset)
                .opacity(textOpacity)
                .onAppear {
                    withAnimation(.easeOut(duration: 1.5).delay(0.5)) {
                        textOffset = 0
                        textOpacity = 1.0
                    }
                }
            }
        }
    }
}

#Preview {
    ShowItem(description: .constant("I have tremors and can't hold chopsticks properly."), selectedImages: .constant([]))
}
