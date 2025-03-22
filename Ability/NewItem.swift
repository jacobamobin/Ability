//
//  NewItem.swift
//  Ability
//
//  Created by Jacob Mobin on 3/21/25.
//


import SwiftUI
import PhotosUI

struct NewItemView: View {
    @State private var description: String = ""
    @State private var selectedImages: [PhotosPickerItem] = []
    @State private var selectedImagesAsData: [Data] = []

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 15) {
                Text("Describe Your Need")
                    .font(.title2)
                    .bold()
                    .padding(.horizontal)

                Text("E.g., \"I have tremors and can't use chopsticks.\"")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.horizontal)

                TextEditor(text: $description)
                    .frame(height: 150)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(.systemGray6))
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [.purple, .blue]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 2
                                    )
                            )
                            .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 5)
                    )
                    .padding(.horizontal)

                Text("Add Images (Optional)")
                    .font(.headline)
                    .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(selectedImagesAsData, id: \.self) { imageData in
                            if let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .shadow(radius: 5)
                            }
                        }

                        PhotosPicker(
                            selection: $selectedImages,
                            matching: .images,
                            photoLibrary: .shared()) {
                                VStack {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 50))
                                        .foregroundColor(.blue)
                                    Text("Add")
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                }
                            }
                            .onChange(of: selectedImages) { newItems in
                                Task {
                                    for newItem in newItems {
                                        if let imageData = try? await newItem.loadTransferable(type: Data.self) {
                                            selectedImagesAsData.append(imageData)
                                        }
                                    }
                                }
                            }
                    }
                    .padding(.horizontal)
                }

                Spacer()

                Button(action: {
                    // Generate Model Action
                }) {
                    HStack {
                        Image(systemName: "wand.and.stars")
                            .font(.headline)
                        Text("Generate")
                            .font(.headline)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .purple]),
                            startPoint: .leading,
                            endPoint: .trailing)
                    )
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationTitle("New Item")
        }
    }
}

struct NewItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewItemView()
    }
}
