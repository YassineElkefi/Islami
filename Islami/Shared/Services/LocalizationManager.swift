//
//  LocalizationManager.swift
//  Islami
//
//  Created by Yassine EL KEFI on 17/9/2025.
//

import Foundation
import SwiftUI
import Combine

class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @Published var currentLanguage: Language = .english {
        didSet {
            saveLanguage()
            objectWillChange.send()
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
            return self == .arabic
        }
    }
    
    private init() {
        loadSavedLanguage()
    }
    
    func setLanguage(_ language: Language) {
        currentLanguage = language
        updateRTLLayout()
    }
    
    private func updateRTLLayout() {
        DispatchQueue.main.async {
            let semanticAttribute: UISemanticContentAttribute = self.currentLanguage.isRTL ? .forceRightToLeft : .forceLeftToRight
            UIView.appearance().semanticContentAttribute = semanticAttribute
            
            // Force immediate layout update
            for scene in UIApplication.shared.connectedScenes {
                if let windowScene = scene as? UIWindowScene {
                    for window in windowScene.windows {
                        self.updateViewHierarchy(window.rootViewController?.view)
                    }
                }
            }
        }
    }
    
    private func updateViewHierarchy(_ view: UIView?) {
        guard let view = view else { return }
        view.semanticContentAttribute = currentLanguage.isRTL ? .forceRightToLeft : .forceLeftToRight
        for subview in view.subviews {
            updateViewHierarchy(subview)
        }
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    private func saveLanguage() {
        UserDefaults.standard.set(currentLanguage.rawValue, forKey: "AppLanguage")
        UserDefaults.standard.synchronize()
    }
    
    private func loadSavedLanguage() {
        if let savedLanguage = UserDefaults.standard.string(forKey: "AppLanguage"),
           let language = Language(rawValue: savedLanguage) {
            currentLanguage = language
        }
    }
}
