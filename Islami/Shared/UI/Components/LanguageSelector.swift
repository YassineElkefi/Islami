//
//  LanguageSelector.swift
//  Islami
//
//  Created by Yassine EL KEFI on 17/9/2025.
//
import SwiftUI

struct LanguageSelector: View {
    @ObservedObject private var localizationManager = LocalizationManager.shared
    @State private var isShowingMenu = false
    
    var body: some View {
        Menu {
            ForEach(LocalizationManager.Language.allCases, id: \.self) { language in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        localizationManager.setLanguage(language)
                    }
                }) {
                    HStack {
                        Text(language.flag)
                        Text(language.displayName)
                        Spacer()
                        if language == localizationManager.currentLanguage {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
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
                    .foregroundColor(.secondary)
            }
        }
        .environment(\.layoutDirection, localizationManager.currentLanguage.isRTL ? .rightToLeft : .leftToRight)
    }
}

struct LanguageSelector_Previews: PreviewProvider {
    static var previews: some View {
        LanguageSelector()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
