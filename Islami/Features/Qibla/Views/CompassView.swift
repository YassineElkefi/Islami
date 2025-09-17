//
//  CompassView.swift
//  Islami
//
//  Created by Yassine EL KEFI on 16/9/2025.
//

import SwiftUI
import CoreLocation

struct CompassView: View {
    @StateObject private var compassService = CompassService()
    let qiblaDirection: QiblaDirection?
    @State private var isAligned = false
    @State private var lastAlignedState = false
    @State private var pulseAnimation = false

    private var currentHeading: Double {
        compassService.heading?.magneticHeading ?? 0
    }

    private var qiblaAngle: Double {
        guard let qiblaDirection = qiblaDirection else { return 0 }
        return qiblaDirection.bearing - currentHeading
    }
    
    private var currentQiblaDirection: Double {
        guard let qiblaDirection = qiblaDirection else { return 0 }
        let direction = qiblaDirection.bearing - currentHeading
        return direction < 0 ? direction + 360 : direction
    }
    
    private var alignmentThreshold: Double { 5.0 }
    
    private var isQiblaAligned: Bool {
        let angleDiff = abs(currentQiblaDirection)
        return angleDiff <= alignmentThreshold || angleDiff >= (360 - alignmentThreshold)
    }

    var body: some View {
        ZStack {
            // Outer glow ring for alignment
            Circle()
                .stroke(
                    LinearGradient(
                        colors: isQiblaAligned ? [.green.opacity(0.6), .green.opacity(0.2)] : [.clear],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 8
                )
                .frame(width: 280, height: 280)
                .scaleEffect(pulseAnimation && isQiblaAligned ? 1.05 : 1.0)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulseAnimation && isQiblaAligned)

            // Main compass background with gradient
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(.systemBackground),
                            Color(.systemGray6).opacity(0.3)
                        ],
                        center: .center,
                        startRadius: 50,
                        endRadius: 130
                    )
                )
                .frame(width: 260, height: 260)
                .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 5)

            // Compass border
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [Color.blue.opacity(0.6), Color.cyan.opacity(0.4)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 3
                )
                .frame(width: 260, height: 260)

            // Compass markings with enhanced styling
            ForEach(0..<360, id: \.self) { degree in
                if degree % 30 == 0 {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: degree % 90 == 0 ? [.primary, .secondary] : [.secondary],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: degree % 90 == 0 ? 3 : 2, height: degree % 90 == 0 ? 25 : 15)
                        .offset(y: -120)
                        .rotationEffect(.degrees(Double(degree) - currentHeading))
                }
            }

            // Cardinal directions with enhanced styling
            VStack {
                Text("N")
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.red, .red.opacity(0.7)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                Spacer()
                HStack {
                    Text("W")
                        .font(.system(.headline, design: .rounded, weight: .semibold))
                        .foregroundColor(.primary)
                    Spacer()
                    Text("E")
                        .font(.system(.headline, design: .rounded, weight: .semibold))
                        .foregroundColor(.primary)
                }
                Spacer()
                Text("S")
                    .font(.system(.headline, design: .rounded, weight: .semibold))
                    .foregroundColor(.primary)
            }
            .frame(width: 200, height: 200)
            .rotationEffect(.degrees(-currentHeading))

            // Qibla direction indicator with enhanced styling
            if qiblaDirection != nil {
                VStack(spacing: 4) {
                    Text("🕋")
                        .font(.system(size: 32))
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                    
                    Text("QIBLA")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(.green)
                }
                .offset(y: -95)
                .rotationEffect(.degrees(qiblaAngle))
                .scaleEffect(isQiblaAligned ? 1.2 : 1.0)
                .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isQiblaAligned)
            }

            // North indicator with dynamic styling
            VStack(spacing: 4) {
                Image(systemName: isQiblaAligned ? "checkmark.circle.fill" : "arrow.up.circle.fill")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: isQiblaAligned ? [.green, .green.opacity(0.7)] : [.red, .red.opacity(0.7)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 1)
                
                Text("NORTH")
                    .font(.system(size: 8, weight: .bold, design: .rounded))
                    .foregroundColor(isQiblaAligned ? .green : .red)
            }
            .offset(y: -95)
            .scaleEffect(isQiblaAligned ? 1.3 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isQiblaAligned)

            // Center dot with enhanced design
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.blue, .blue.opacity(0.6)],
                            center: .center,
                            startRadius: 2,
                            endRadius: 6
                        )
                    )
                    .frame(width: 12, height: 12)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                
                Circle()
                    .stroke(Color.white, lineWidth: 2)
                    .frame(width: 12, height: 12)
            }
        }
        .onChange(of: isQiblaAligned) { newValue in
            if newValue && !lastAlignedState {
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
                pulseAnimation = true
            } else if !newValue {
                pulseAnimation = false
            }
            lastAlignedState = newValue
            isAligned = newValue
        }
        .onAppear {
            compassService.startCompass()
        }
        .onDisappear {
            compassService.stopCompass()
        }
    }
}
