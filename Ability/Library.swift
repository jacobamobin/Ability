//
//  Library.swift
//  Ability
//
//  Created by Jacob Mobin on 3/21/25.
//
/*
import SwiftUI
import SceneKit

struct Library: View {
    @State private var items: [(name: String, fileURL: URL)] = []

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Iterate through the items to display them in a 2-column grid
                        ForEach(items.indices, id: \.self) { index in
                            HStack {
                                // Display each item in a grid with 2 items per row
                                itemView(item: items[index])
                                
                                if (index + 1) % 2 != 0 {
                                    Spacer()  // Adds space to create the 2-column grid
                                }
                            }
                        }
                    }
                    .padding()
                }
                .navigationTitle("Library")
            }
        }
        .onAppear(perform: loadItems)
    }

    // MARK: - Load Items from UserDefaults
    func loadItems() {
        items.removeAll()
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            if let itemData = UserDefaults.standard.dictionary(forKey: key),
               let filePath = itemData["path"] as? String {
                let fileURL = URL(fileURLWithPath: filePath)
                items.append((name: key, fileURL: fileURL))
            }
        }
    }

    // MARK: - Delete Item
    func deleteItem(at offsets: IndexSet) {
        for index in offsets {
            let item = items[index]
            UserDefaults.standard.removeObject(forKey: item.name)
            try? FileManager.default.removeItem(at: item.fileURL)
        }
        items.remove(atOffsets: offsets)
    }

    // MARK: - Save to Files
    func saveToFiles(url: URL) {
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = scene.windows.first?.rootViewController {
            rootViewController.present(activityVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - Item View for Display
    func itemView(item: (name: String, fileURL: URL)) -> some View {
        VStack {
            SceneView(fileURL: item.fileURL) // Show the 3D scene
                .frame(width: 150, height: 150)
                .cornerRadius(10)
                .padding()
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3)
                        .shadow(radius: 5)
                )
            
            Text(item.name)
                .font(.headline)
                .lineLimit(1)
            
            HStack {
                // Save to Files Button
                Button(action: {
                    saveToFiles(url: item.fileURL)
                }) {
                    Text("Save to Files")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                // Delete Button (minus icon)
                Button(action: {
                    deleteItem(at: IndexSet([items.firstIndex(where: { $0.name == item.name }) ?? 0]))
                }) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.red)
                        .font(.title)
                }
            }
            .padding([.top, .horizontal])
        }
        .frame(width: 170) // Width of each item view
    }
}

// MARK: - SceneView: Show OBJ file in SceneKit
struct SceneView: View {
    var fileURL: URL
    @State private var scene = SCNScene()
    
    var body: some View {
        SCNViewRepresentable(scene: $scene, fileURL: fileURL) // Pass fileURL to SCNViewRepresentable
            .onAppear {
                loadScene()
            }
    }
    
    private func loadScene() {
        guard let scene = try? SCNScene(url: fileURL, options: nil) else { return }
        self.scene = scene
    }
}

// MARK: - SCNViewRepresentable: Make SceneKit view work in SwiftUI
struct SCNViewRepresentable: UIViewRepresentable {
    @Binding var scene: SCNScene
    var fileURL: URL
    
    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.scene = scene
        scnView.autoenablesDefaultLighting = true
        scnView.allowsCameraControl = true
        return scnView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        uiView.scene = scene
    }
}

#Preview {
    Library()
}
*/
