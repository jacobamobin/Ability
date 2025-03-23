//
//  GlowEffect.swift
//  Ability
//
//  Created by Jacob Mobin on 3/22/25.
//

// CITATION
// THE CODE BELOW WAS CREATED BY JACOB MOBIN,
// THIS CODE IS AVAILABLE ON https://github.com/jacobamobin/AppleIntelligenceGlowEffect

import SwiftUI

struct GlowEffect: View {
    @State private var gradientStops: [Gradient.Stop] = GlowEffect.generateGradientStops()

    var body: some View {
        ZStack {
            EffectNoBlur(gradientStops: gradientStops, width: 6)
                .onAppear {
                    // Start a timer to update the gradient stops every second
                    Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { _ in
                        withAnimation(.easeInOut(duration: 0.5)) {
                            gradientStops = GlowEffect.generateGradientStops()
                        }
                    }
                }
            Effect(gradientStops: gradientStops, width: 9, blur: 4)
                .onAppear {
                    // Start a timer to update the gradient stops every second
                    Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { _ in
                        withAnimation(.easeInOut(duration: 0.6)) {
                            gradientStops = GlowEffect.generateGradientStops()
                        }
                    }
                }
            Effect(gradientStops: gradientStops, width: 11, blur: 12)
                .onAppear {
                    // Start a timer to update the gradient stops every second
                    Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { _ in
                        withAnimation(.easeInOut(duration: 0.8)) {
                            gradientStops = GlowEffect.generateGradientStops()
                        }
                    }
                }
            Effect(gradientStops: gradientStops, width: 15, blur: 15)
                .onAppear {
                    // Start a timer to update the gradient stops every second
                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                        withAnimation(.easeInOut(duration: 1)) {
                            gradientStops = GlowEffect.generateGradientStops()
                        }
                    }
                }
        }
    }
    
    // Function to generate random gradient stops
    static func generateGradientStops() -> [Gradient.Stop] {
        [
            Gradient.Stop(color: Color(hex: "4796E3"), location: Double.random(in: 0...1)),
            Gradient.Stop(color: Color(hex: "9177C7"), location: Double.random(in: 0...1)),
            Gradient.Stop(color: Color(hex: "CA6673"), location: Double.random(in: 0...1)),
            Gradient.Stop(color: Color(hex: "A4C8F0"), location: Double.random(in: 0...1)),
            Gradient.Stop(color: Color(hex: "C4B1E0"), location: Double.random(in: 0...1)),
            Gradient.Stop(color: Color(hex: "E8A3AD"), location: Double.random(in: 0...1))
        ].sorted { $0.location < $1.location }
    }
}

struct Effect: View {
    var gradientStops: [Gradient.Stop]
    var width: CGFloat
    var blur: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 55)
                .strokeBorder(
                    AngularGradient(
                        gradient: Gradient(stops: gradientStops),
                        center: .center
                    ),
                    lineWidth: width
                )
                .frame(
                    width: UIScreen.main.bounds.width,
                    height: UIScreen.main.bounds.height
                )
                .padding(.top, -17)
                .blur(radius: blur)
        }
    }
}

struct EffectNoBlur: View {
    var gradientStops: [Gradient.Stop]
    var width: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 55)
                .strokeBorder(
                    AngularGradient(
                        gradient: Gradient(stops: gradientStops),
                        center: .center
                    ),
                    lineWidth: width
                )
                .frame(
                    width: UIScreen.main.bounds.width,
                    height: UIScreen.main.bounds.height
                )
                .padding(.top, -26)
        }
    }
}


#Preview {
    GlowEffect()
}
