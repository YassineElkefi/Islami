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
    @State private var logoScale = 0.5
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
                    // Animate logo
                    withAnimation(.easeOut(duration: 0.8)) {
                        logoScale = 1.0
                        logoOpacity = 1.0
                    }
                    
                    // Rotate crescent
                    withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                        crescentRotation = 15.0
                    }
                    
                    // Animate text after logo
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.easeOut(duration: 0.6)) {
                            textOffset = 0.0
                            textOpacity = 1.0
                        }
                    }
                    
                    // Fade to main content
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        withAnimation(.easeInOut(duration: 0.8)) {
                            backgroundOpacity = 0.0
                            logoOpacity = 0.0
                            textOpacity = 0.0
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
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
