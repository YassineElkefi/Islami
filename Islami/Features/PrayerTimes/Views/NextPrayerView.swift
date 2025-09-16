//
//  NextPrayerView.swift
//  Islami
//
//  Created by Yassine EL KEFI on 16/9/2025.
//

import SwiftUI

struct NextPrayerView: View {
    let nextPrayer: Prayer
    let timeUntilNext: String
    let nextPrayerTime: String
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Next Prayer")
                .font(.headline)
                .foregroundColor(.secondary)
            
            HStack(spacing: 20) {
                Image(systemName: nextPrayer.iconName)
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(nextPrayer.displayName)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text(formatTime(nextPrayerTime))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Time left")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(timeUntilNext)
                        .font(.title3)
                        .fontWeight(.medium)
                        .monospacedDigit()
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [Color.blue.opacity(0.1), Color.blue.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.blue.opacity(0.2), lineWidth: 1)
        )
    }
    
    private func formatTime(_ time: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        if let date = formatter.date(from: time) {
            formatter.dateFormat = "h:mm a"
            return formatter.string(from: date)
        }
        return time
    }
}

struct NextPrayerView_Previews: PreviewProvider {
    static var previews: some View {
        NextPrayerView(
            nextPrayer: .fajr,
            timeUntilNext: "02:45:30",
            nextPrayerTime: "05:30"
        )
        .padding()
    }
}
