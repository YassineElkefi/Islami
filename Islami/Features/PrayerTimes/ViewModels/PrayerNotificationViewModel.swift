//
//  PrayerNotificationViewModel.swift
//  Islami
//
//  Created by Yassine EL KEFI on 16/9/2025.
//

import Foundation
import UserNotifications
import Combine

@MainActor
class PrayerNotificationViewModel: ObservableObject {
    @Published var isNotificationEnabled = false
    @Published var notificationStatus: String = "Checking..."
    
    private let notificationService = NotificationService.shared
    
    init() {
        checkNotificationStatus()
    }
    
    func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .authorized:
                    self.isNotificationEnabled = true
                    self.notificationStatus = "Notifications enabled"
                case .denied:
                    self.isNotificationEnabled = false
                    self.notificationStatus = "Notifications denied"
                case .notDetermined:
                    self.isNotificationEnabled = false
                    self.notificationStatus = "Notifications not requested"
                case .provisional:
                    self.isNotificationEnabled = true
                    self.notificationStatus = "Provisional notifications"
                case .ephemeral:
                    self.isNotificationEnabled = false
                    self.notificationStatus = "Ephemeral notifications"
                @unknown default:
                    self.isNotificationEnabled = false
                    self.notificationStatus = "Unknown status"
                }
            }
        }
    }
    
    func requestNotificationPermission() {
        Task {
            let granted = await notificationService.requestPermission()
            isNotificationEnabled = granted
            notificationStatus = granted ? "Notifications enabled" : "Notifications denied"
        }
    }
    
    func schedulePrayerNotifications(timings: PrayerTimings) {
        guard isNotificationEnabled else { return }
        
        Task {
            await notificationService.schedulePrayerNotifications(timings: timings)
        }
    }
}
