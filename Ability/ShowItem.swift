//
//  ShowItem.swift
//  Ability
//
//  Created by Jacob Mobin on 3/22/25.
//

import SwiftUI

enum GenerationStage {
    case idea
    case model
    case finished
}

struct ShowItem: View {
    @State private var stage: GenerationStage = .idea

    var body: some View {
        NavigationStack {
            ZStack {
                // A modern gradient background.
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
                
                // Display the current stage with smooth transitions.
                Group {
                    switch stage {
                    case .idea:
                        AnimatedScreenView(
                            title: "Generating Ideas",
                            subhead: "We use large launguage models to cater models for your specific needs.",
                            imageName: "Gemini"
                        )
                    case .model:
                        AnimatedScreenView(
                            title: "Making Ideas Real",
                            subhead: "We use advanced AI to transform your ideas into immersive printable 3D models.",
                            imageName: "rocket-image"
                        )
                    case .finished:
                        ShowItemFinished()
                    }
                    
                }
                .transition(.opacity)
                .animation(.easeInOut(duration: 1.5), value: stage)
            }
            .onAppear {
                // Start with a slight delay for the initial animation.
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    // Transition from idea stage to model stage after 3 seconds.
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            stage = .model
                        }
                        // Transition to the finished stage after another 3 seconds.
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                stage = .finished
                            }
                        }
                    }
                }
            }
        }
    }
}



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
                            if imageName == "gemini" {
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

struct FinishedView: View {
    @State private var fadeIn = false
    @State private var scaleUp = false
    
    var body: some View {
        Text("Hello world")
            .font(.system(size: 50, weight: .heavy, design: .rounded))
            .foregroundColor(.white)
            .scaleEffect(scaleUp ? 1.0 : 0.5)
            .opacity(fadeIn ? 1.0 : 0.0)
            .onAppear {
                withAnimation(.easeOut(duration: 1.0)) {
                    fadeIn = true
                }
                withAnimation(.easeOut(duration: 1.0).delay(0.5)) {
                    scaleUp = true
                }
            }
    }
}

#Preview {
    ShowItem()
}
