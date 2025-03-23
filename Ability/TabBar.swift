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
            NewItem()
                .tabItem {
                    Image(systemName: "cube.fill")
                    Text("New Item")
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
        }
        .accentColor(.blue)
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
