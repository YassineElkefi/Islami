//
//  NotificationService.swift
//  Islami
//
//  Created by Yassine EL KEFI on 16/9/2025.
//

import Foundation
import UserNotifications

class NotificationService{
    static let shared = NotificationService()
    
    private init() {}
    
    func requestPermission() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            print("Error requesting notification permission: \(error)")
            return false
        }
    }
    
    func schedulePrayerNotifications(timings: PrayerTimings) async {
        let center = UNUserNotificationCenter.current()
        
        // Remove existing notifications
        center.removeAllPendingNotificationRequests()
        
        let prayers: [(Prayer, String)] = [
            (.fajr, timings.fajr),
            (.dhuhr, timings.dhuhr),
            (.asr, timings.asr),
            (.maghrib, timings.maghrib),
            (.isha, timings.isha)
        ]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        for (prayer, timeString) in prayers {
            let cleanTime = timeString.components(separatedBy: " ").first ?? timeString
            guard let time = formatter.date(from: cleanTime) else { continue }
            
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: time)
            let minute = calendar.component(.minute, from: time)
            
            let content = UNMutableNotificationContent()
            content.title = "Prayer Time"
            content.body = "It's time for \(prayer.displayName) prayer"
            content.sound = UNNotificationSound(named: UNNotificationSoundName("azan.mp3"))
            
            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = minute
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: prayer.rawValue, content: content, trigger: trigger)
            
            do {
                try await center.add(request)
            } catch {
                print("Error scheduling notification for \(prayer.rawValue): \(error)")
            }
        }
    }
}
