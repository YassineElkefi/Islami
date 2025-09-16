//
//  CalculationMethod.swift
//  Islami
//
//  Created by Yassine EL KEFI on 16/9/2025.
//

import Foundation

enum CalculationMethod: Int, CaseIterable{
    case worldIslamicLeague = 3
    case egyptianGeneralAuthority = 5
    case universityOfIslamicSciencesKarachi = 1
    case ummAlQuraUniversityMakkah = 4
    case muslimWorldLeague = 2
    
    var name: String{
        switch self{
        case .worldIslamicLeague:
            return "World Islamic League"
        case .egyptianGeneralAuthority:
            return "Egyptian General Authority"
        case .universityOfIslamicSciencesKarachi:
            return "University of Islamic Sciences, Karachi"
        case .ummAlQuraUniversityMakkah:
            return "Umm Al-Qura University, Makkah"
        case .muslimWorldLeague:
            return "Muslim World League"
        }
    }
    var description: String{
        switch self{
        case .worldIslamicLeague:
            return "Fajr: 18°, Isha: 17°"
        case .egyptianGeneralAuthority:
            return "Fajr: 19.5°, Isha: 17.5°"
        case .universityOfIslamicSciencesKarachi:
            return "Fajr: 18°, Isha: 18°"
        case .ummAlQuraUniversityMakkah:
            return "Fajr: 18.5°, Isha: 90 min"
        case .muslimWorldLeague:
            return "Fajr: 18°, Isha: 17°"
        }
    }
}
