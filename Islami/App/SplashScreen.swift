//
//  SplashScreen.swift
//  Islami
//
//  Created by Yassine EL KEFI on 17/9/2025.
//

import Foundation
import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    @State private var logoScale = 0.3
    @State private var logoOpacity = 0.0
    @State private var textOffset = 50.0
    @State private var textOpacity = 0.0
    @State private var backgroundOpacity = 1.0
    @State private var crescentRotation = 0.0

    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                // Gradient background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.purple.opacity(0.9),
                        Color.indigo.opacity(0.8),
                        Color.blue.opacity(0.7)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                .opacity(backgroundOpacity)
                
                VStack(spacing: 20) {
                    // Islamic crescent and star
                    ZStack {
                        Image(systemName: "moon.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.white)
                            .rotationEffect(.degrees(crescentRotation))
                        
                        Image(systemName: "star.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.yellow)
                            .offset(x: 25, y: -10)
                    }
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                    
                    VStack(spacing: 8) {
                        Text("إسلامي")
                            .font(.custom("Kufam-Regular", size: 32))
                            .foregroundColor(.white)
                        
                        Text("ISLAMI")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white.opacity(0.9))
                            .tracking(2)
                        
                        Text("Your Prayer Companion")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                            .fontWeight(.medium)
                    }
                    .offset(y: textOffset)
                    .opacity(textOpacity)
                }
                .onAppear {
                    // Animate logo with spring animation
                    withAnimation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0.2)) {
                        logoScale = 1.0
                        logoOpacity = 1.0
                    }
                    
                    // Gentle crescent rotation
                    withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                        crescentRotation = 10.0
                    }
                    
                    // Animate text with spring animation
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.1)) {
                            textOffset = 0.0
                            textOpacity = 1.0
                        }
                    }
                    
                    // Smooth fade to main content
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                        withAnimation(.easeInOut(duration: 1.0)) {
                            backgroundOpacity = 0.0
                            logoOpacity = 0.0
                            textOpacity = 0.0
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            isActive = true
                        }
                    }
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
