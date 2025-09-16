//
//  PrayerTime.swift
//  Islami
//
//  Created by Yassine EL KEFI on 16/9/2025.
//

import Foundation

struct PrayerTime: Codable, Identifiable {
    let id = UUID()
    let prayer: String
    let time: String
    
    var prayerType: Prayer? {
        Prayer(rawValue: prayer)
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        if let date = formatter.date(from: time){
            formatter.dateFormat = "h:mm a"
            return formatter.string(from: date)
    }
        return time
    }
}

struct PrayerTimesResponse: Codable {
    let data: PrayerData
}

struct PrayerData: Codable {
    let timings: PrayerTimings
    let date: PrayerDate
}

struct PrayerTimings: Codable {
    let fajr: String
    let dhuhr: String
    let asr: String
    let maghrib: String
    let isha: String
    
    enum CodingKeys: String, CodingKey {
        case fajr = "Fajr"
        case dhuhr = "Dhuhr"
        case asr = "Asr"
        case maghrib = "Maghrib"
        case isha = "Isha"
    }
}

struct PrayerDate: Codable {
    let readable: String
    let hijri: HijriDate
}

struct HijriDate: Codable {
    let date: String
    let month: HijriMonth
}

struct HijriMonth: Codable {
    let en: String
}
