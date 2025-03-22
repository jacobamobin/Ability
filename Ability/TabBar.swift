//
//  TabBar.swift
//  Ability
//
//  Created by Jacob Mobin on 3/21/25.
//

import SwiftUI

struct TabBar: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            NewItemView()
                .tabItem {
                    Image(systemName: "cube.fill")
                    Text("Object")
                }
                .tag(0)

            Library()
                .tabItem {
                    Image(systemName: "books.vertical.fill")
                    Text("Library")
                }
                .tag(1)
            
            Onboarding()
                .tabItem {
                    Image(systemName: "questionmark")
                    Text("How To Use")
                }
                .tag(2)

            Settings()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(3)
        }
        .accentColor(.blue)
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
