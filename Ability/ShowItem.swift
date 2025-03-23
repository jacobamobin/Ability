//
//  ShowItem.swift
//  Ability
//
//  Created by Jacob Mobin on 3/22/25.
//

import SwiftUI
import SceneKit

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
    @State private var navigateToFinished = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
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
                        NavigationLink(destination: ShowItemFinished(detailedPrompt: detailedPrompt, objFileURL: objFileURL, errorMessage: errorMessage), isActive: $navigateToFinished) {
                        }
                    }
                }
                .transition(.opacity)
                .animation(.easeInOut(duration: 1.5), value: stage)
            }
            .onAppear {
                Task {
                    do {
                        let prompt = try await generate3dPrompt(userInput: description, images: selectedImages)
                        detailedPrompt = prompt
                        withAnimation { stage = .model }
                        
                        let bpyURL = try await generateScriptUsingGroq(from: prompt)
                        objFileURL = try await convertBPYToOBJ(scriptURL: bpyURL)
                        
                        withAnimation {
                            stage = .finished
                            navigateToFinished = true
                        }
                    } catch {
                        errorMessage = error.localizedDescription
                        withAnimation { stage = .finished; navigateToFinished = true }
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
                .offset(y: -18)
            VStack(spacing: 20) {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .scaleEffect(imageScale)
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                    .onAppear {
                        withAnimation(.easeOut(duration: 1.5)) {
                            imageScale = imageName.lowercased() == "gemini" ? 1.5 : 2.0
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
