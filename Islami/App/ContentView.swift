//
//  ContentView.swift
//  Islami
//
//  Created by Yassine EL KEFI on 16/9/2025.
//

import SwiftUI

enum Tab {
    case qibla
    case prayer
    case quran
}

struct ContentView: View {
    @State private var selectedTab: Tab = .prayer
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Qibla Tab
            QiblaView()
            .tabItem {
                Image(systemName: "location.north.line")
                Text("Qibla")
            }
            .tag(Tab.qibla)
            
            // Prayer Tab (center)
            PrayerTimesView()
            .tabItem {
                Image(systemName: "clock")
                Text("Prayer")
            }
            .tag(Tab.prayer)
            
            // Quran Tab
            VStack {
                Image(systemName: "book")
                    .font(.system(size: 60))
                    .padding(.bottom, 8)
                Text("Quran")
                    .font(.title)
            }
            .tabItem {
                Image(systemName: "book")
                Text("Quran")
            }
            .tag(Tab.quran)
        }
        .accentColor(.indigo)
    }
}

#Preview {
    ContentView()
}
