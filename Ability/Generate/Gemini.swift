//
//  Gemini.swift
//  Ability
//
//  Created by Jacob Mobin on 3/22/25.
//

import GoogleGenerativeAI
import SwiftUI

func generate3dPrompt(userInput: String, images: [UIImage]) async throws -> String {
    let model = GenerativeModel(name: "gemini-1.5-flash-latest", apiKey: "AIzaSyCEmGiEY5P4leE3xJYhwR-2QEk_GbOQK3M")

    var prompt = """
    Our goal is to design and help individuals with disabilities easily create custom 3D-printable prosthetics and attachments for everyday items.Your goal is to produce a description that makes accurate assumptions about size and other key functionality features for the 3D model which will assist with people who have disabilities to 3D print prosthetics. Your prompt will be later fed to an AI to create the 3D model itself, Thus I need you to accurately follow the following guidelines.

    (userInput), take this input plan and imagine what the item looks like. Then split the item into different faces and make each face for the 3D model. If the item is built together make sure all components are together and joint at its most ideal spot. If it is multiple items like chop sticks make sure that items do not overlap. Describe each step as you go

    For example: Build a Chopstick with stability aids

    Make two individual chopsticks
    Then add two finger rings to the middle of the chopsticks

    Return a text similar to above

    Input:
    <idea>
    (userInput)
    </idea>

     ### Expected Output:
    <description>
     ...Your expanded, detailed object description here...
    </description>
    """

    
    prompt += "\nUser's description: \(userInput)\n"
    
    if !images.isEmpty {
        prompt += "The user has provided \(images.count) image(s) for reference.\n"
    } else {
        prompt += "No images provided.\n"
    }

    prompt += "Please ensure the model is detailed and accurate based on the user's description and images. If the user input is not very descriptive, make reasonable assumptions on dimensions and other functionalities."
    
    do {
        let modelOutput = try await model.generateContent(prompt)
        print(modelOutput.text ?? "No output generated.")
        return modelOutput.text ?? "No output generated."
    } catch {
        return "Error generating content: \(error.localizedDescription)"
    }
}

struct ButtonView: View {
    @State private var result: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Button {
                Task {
                    do {
                        result = try await generate3dPrompt(userInput: "I cant hold chopsticks because of my tremors, i want a ring that goes around my finger, and a part that attached to the chopsticks so i can hold them", images: [])
                    } catch {
                        result = "Error: \(error.localizedDescription)"
                    }
                }
            } label: {
                Text("Run")
            }
            ScrollView{
                Text(result)
                    .padding()
                    .foregroundColor(.black)
            }
            
        }
    }
}

#Preview {
    ButtonView()
}
