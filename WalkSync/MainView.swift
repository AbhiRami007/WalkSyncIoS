//
//  TabView.swift
//  WalkSync
//
//

import SwiftUI
import SwiftData

struct MainView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "list.dash")
                }
            
            CompassView()
                .tabItem {
                    Label("Compass", systemImage: "safari")
                }

        }
        .onAppear() {
            UITabBar.appearance().backgroundColor = UIColor.lightGray.withAlphaComponent(0.05)
        }
    }
}

#Preview {
    MainView()
        .modelContainer(for: Item.self, inMemory: true)
}
