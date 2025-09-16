//
//  PrayerCalculationService.swift
//  Islami
//
//  Created by Yassine EL KEFI on 16/9/2025.
//

import Foundation

class PrayerCalculationService{
    static let shared = PrayerCalculationService()
    
    private init(){}
    
    func getNextPrayer(from timings: PrayerTimings) -> (prayer: Prayer, time: String)?{
        let now = Date()
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let prayerTimes: [(Prayer, String)] = [
            (.fajr, timings.fajr),
            (.dhuhr, timings.dhuhr),
            (.asr, timings.asr),
            (.maghrib, timings.maghrib),
            (.isha, timings.isha)
        ]
        
        for (prayer, timeString) in prayerTimes{
            let cleanTime = timeString.components(separatedBy: " ").first ?? timeString
            
            if let prayerTime = formatter.date(from: cleanTime){
                let prayerDateTime = calendar.date(bySettingHour: calendar.component(.hour, from: prayerTime), minute: calendar.component(.minute, from: prayerTime), second: 0, of: now)!
                
                if prayerDateTime > now{
                    return (prayer, cleanTime)
                }
            }
        }
        // If no prayer left today, return Fajr of tomorrow
        return (.fajr, timings.fajr)
    }
    
    func timeUntilNextPrayer(nextPrayerTime: String) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        guard let prayerTime = formatter.date(from: nextPrayerTime) else {
            return "00:00:00"
        }
        let now = Date()
        let calendar = Calendar.current
        
        let prayerDateTime = calendar.date(bySettingHour: calendar.component(.hour, from: prayerTime),
                                           minute: calendar.component(.minute, from: prayerTime),
                                           second: 0, of: now)!
        
        let timeInterval = prayerDateTime.timeIntervalSince(now)
        
        if timeInterval < 0 {
            // Next Prayer is tomorrow
            let tomorrowPrayer = calendar.date(byAdding: .day, value: 1, to: prayerDateTime)!
            let tomorrowInterval = tomorrowPrayer.timeIntervalSince(now)
            return formatTimeInterval(tomorrowInterval)
        }
        return formatTimeInterval(timeInterval)
    }
    private func formatTimeInterval(_ interval: TimeInterval) -> String{
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        let seconds = Int(interval) % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
