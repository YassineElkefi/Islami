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
    
    private var alignmentThreshold: Double { 5.0 } // degrees
    
    private var isQiblaAligned: Bool {
        let angleDiff = abs(currentQiblaDirection)
        return angleDiff <= alignmentThreshold || angleDiff >= (360 - alignmentThreshold)
    }

    var body: some View {
        ZStack {
            // Compass background
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                .frame(width: 250, height: 250)

            // Compass markings
            ForEach(0..<360, id: \.self) { degree in
                if degree % 30 == 0 {
                    Rectangle()
                        .fill(Color.primary)
                        .frame(width: 2, height: degree % 90 == 0 ? 20 : 10)
                        .offset(y: -115)
                        .rotationEffect(.degrees(Double(degree) - currentHeading))
                }
            }

            // Cardinal directions
            VStack {
                Text("N").font(.headline).bold()
                Spacer()
                HStack {
                    Text("W").font(.headline).bold()
                    Spacer()
                    Text("E").font(.headline).bold()
                }
                Spacer()
                Text("S").font(.headline).bold()
            }
            .frame(width: 200, height: 200)
            .rotationEffect(.degrees(-currentHeading))

            // Qibla direction indicator (Kaaba emoji)
            if qiblaDirection != nil {
                Text("🕋")
                    .font(.system(size: 30))
                    .offset(y: -100)
                    .rotationEffect(.degrees(qiblaAngle))
            }

            // North indicator (changes color when aligned)
            Image(systemName: "arrow.up")
                .font(.title2)
                .foregroundColor(isQiblaAligned ? .green : .red)
                .offset(y: -100)
                .scaleEffect(isQiblaAligned ? 1.2 : 1.0)
                .animation(.spring(response: 0.3), value: isQiblaAligned)

            // Center dot
            Circle()
                .fill(Color.primary)
                .frame(width: 8, height: 8)
        }
        .onChange(of: isQiblaAligned) { newValue in
            if newValue && !lastAlignedState {
                // Trigger haptic feedback when becoming aligned
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
