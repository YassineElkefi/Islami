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
    let isLoading: Bool
    
    @State private var pulseAnimation = false
    @State private var fadeIn = false
    
    var body: some View {
        VStack(spacing: 16) {
            // Animated header with gradient text
            HStack {
                Text("Next Prayer")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Spacer()
                
                // Animated pulse indicator
                Circle()
                    .fill(.blue)
                    .frame(width: 8, height: 8)
                    .scaleEffect(pulseAnimation ? 1.5 : 1.0)
                    .opacity(pulseAnimation ? 0.3 : 1.0)
                    .animation(.easeInOut(duration: 1.0).repeatForever(), value: pulseAnimation)
            }
            
            // Show loading if no prayer times are available yet or explicitly loading
                    if isLoading || timeUntilNext == "00:00:00" {
                        loadingView
                    } else {
                        prayerInfoView
                    }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(backgroundView)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(borderOverlay)
        .opacity(fadeIn ? 1.0 : 0.0)
        .offset(y: fadeIn ? 0 : 20)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                fadeIn = true
            }
            pulseAnimation = true
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            // Animated loading spinner with gradient
            ZStack {
                Circle()
                    .stroke(Color.blue.opacity(0.2), lineWidth: 4)
                    .frame(width: 50, height: 50)
                
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(
                        LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing),
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(pulseAnimation ? 360 : 0))
                    .animation(.linear(duration: 1.0).repeatForever(autoreverses: false), value: pulseAnimation)
            }
            
            Text("Loading prayer times...")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .opacity(pulseAnimation ? 0.6 : 1.0)
                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: pulseAnimation)
        }
        .frame(height: 120)
    }
    
    private var prayerInfoView: some View {
        HStack(spacing: 24) {
            // Prayer icon with animated background
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue.opacity(0.2), .purple.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 70, height: 70)
                    .scaleEffect(pulseAnimation ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: pulseAnimation)
                
                Image(systemName: nextPrayer.iconName)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            // Prayer details
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
            
            // Countdown with animated background
            VStack(alignment: .trailing, spacing: 6) {
                Text("Time left")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [.blue.opacity(0.1), .purple.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 35)
                    
                    Text(timeUntilNext)
                        .font(.title3)
                        .fontWeight(.bold)
                        .monospacedDigit()
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }
                .scaleEffect(pulseAnimation ? 1.02 : 1.0)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulseAnimation)
            }
        }
    }
    
    private var backgroundView: some View {
        ZStack {
            // Main gradient background
            LinearGradient(
                colors: [
                    Color.blue.opacity(0.1),
                    Color.purple.opacity(0.05),
                    Color.blue.opacity(0.08)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Animated light overlay
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    RadialGradient(
                        colors: [.white.opacity(0.1), .clear],
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: 200
                    )
                )
                .opacity(pulseAnimation ? 0.5 : 0.3)
                .animation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true), value: pulseAnimation)
        }
    }
    
    private var borderOverlay: some View {
        RoundedRectangle(cornerRadius: 20)
            .stroke(
                LinearGradient(
                    colors: [.blue.opacity(0.3), .purple.opacity(0.2), .blue.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 1.5
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
