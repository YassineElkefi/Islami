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
            // Simplified compass background
            Circle()
                .fill(Color(.systemBackground))
                .frame(width: 260, height: 260)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)

            // Simple compass border
            Circle()
                .stroke(Color.blue.opacity(0.6), lineWidth: 2)
                .frame(width: 260, height: 260)

            // Reduced compass markings - only major ones
            ForEach(Array(stride(from: 0, to: 360, by: 30)), id: \.self) { degree in
                Rectangle()
                    .fill(degree % 90 == 0 ? Color.primary : Color.secondary)
                    .frame(width: degree % 90 == 0 ? 3 : 2, height: degree % 90 == 0 ? 20 : 12)
                    .offset(y: -120)
                    .rotationEffect(.degrees(Double(degree) - currentHeading))
            }

            // Simplified cardinal directions
            VStack {
                Text("N")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                Spacer()
                HStack {
                    Text("W")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                    Text("E")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                Spacer()
                Text("S")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            .frame(width: 200, height: 200)
            .rotationEffect(.degrees(-currentHeading))

            // Simplified Qibla direction indicator
            if qiblaDirection != nil {
                VStack(spacing: 2) {
                    Text("🕋")
                        .font(.system(size: 28))
                    
                    Text("QIBLA")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(.green)
                }
                .offset(y: -95)
                .rotationEffect(.degrees(qiblaAngle))
                .scaleEffect(isQiblaAligned ? 1.1 : 1.0)
            }

            // Simplified north indicator
            VStack(spacing: 2) {
                Image(systemName: isQiblaAligned ? "checkmark.circle.fill" : "arrow.up.circle.fill")
                    .font(.title2)
                    .foregroundColor(isQiblaAligned ? .green : .red)
                
                Text("NORTH")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(isQiblaAligned ? .green : .red)
            }
            .offset(y: -95)

            // Simple center dot
            Circle()
                .fill(Color.blue)
                .frame(width: 8, height: 8)
        }
        .onChange(of: isQiblaAligned) { newValue in
            if newValue && !lastAlignedState {
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
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
