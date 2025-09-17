import Foundation
import SwiftUI
import Combine

final class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @Published var currentLanguage: Language = .english {
        didSet {
            saveLanguage()
        }
    }
    
    enum Language: String, CaseIterable {
        case english = "en"
        case arabic = "ar"
        case french = "fr"
        case spanish = "es"
        
        var displayName: String {
            switch self {
            case .english: return "English"
            case .arabic: return "العربية"
            case .french: return "Français"
            case .spanish: return "Español"
            }
        }
        
        var flag: String {
            switch self {
            case .english: return "🇺🇸"
            case .arabic: return "🇸🇦"
            case .french: return "🇫🇷"
            case .spanish: return "🇪🇸"
            }
        }
        
        var isRTL: Bool {
            self == .arabic
        }
    }
    
    private init() {
        loadSavedLanguage()
    }
    
    func setLanguage(_ language: Language) {
        guard language != currentLanguage else { return }
        currentLanguage = language
    }
    
    private func saveLanguage() {
        UserDefaults.standard.set(currentLanguage.rawValue, forKey: "AppLanguage")
    }
    
    private func loadSavedLanguage() {
        if let saved = UserDefaults.standard.string(forKey: "AppLanguage"),
           let language = Language(rawValue: saved) {
            currentLanguage = language
        }
    }
}
