//
//  WalkSyncApp.swift
//  WalkSync
//
//

import SwiftUI
import SwiftData

@main
struct WalkSyncApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Activity.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            OnboardingView()
        }
        .modelContainer(sharedModelContainer)
    }
}
