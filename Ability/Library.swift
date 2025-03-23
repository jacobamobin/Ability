//
//  Library.swift
//  Ability
//
//  Created by Jacob Mobin on 3/21/25.
//

import SwiftUI

struct Library: View {
    @State private var items: [(name: String, fileURL: URL)] = []

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                List {
                    ForEach(items, id: \.name) { item in
                        HStack {
                            Image(systemName: "cube.fill")
                                .foregroundColor(.blue)
                                .frame(width: 40, height: 40)
                            
                            Text(item.name)
                                .font(.headline)
                            
                            Spacer()
                            
                            Button(action: {
                                saveToFiles(url: item.fileURL)
                            }) {
                                Text("Save to Files")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .onDelete(perform: deleteItem)
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
}

#Preview {
    Library()
}
