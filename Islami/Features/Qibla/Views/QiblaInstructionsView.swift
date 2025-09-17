//
//  QiblaInstructionsView.swift
//  Islami
//
//  Created by Yassine EL KEFI on 16/9/2025.
//

import SwiftUI

// Missing Instruction model
struct Instruction {
    let icon: String
    let title: String
    let description: String
    let color: Color
}

struct QiblaInstructionsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Simple header
                VStack(spacing: 12) {
                    Image(systemName: "questionmark.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                    
                    Text("How to Use Qibla Compass")
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("Follow these simple steps for accurate results")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                // Simple instruction cards - Fixed ForEach syntax
                VStack(spacing: 16) {
                    ForEach(Array(instructions.enumerated()), id: \.offset) { index, instruction in
                        InstructionCard(instruction: instruction)
                    }
                }
                
                // Simple tips section
                VStack(alignment: .leading, spacing: 12) {
                    Text("💡 Pro Tips")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        TipRow(text: "Keep your device away from magnetic objects")
                        TipRow(text: "For best accuracy, use outdoors or near windows")
                        TipRow(text: "The compass needs a few seconds to stabilize")
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.yellow.opacity(0.1))
                )
            }
            .padding(20)
        }
    }
    
    // Fixed instructions array with proper Color syntax
    private let instructions = [
        Instruction(icon: "location.fill", title: "Location Access", description: "Allow location access for accurate Qibla direction", color: Color.blue),
        Instruction(icon: "iphone", title: "Device Position", description: "Hold your device flat and horizontally", color: Color.green),
        Instruction(icon: "arrow.trianglehead.clockwise", title: "Calibration", description: "Move your device in a figure-8 pattern", color: Color.orange),
        Instruction(icon: "safari.fill", title: "Qibla Direction", description: "The Kaaba icon points towards Qibla", color: Color.red)
    ]
}

struct InstructionCard: View {
    let instruction: Instruction
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: instruction.icon)
                .font(.title2)
                .foregroundColor(instruction.color)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(instruction.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(instruction.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

struct TipRow: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "lightbulb.fill")
                .foregroundColor(.yellow)
                .font(.caption)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}
