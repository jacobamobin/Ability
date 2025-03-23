//
//  Onboarding.swift
//  Ability
//
//  Created by Jacob Mobin on 3/21/25.
//

import SwiftUI

struct Onboarding: View {
    @State private var currentPage = 0

    let pages = [
        OnboardingPage(
            title: "Welcome to Ability!",
            description: "Empowering creativity in assistive design for a better life.",
            imageName: "Icon",
            isLastPage: false
        ),
        OnboardingPage(
            title: "How It Works",
            description: "Simply describe your assistive need—and our intelligent system gets to work.",
            imageName: "HashMap",
            isLastPage: false
        ),
        OnboardingPage(
            title: "Powered by Gemini AI",
            description: "Our Gemini AI examines your input and transforms it into a precise CAD prompt for generating a 3D model.",
            imageName: "Star",
            isLastPage: false
        ),
        OnboardingPage(
            title: "Seamless 3D Printing",
            description: "Preview, tweak and finalize your custom assistive tool—ready for 3D printing in minutes.",
            imageName: "3DPrinter",
            isLastPage: false
        ),
        OnboardingPage(
            title: "Ready to Launch?",
            description: "Begin your journey toward personalized assistance.",
            imageName: "rocket-image",
            isLastPage: true
        )
    ]

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.purple, .blue]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    TabView(selection: $currentPage) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            pages[index]
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                    
                    Spacer()
                    /* NEXT BUTTON REMOVED
                     if pages[currentPage].isLastPage {
                     NavigationLink(destination: ContentView()) {
                     Text("Get Started")
                     .font(.title2)
                     .fontWeight(.bold)
                     .foregroundColor(.white)
                     .padding()
                     .background(Color.blue)
                     .cornerRadius(10)
                     }
                     .padding(.top, 5)
                     } else {
                     /*
                      Button("Next") {
                      currentPage += 1
                      }
                      .font(.title2)
                      .foregroundColor(.white)
                      .padding() */
                     }
                     }
                     .padding(.bottom, 20)
                     */
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct OnboardingPage: View {
    let title: String
    let description: String
    let imageName: String
    let isLastPage: Bool

    var body: some View {
        VStack(spacing: 20) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .padding()
                .transition(.scale) // Add a nice scaling transition
                .animation(.easeInOut(duration: 0.5)) // Smooth animation
            
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            Text(description)
                .font(.body)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding([.horizontal, .top])
        }
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding()
    }
}
