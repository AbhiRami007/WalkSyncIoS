import SwiftUI
import CoreMotion

struct DashboardView: View {
    @State private var steps: Int = 0
    @State private var walkingDistance: Double = 0.0 // in km
    @State private var speed: Double = 0.0 // in km/hr
    @State private var isTracking: Bool = false

    private let pedometer = CMPedometer()
    private let motionActivityManager = CMMotionActivityManager()

    var body: some View {
        VStack(alignment: .leading) {
            Text("Dashboard")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 10)

            Text("Your activity...")
                .font(.subheadline)
                .padding(.bottom, 20)

            // Step card
            HStack {
                VStack {
                    Image(systemName: "shoeprints.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .foregroundColor(.orange)
                    Text("\(steps)")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Steps")
                        .font(.caption)
                }
                .padding()

                Spacer()
            }
            .background(Color.brown.opacity(0.08))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.gray, lineWidth: 0.5)
            )

            // Walking and Running Cards
            HStack(spacing: 16) {
                VStack {
                    Image(systemName: "figure.walk")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .foregroundColor(.orange)
                    Text(String(format: "%.2f km", walkingDistance))
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Walking")
                        .font(.caption)
                }
                Spacer()

            }
            .padding()
            .background(Color.brown.opacity(0.08))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.gray, lineWidth: 0.5)
            )
            .padding(.top, 10)
            .padding(.bottom, 10)
            HStack {
                VStack {
                    Image(systemName: "figure.run")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .foregroundColor(.orange)
                    Text("\(String(format: "%.2f km/hr", speed))")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Speed")
                        .font(.caption)
                }
                .padding()

                Spacer()
            }
            .background(Color.brown.opacity(0.08))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.gray, lineWidth: 0.5)
            )
            // Start/Stop Tracking button
            Button(isTracking ? "Stop Tracking" : "Start Tracking") {
                toggleTracking()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isTracking ? Color.red : Color.orange)
            .foregroundColor(.white)
            .cornerRadius(20)
            .padding(.top, 20)
            Button("View Activity Log") {
                toggleTracking()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray.opacity(0.25))
            .foregroundColor(.black)
            .cornerRadius(20)
            .padding(.top, 20)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }

    private func toggleTracking() {
        if isTracking {
            stopTracking()
        } else {
            startTracking()
        }
        isTracking.toggle()
    }

    private func startTracking() {
        guard CMPedometer.isStepCountingAvailable() else {
            print("Step counting not available")
            return
        }

        pedometer.startUpdates(from: Date()) { data, error in
            guard let data = data, error == nil else {
                print("Pedometer error: \(String(describing: error))")
                return
            }

            DispatchQueue.main.async {
                self.steps = data.numberOfSteps.intValue
                if let distance = data.distance {
                    self.walkingDistance = distance.doubleValue / 1000.0 // Convert meters to kilometers
                }
                if let currentPace = data.currentPace { // Current pace in m/s
                    self.speed = 3.6 / currentPace.doubleValue // Convert pace to speed (km/hr)
                }
            }
        }

        if CMMotionActivityManager.isActivityAvailable() {
            motionActivityManager.startActivityUpdates(to: .main) { activity in
                guard let activity = activity else { return }
                // Optionally handle activity states
                if activity.running {
                    print("Running detected")
                } else if activity.walking {
                    print("Walking detected")
                } else if activity.stationary {
                    print("Stationary")
                }
            }
        }
    }

    private func stopTracking() {
        pedometer.stopUpdates()
        motionActivityManager.stopActivityUpdates()
    }
}

struct DashboardContentView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
