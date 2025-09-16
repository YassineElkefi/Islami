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
    
    @State private var isAnimating = false
    @State private var pulseEffect = false
    
    var body: some View {
        VStack(spacing: 12) {
            // Prayer Icon with animated glow effect
            ZStack {
                Circle()
                    .fill(gradientBackground)
                    .frame(width: 50, height: 50)
                    .shadow(
                        color: isNext ? Color.blue.opacity(0.4) : Color.gray.opacity(0.2),
                        radius: pulseEffect ? 15 : 8
                    )
                    .scaleEffect(pulseEffect ? 1.1 : 1.0)
                
                Image(systemName: prayer.iconName)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: isNext ? [.white, .blue.opacity(0.8)] : [.primary, .secondary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .rotationEffect(.degrees(isAnimating ? 5 : -5))
            }
            
            // Prayer Name
            Text(prayer.displayName)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: isNext ? [.blue, .indigo] : [.primary, .secondary],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .scaleEffect(isNext ? 1.1 : 1.0)
            
            // Time with stylized format
            Text(formattedTime)
                .font(.system(size: 15, weight: .medium, design: .monospaced))
                .foregroundColor(isNext ? .blue : .secondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(isNext ? Color.blue.opacity(0.1) : Color.gray.opacity(0.05))
                        .stroke(
                            isNext ? Color.blue.opacity(0.3) : Color.gray.opacity(0.2),
                            lineWidth: 1
                        )
                )
            
            // Next prayer indicator
            if isNext {
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 6, height: 6)
                        .scaleEffect(pulseEffect ? 1.3 : 1.0)
                    
                    Text("Next")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 140)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(cardBackground)
                .shadow(
                    color: isNext ? Color.blue.opacity(0.15) : Color.black.opacity(0.05),
                    radius: isNext ? 12 : 6,
                    x: 0,
                    y: isNext ? 8 : 3
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(
                        colors: isNext
                            ? [Color.blue.opacity(0.4), Color.indigo.opacity(0.2)]
                            : [Color.gray.opacity(0.1), Color.gray.opacity(0.05)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: isNext ? 2 : 1
                )
        )
        .scaleEffect(isNext ? 1.02 : 1.0)
        .onAppear {
            startAnimations()
        }
        .onChange(of: isNext) { _ in
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                if isNext {
                    startPulseAnimation()
                }
            }
        }
    }
    
    private var gradientBackground: LinearGradient {
        if isNext {
            return LinearGradient(
                colors: [Color.blue.opacity(0.8), Color.indigo.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            return LinearGradient(
                colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var cardBackground: LinearGradient {
        if isNext {
            return LinearGradient(
                colors: [
                    Color.blue.opacity(0.05),
                    Color.indigo.opacity(0.02),
                    Color.white
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            return LinearGradient(
                colors: [
                    Color.white,
                    Color.gray.opacity(0.02)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
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
    
    private func startAnimations() {
        // Subtle continuous animation for icon
        withAnimation(
            .easeInOut(duration: 3.0)
            .repeatForever(autoreverses: true)
        ) {
            isAnimating = true
        }
        
        // Pulse effect for next prayer
        if isNext {
            startPulseAnimation()
        }
    }
    
    private func startPulseAnimation() {
        withAnimation(
            .easeInOut(duration: 1.5)
            .repeatForever(autoreverses: true)
        ) {
            pulseEffect = true
        }
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
