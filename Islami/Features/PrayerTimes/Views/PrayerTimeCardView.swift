//
//  PrayerTimeCardView.swift
//  Islami
//
//  Created by Yassine EL KEFI on 16/9/2025.
//

import SwiftUI

struct PrayerTimeCardView: View {
    let prayer: Prayer
    let time: String
    let isNext: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: prayer.iconName)
                .font(.system(size: 30))
                .foregroundColor(isNext ? .white : .blue)
            
            Text(prayer.displayName)
                .font(.headline)
                .foregroundColor(isNext ? .white : .primary)
            
            Text(formatTime(time))
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(isNext ? .white.opacity(0.9) : .secondary)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 120)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isNext ? Color.blue : Color(.systemGray6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isNext ? Color.blue.opacity(0.3) : Color.clear, lineWidth: 2)
        )
        .scaleEffect(isNext ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.3), value: isNext)
    }
    
    private func formatTime(_ time: String) -> String {
        let cleanTime = time.components(separatedBy: " ").first ?? time
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        if let date = formatter.date(from: cleanTime) {
            formatter.dateFormat = "h:mm a"
            return formatter.string(from: date)
        }
        return cleanTime
    }
}

struct PrayerTimeCardView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            PrayerTimeCardView(prayer: .fajr, time: "05:30", isNext: true)
            PrayerTimeCardView(prayer: .dhuhr, time: "12:15", isNext: false)
        }
        .padding()
    }
}
