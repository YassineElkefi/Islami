import SwiftUI

@main
struct IslamiApp: App {
    @StateObject private var localizationManager = LocalizationManager.shared

    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .environmentObject(localizationManager)
                .environment(\.locale, Locale(identifier: localizationManager.currentLanguage.rawValue))
        }
    }
}
