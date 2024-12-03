//
//  ActivityLogView.swift
//  WalkSync
//
//

import SwiftUI
import SwiftData

struct ActivityLogView: View {
    @Query(sort: \Activity.date, order: .reverse) private var activities: [Activity]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(activities) { activity in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Steps")
                                .foregroundColor(.gray)
                            Spacer()
                            Text("\(activity.steps)")
                                .fontWeight(.bold)
                        }
                        HStack {
                            Text("Walking Average")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(String(format: "%.2f km", activity.walkingDistance))
                                .fontWeight(.bold)
                        }
                        HStack {
                            Text("Avg. Speed")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(String(format: "%.2f km/hr", activity.speed))
                                .fontWeight(.bold)
                        }
                        Text(activity.date, style: .time)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top, 4)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                }
            }
            .padding()
        }
        .navigationTitle("Activity Log")
    }
}



#Preview {
    ActivityLogView()
}
