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

    @State private var cardOpacity = 0.0
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(spacing: 12) {
            // Simplified prayer icon
            ZStack {
                Circle()
                    .fill(isNext ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                    .frame(width: 50, height: 50)
                    .shadow(
                        color: isNext ? Color.blue.opacity(0.3) : Color.gray.opacity(0.2),
                        radius: 4,
                        x: 0,
                        y: 2
                    )

                Image(systemName: prayer.iconName)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(isNext ? .blue : .primary)
            }

            Text(prayer.displayName)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(isNext ? .blue : .primary)

            Text(formattedTime)
                .font(.system(size: 15, weight: .medium, design: .monospaced))
                .foregroundColor(isNext ? .blue : .secondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isNext ? Color.blue.opacity(0.1) : Color.gray.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    isNext ? Color.blue.opacity(0.3) : Color.gray.opacity(0.2),
                                    lineWidth: 1
                                )
                        )
                )

            if isNext {
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 6, height: 6)

                    Text("Next")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 140)
        .padding(.vertical, 16)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(
            color: Color.black.opacity(0.06),
            radius: isNext ? 8 : 4,
            x: 0,
            y: isNext ? 4 : 2
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    isNext ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1),
                    lineWidth: 1
                )
        )
        .opacity(cardOpacity)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6)) {
                cardOpacity = 1.0
            }
        }
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(
                isNext ?
                Color.blue.opacity(0.05) :
                (colorScheme == .dark ? Color(.systemGray6) : Color.white)
            )
    }

    private var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        let cleanTime = time.components(separatedBy: " ").first ?? time

        if let date = formatter.date(from: cleanTime) {
            formatter.dateFormat = "h:mm a"
            return formatter.string(from: date)
        }
        return cleanTime
    }
}

struct PrayerTimeCardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                PrayerTimeCardView(prayer: .fajr, time: "05:30", isNext: true)
                PrayerTimeCardView(prayer: .dhuhr, time: "12:45", isNext: false)
                PrayerTimeCardView(prayer: .asr, time: "16:20", isNext: false)
                PrayerTimeCardView(prayer: .maghrib, time: "19:10", isNext: false)
                PrayerTimeCardView(prayer: .isha, time: "20:45", isNext: false)
            }
            .padding()
        }
        .background(Color.gray.opacity(0.1))
    }
}
