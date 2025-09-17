//
//  NextPrayerView.swift
//  Islami
//
//  Created by Yassine EL KEFI on 16/9/2025.
//

import SwiftUI

import SwiftUI

struct NextPrayerView: View {
    let nextPrayer: Prayer
    let timeUntilNext: String
    let nextPrayerTime: String
    let isLoading: Bool

    @State private var pulseAnimation = false
    @State private var fadeIn = false
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(spacing: 16) {
            // Simplified header
            HStack {
                Text("Next Prayer")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)

                Spacer()

                // Simplified pulse indicator
                Circle()
                    .fill(.blue)
                    .frame(width: 8, height: 8)
                    .opacity(pulseAnimation ? 0.3 : 1.0)
            }

            if isLoading || timeUntilNext == "00:00:00" {
                loadingView
            } else {
                prayerInfoView
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(simplifiedBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.blue.opacity(0.1), lineWidth: 1)
        )
        .opacity(fadeIn ? 1.0 : 0.0)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5)) {
                fadeIn = true
            }
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                pulseAnimation = true
            }
        }
    }

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
                .tint(.blue)

            Text("Loading prayer times...")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
        }
        .frame(height: 120)
    }

    private var prayerInfoView: some View {
        HStack(spacing: 24) {
            // Simplified prayer icon
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 70, height: 70)
                    .shadow(color: Color.blue.opacity(0.2), radius: 4, x: 0, y: 2)

                Image(systemName: nextPrayer.iconName)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(.blue)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(nextPrayer.displayName)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                Text(formatTime(nextPrayerTime))
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 6) {
                Text("Time left")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)

                Text(timeUntilNext)
                    .font(.caption)
                    .fontWeight(.bold)
                    .monospacedDigit()
                    .foregroundColor(.blue)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                    )
            }
        }
    }

    private var simplifiedBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(
                colorScheme == .dark ?
                Color(.systemGray6) :
                Color(.systemBackground)
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
        VStack(spacing: 20) {
            NextPrayerView(
                nextPrayer: .maghrib,
                timeUntilNext: "02:45:30",
                nextPrayerTime: "05:30",
                isLoading: false
            )
            
            NextPrayerView(
                nextPrayer: .fajr,
                timeUntilNext: "00:00:00",
                nextPrayerTime: "",
                isLoading: true
            )
        }
        .padding()
    }
}
