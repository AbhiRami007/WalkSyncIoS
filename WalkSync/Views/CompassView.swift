//
//  CompassView.swift
//  WalkSync
//
//

import SwiftUI
import CoreLocation

struct CompassView: View {
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Compass")
                .font(.largeTitle)
                .bold()
            
            // Compass Heading with Direction
            Text("\(Int(locationManager.heading))° \(locationManager.cardinalDirection)")
                .font(.system(size: 48, weight: .bold))
                .padding()
            
            // Latitude and Longitude in DMS Format
            VStack {
                Text("Latitude: \(convertToDMS(locationManager.latitude, isLatitude: true))")
                Text("Longitude: \(convertToDMS(locationManager.longitude, isLatitude: false))")
            }
            .font(.title2)
            
            Spacer()
        }
        .padding()
        .onAppear {
            locationManager.startUpdating()
        }
        .onDisappear {
            locationManager.stopUpdating()
        }
    }
    
    /// Converts decimal coordinates to DMS format
    func convertToDMS(_ decimal: Double, isLatitude: Bool) -> String {
        let degrees = Int(decimal)
        let minutesDecimal = abs(decimal - Double(degrees)) * 60
        let minutes = Int(minutesDecimal)
        let seconds = Int((minutesDecimal - Double(minutes)) * 60)
        
        let direction = isLatitude
            ? (decimal >= 0 ? "N" : "S")
            : (decimal >= 0 ? "E" : "W")
        
        return "\(abs(degrees))° \(minutes)′ \(seconds)″ \(direction)"
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    
    @Published var latitude: Double = 0.0
    @Published var longitude: Double = 0.0
    @Published var heading: Double = 0.0
    @Published var cardinalDirection: String = "N"
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    func startUpdating() {
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    func stopUpdating() {
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
    }
    
    // CLLocationManagerDelegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let headingValue = newHeading.trueHeading > 0 ? newHeading.trueHeading : newHeading.magneticHeading
        heading = headingValue
        cardinalDirection = getCardinalDirection(from: headingValue)
    }
    
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }
    
    private func getCardinalDirection(from heading: Double) -> String {
        switch heading {
        case 0..<22.5, 337.5...360:
            return "N"
        case 22.5..<67.5:
            return "NE"
        case 67.5..<112.5:
            return "E"
        case 112.5..<157.5:
            return "SE"
        case 157.5..<202.5:
            return "S"
        case 202.5..<247.5:
            return "SW"
        case 247.5..<292.5:
            return "W"
        case 292.5..<337.5:
            return "NW"
        default:
            return "N"
        }
    }
}

#Preview {
    CompassView()
}
