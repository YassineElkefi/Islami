//
//  Prayer.swift
//  Islami
//
//  Created by Yassine EL KEFI on 16/9/2025.
//

import Foundation

enum Prayer:String, CaseIterable{
    case fajr = "Fajr"
    case dhuhr = "Dhuhr"
    case asr = "Asr"
    case maghrib = "Maghrib"
    case isha = "Isha"
    
    var displayName: String {
        return self.rawValue
    }
    
    var iconName: String {
        switch self {
        case .fajr:
            return "sunrise.fill"
        case .dhuhr:
            return "sun.max.fill"
        case .asr:
            return "sun.dust.fill"
        case .maghrib:
            return "sunset.fill"
        case .isha:
            return "moon.stars.fill"
        }
    }
}
