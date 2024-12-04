//
//  TabView.swift
//  WalkSync
//

import SwiftUI
import SwiftData

struct MainView: View {
    var body: some View {
        TabView {
            // Dashboard Navigation
            NavigationStack {
                DashboardView()
            }
            .tabItem {
                Label("Dashboard", systemImage: "list.dash")
            }
            
            // Compass Navigation
            CompassView()
                .tabItem {
                    Label("Compass", systemImage: "safari")
                }
            
            // Profile Navigation
            NavigationStack {
                ProfileView() // Link ProfileView here
            }
            .tabItem {
                Label("Profile", systemImage: "person.circle")
            }
            
//            // Settings Navigation (Optional, add if needed)
//            NavigationStack {
//                SettingsView() // Add your SettingsView
//            }
//            .tabItem {
//                Label("Settings", systemImage: "gearshape")
//            }
        }
        .onAppear {
            UITabBar.appearance().backgroundColor = UIColor.lightGray.withAlphaComponent(0.05)
        }
    }
}

#Preview {
    MainView()
        .modelContainer(for: Activity.self, inMemory: true)
}
