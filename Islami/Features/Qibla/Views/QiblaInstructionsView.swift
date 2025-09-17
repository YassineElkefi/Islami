//
//  QiblaInstructionsView.swift
//  Islami
//
//  Created by Yassine EL KEFI on 16/9/2025.
//

import SwiftUI

struct QiblaInstructionsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("How to Use Qibla Compass")
                .font(.headline)
                .foregroundColor(.primary)
            
            VStack(alignment: .leading, spacing: 12) {
                InstructionRow(
                    icon: "location.fill",
                    text: "Allow location access for accurate Qibla direction"
                )
                
                InstructionRow(
                    icon: "compass.drawing",
                    text: "Hold your device flat and away from magnetic objects"
                )
                
                InstructionRow(
                    icon: "arrow.up.circle",
                    text: "The green arrow points towards the Qibla direction"
                )
                
                InstructionRow(
                    icon: "exclamationmark.triangle",
                    text: "Calibrate your compass by moving your device in a figure-8 pattern"
                )
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct InstructionRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24, height: 24)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
}
