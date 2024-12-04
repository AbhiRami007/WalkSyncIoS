import SwiftUI
import SwiftData
import CoreMotion

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Activity.date, order: .reverse) private var activities: [Activity]

    @State private var steps: Int = 0
    @State private var walkingDistance: Double = 0.0
    @State private var speed: Double = 0.0
    @State private var averageSpeed: Double = 0.0
    @State private var isTracking: Bool = false
    @State private var startTime: Date? = nil

    private let pedometer = CMPedometer()
    private let motionActivityManager = CMMotionActivityManager()

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Dashboard")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                
                Text("Your activity...")
                    .font(.subheadline)
                    .padding(.bottom, 20)
                
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
                
                HStack {
                    VStack {
                        Image(systemName: "figure.walk")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .foregroundColor(.orange)
                        Text(String(format: "%.2f km", walkingDistance))
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Walking Distance")
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
                
                HStack {
                    VStack {
                        Image(systemName: "speedometer")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .foregroundColor(.orange)
                        Text(String(format: "%.2f km/hr", averageSpeed))
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Avg. Speed")
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
                
                Button(action: {
                    // Generate notification when the button is clicked
                    NotificationGenerator.generateNotification(
                        title: isTracking ? "Started Tracking" : "Stopped Tracking",
                        description: isTracking ? "Your Activity is being monitored" : "Activity Monitoring stopped"
                    )
                    
                    // Toggle tracking state
                    toggleTracking()
                }) {
                    Text(isTracking ? "Stop Tracking" : "Start Tracking")  // The button label
                }

                .frame(maxWidth: .infinity)
                .padding()
                .background(isTracking ? Color.red : Color.orange)
                .foregroundColor(.white)
                .cornerRadius(20)
                .padding(.top, 20)
                
                
                NavigationLink(destination: ActivityLogView()) {
                    HStack {
                        Image(systemName: "shoeprints.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 28, height: 28)
                            .foregroundColor(.blue)
                        Text("View Activity Log")
                            .padding(.leading, 4)
                    }
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
        .onAppear {
            Task {
                await NotificationGenerator.requestAuthorization()
            }
        }
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

        startTime = Date()

        pedometer.startUpdates(from: Date()) { data, error in
            guard let data = data, error == nil else {
                print("Pedometer error: \(String(describing: error))")
                return
            }

            DispatchQueue.main.async {
                self.steps = data.numberOfSteps.intValue
                if let distance = data.distance {
                    self.walkingDistance = distance.doubleValue / 1000.0
                }
                if let currentPace = data.currentPace {
                    self.speed = 3.6 / currentPace.doubleValue
                }
                if let currentDistance = data.distance?.doubleValue, currentDistance > 0,
                   let startTime = startTime {
                    let duration = Date().timeIntervalSince(startTime)
                    let totalHours = duration / 3600
                    if totalHours > 0 {
                        self.averageSpeed = currentDistance / 1000.0 / totalHours
                    }
                }
            }
        }
    }

    private func stopTracking() {
        pedometer.stopUpdates()

        guard let startTime = startTime else { return }
        let duration = Date().timeIntervalSince(startTime)

        let newActivity = Activity(
            date: Date(),
            steps: steps,
            walkingDistance: walkingDistance,
            speed: averageSpeed
        )
        modelContext.insert(newActivity)
        try? modelContext.save()

        self.startTime = nil
    }
}

struct DashboardContentView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
