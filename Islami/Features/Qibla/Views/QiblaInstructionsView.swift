//
//  QiblaInstructionsView.swift
//  Islami
//
//  Created by Yassine EL KEFI on 16/9/2025.
//

import SwiftUI

struct QiblaInstructionsView: View {
    @State private var animateInstructions = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.blue.opacity(0.2), .cyan.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "questionmark.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                    }
                    
                    Text("How to Use Qibla Compass")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                    
                    Text("Follow these simple steps for accurate results")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)
                
                // Instructions
                VStack(spacing: 20) {
                    ForEach(Array(instructions.enumerated()), id: \.offset) { index, instruction in
                        InstructionCard(
                            instruction: instruction,
                            index: index
                        )
                        .opacity(animateInstructions ? 1 : 0)
                        .offset(x: animateInstructions ? 0 : -50)
                        .animation(
                            .easeOut(duration: 0.6)
                                .delay(Double(index) * 0.2),
                            value: animateInstructions
                        )
                    }
                }
                
                // Tips section
                VStack(alignment: .leading, spacing: 16) {
                    Text("💡 Pro Tips")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        TipRow(text: "Keep your device away from magnetic objects like speakers or metal")
                        TipRow(text: "For best accuracy, use outdoors or near windows")
                        TipRow(text: "The compass needs a few seconds to stabilize")
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.yellow.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
                        )
                )
                .opacity(animateInstructions ? 1 : 0)
                .offset(y: animateInstructions ? 0 : 30)
                .animation(.easeOut(duration: 0.8).delay(1.0), value: animateInstructions)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .onAppear {
            animateInstructions = true
        }
    }
    
    private let instructions = [
        Instruction(
            icon: "location.fill",
            title: "Location Access",
            description: "Allow location access for accurate Qibla direction calculation",
            color: .blue
        ),
        Instruction(
            icon: "iphone",
            title: "Device Position",
            description: "Hold your device flat and horizontally for best compass reading",
            color: .green
        ),
        Instruction(
            icon: "arrow.trianglehead.clockwise",
            title: "Calibration",
            description: "Move your device in a figure-8 pattern to calibrate the compass",
            color: .orange
        ),
        Instruction(
            icon: "safari.fill",
            title: "Qibla Direction",
            description: "The Kaaba icon points towards the Qibla direction",
            color: .red
        )
    ]
}

struct Instruction {
    let icon: String
    let title: String
    let description: String
    let color: Color
}

struct InstructionCard: View {
    let instruction: Instruction
    let index: Int
    @State private var animateIcon = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon container
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(instruction.color.opacity(0.15))
                    .frame(width: 50, height: 50)
                
                Image(systemName: instruction.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(instruction.color)
                    .scaleEffect(animateIcon ? 1.1 : 1.0)
                    .animation(
                        .easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.3),
                        value: animateIcon
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(instruction.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(instruction.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(nil)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
        )
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.5) {
                animateIcon = true
            }
        }
    }
}

struct TipRow: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "lightbulb.fill")
                .foregroundColor(.yellow)
                .font(.caption)
                .frame(width: 16, height: 16)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
}
