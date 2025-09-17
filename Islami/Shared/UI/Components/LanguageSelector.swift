import SwiftUI

struct LanguageSelector: View {
    @StateObject private var localizationManager = LocalizationManager.shared
    
    var body: some View {
        Menu {
            ForEach(LocalizationManager.Language.allCases, id: \.self) { language in
                Button {
                    withAnimation {
                        localizationManager.setLanguage(language)
                    }
                } label: {
                    HStack {
                        Text(language.flag)
                        Text(language.displayName)
                        if language == localizationManager.currentLanguage {
                            Spacer()
                            Image(systemName: "checkmark")
                                .foregroundStyle(.blue)
                        }
                    }
                }
            }
        } label: {
            HStack(spacing: 4) {
                Text(localizationManager.currentLanguage.flag)
                    .font(.title2)
                Text(localizationManager.currentLanguage.displayName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .menuOrder(.fixed)
    }
}
