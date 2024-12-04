//
//  SettingsView.swift
//  WalkSync
//
//  Created by Abhirami Pradeep Susi on 2024-12-03.
//

import SwiftUI
import AVFoundation

struct SettingsView: View {
    @AppStorage("musicPlaying") private var isMusicPlaying = false
    @AppStorage("goalNotifications") private var goalNotifications = false
    @AppStorage("dailyNotifications") private var dailyNotifications = false

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Settings")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 40)

                Toggle("Play Music in Background", isOn: $isMusicPlaying)
                    .onChange(of: isMusicPlaying) { value in
                        if value {
                            MusicPlayer.shared.startMusic()
                        } else {
                            MusicPlayer.shared.stopMusic()
                        }
                    }

                Toggle("Goal Notifications", isOn: $goalNotifications)

                Toggle("Daily Notifications", isOn: $dailyNotifications)

                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

class MusicPlayer {
    static let shared = MusicPlayer()
    private var player: AVPlayer?

    private init() {
        guard let url = URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3") else { return }
        player = AVPlayer(url: url)
    }

    func startMusic() {
        player?.play()
    }

    func stopMusic() {
        player?.pause()
    }
}
