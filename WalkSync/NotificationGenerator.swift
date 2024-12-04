import Foundation
import UserNotifications

class NotificationGenerator {
    static func generateNotification(title: String, description: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = description
        content.sound = .default

        // Trigger notification after 15 seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)

        let notificationCenter = UNUserNotificationCenter.current()

        notificationCenter.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                // Only add the notification if permissions are granted
                do {
                    try notificationCenter.add(request)
                    print("Notification scheduled successfully!")
                } catch {
                    print("Error showing notification: \(error)")
                }
            } else {
                print("Notification permission is not granted.")
            }
        }
    }

    static func requestAuthorization() async {
        let center = UNUserNotificationCenter.current()
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            if granted {
                print("Access Permission granted!")
            } else {
                print("Permission denied!")
            }
        } catch {
            print("Authorization request error: \(error)")
        }
    }
}
