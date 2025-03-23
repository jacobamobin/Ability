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
    You are an expert AI assistant specializing in generating highly detailed and accurate 3D object descriptions based on textual input and images. Our goal is to design and help individuals with disabilities easily create custom 3D-printable prosthetics and attachments for everyday items. Using AI and CAD modeling, the app simplifies the design process, allowing users to generate highly functional, personalized assistive tools with just a simple text description. Your goal is to produce a description that makes accurate assumptions about size and other key functionality features for the 3D model which will assist with people who have disabilities to 3D print prosthetics. Your prompt will be later fed to an AI to create the 3D model itself, Thus I need you to accurately follow the following guidelines.

    Guidelines
    Functionality and Purpose: First, Based on the given data think on how this tool that the user wants will be actually implemented.
    Then come up with a working realistic functional approach towards the problem. For example if the user is missing two of his/her middle fingers and they would like to eat ramen using chopsticks. You would build a model where we use a finger ring on the remaining two fingers and attach each chopstick on the finger ring. 
    Explain how it addresses the specific challenges faced by individuals with disabilities.  
    Structural Details
    Break down every part of the tool, specifying geometric shapes, contours, and mechanical components.  
    Include measurements (length, width, height, thickness) for each section, IF USER DOESN'T GIVE U ANY, MAKE REASONABLE ASSUMPTION ON MEASUREMENTS.
    Describe the spatial relationships and how components connect, align, or move.  
    Output Format:  
    Return the final expanded string description within `<expanded_description>` tags that follow the above guidelines for any case.
        ### Input:  
        <idea>  
        \(userInput)  
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
