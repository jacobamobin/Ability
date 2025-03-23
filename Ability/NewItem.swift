//
//  NewItem.swift
//  Ability
//
//  Created by Jacob Mobin on 3/21/25.
//

import SwiftUI
import PhotosUI
import MobileCoreServices

struct NewItem: View {
    @State private var description: String = ""
    @State private var selectedImages: [PhotosPickerItem] = []
    @State private var selectedImagesAsData: [Data] = []
    
    @State private var showImagePickerOptions = false
    @State private var sourceType: UIImagePickerController.SourceType?
    @State private var showImagePicker = false
    @State private var showDocumentPicker = false
    
    // A computed binding that converts stored Data to UIImage.
    private var selectedUIImageBinding: Binding<[UIImage]> {
        Binding<[UIImage]>(
            get: {
                selectedImagesAsData.compactMap { UIImage(data: $0) }
            },
            set: { newImages in
                // If needed, convert back to Data or handle changes.
                selectedImagesAsData = newImages.compactMap { $0.jpegData(compressionQuality: 0.8) }
            }
        )
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Describe Your Need")
                        .font(.title)
                        .bold()
                        .padding(.horizontal)
                    
                    Text("E.g., \"I have tremors and can't use chopsticks,\nMake me a tool to help me hold them.\"")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                    TextEditor(text: $description)
                        .frame(height: 130)
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
                                            lineWidth: 4
                                        )
                                )
                                .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 5)
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
                                    Text("Done")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(width: 80, height: 50)
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
                    
                    Text("Add Images (Optional)")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(selectedImagesAsData.indices, id: \.self) { index in
                                if let uiImage = UIImage(data: selectedImagesAsData[index]) {
                                    ZStack(alignment: .topTrailing) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .shadow(radius: 5)
                                        
                                        Button(action: {
                                            selectedImagesAsData.remove(at: index)
                                        }) {
                                            Image(systemName: "minus.circle.fill")
                                                .foregroundColor(.red)
                                                .background(Color.white)
                                                .clipShape(Circle())
                                        }
                                        .offset(x: -4, y: 4)
                                    }
                                }
                            }
                            
                            Button(action: {
                                showImagePickerOptions = true
                            }) {
                                VStack {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 50))
                                        .foregroundColor(.blue)
                                    Text("Add")
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                }
                                .frame(width: 100, height: 100)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(Color(uiColor: .secondarySystemBackground))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .strokeBorder(Color.secondary.opacity(0.2), lineWidth: 1)
                                )
                                .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
                            }
                        }
                        .padding(.horizontal)
                    }
                    Spacer()
                    
                    NavigationLink(destination: ShowItem(description: $description, selectedImages: selectedUIImageBinding)) {
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
                .confirmationDialog("Choose Image Source", isPresented: $showImagePickerOptions, titleVisibility: .visible) {
                    Button("Photo Library") {
                        sourceType = .photoLibrary
                        showImagePicker = true
                    }
                    
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        Button("Camera") {
                            sourceType = .camera
                            showImagePicker = true
                        }
                    }
                    
                    Button("Files") {
                        showDocumentPicker = true
                    }
                }
                .sheet(isPresented: $showImagePicker) {
                    if let sourceType = sourceType {
                        ImagePicker(sourceType: sourceType, selectedImage: { image in
                            if let imageData = image.jpegData(compressionQuality: 0.8) {
                                selectedImagesAsData.append(imageData)
                            }
                        })
                    }
                }
                .sheet(isPresented: $showDocumentPicker) {
                    DocumentPicker(selectedFile: { url in
                        if let imageData = try? Data(contentsOf: url) {
                            selectedImagesAsData.append(imageData)
                        }
                    })
                }
            }
        }
    }
}

// Custom Image Picker Wrapper
struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    var selectedImage: (UIImage) -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage(image)
            }
            picker.dismiss(animated: true)
        }
    }
}

// Custom Document Picker Wrapper
struct DocumentPicker: UIViewControllerRepresentable {
    var selectedFile: (URL) -> Void
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.image], asCopy: true)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker
        
        init(_ parent: DocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            parent.selectedFile(url)
        }
    }
}


struct NewItem_Previews: PreviewProvider {
    static var previews: some View {
        NewItem()
    }
}
