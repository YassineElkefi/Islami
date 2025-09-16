//
//  PrayerTimesService.swift
//  Islami
//
//  Created by Yassine EL KEFI on 16/9/2025.
//

import Foundation
import CoreLocation

class PrayerTimesService{
    static let shared = PrayerTimesService()
    private let baseUrl = "https://api.aladhan.com/v1"
    
    private init() {}
    
    func fetchPrayerTimes(latitude: Double, longitude: Double, method: CalculationMethod = .worldIslamicLeague) async throws -> PrayerTimesResponse {
        let urlString = "\(baseUrl)/timings?latitude=\(latitude)&longitude=\(longitude)&method=\(method.rawValue)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(PrayerTimesResponse.self, from: data)
    }
    
    func fetchPrayerTimesForDate(latitude: Double, longitude: Double, date: Date, method: CalculationMethod = .worldIslamicLeague) async throws -> PrayerTimesResponse {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let dateString = formatter.string(from: date)
        
        let urlString = "\(baseUrl)/timings/\(dateString)?latitude=\(latitude)&longitude=\(longitude)&method=\(method.rawValue)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(PrayerTimesResponse.self, from: data)
    }
}
