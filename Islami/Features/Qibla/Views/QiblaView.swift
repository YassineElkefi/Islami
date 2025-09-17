//
//  QiblaView.swift
//  Islami
//
//  Created by Yassine EL KEFI on 16/9/2025.
//

import SwiftUI
import CoreLocation

struct QiblaView: View {
    @StateObject private var viewModel = QiblaViewModel()
    @State private var showInstructions = false
    
    var body: some View {
        NavigationStack{
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color(.systemBackground),
                        Color(.systemGray6).opacity(0.3)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    if viewModel.isLoading {
                        LoadingView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if let errorMessage = viewModel.errorMessage {
                        ErrorView(message: errorMessage) {
                            if viewModel.permissionStatus == .notDetermined {
                                viewModel.requestLocationPermission()
                            } else {
                                viewModel.getCurrentLocation()
                            }
                        }
                        .transition(.scale.combined(with: .opacity))
                    } else if let qiblaDirection = viewModel.qiblaDirection {
                        QiblaContentView(qiblaDirection: qiblaDirection)
                            .transition(.asymmetric(
                                insertion: .move(edge: .bottom).combined(with: .opacity),
                                removal: .move(edge: .top).combined(with: .opacity)
                            ))
                    } else {
                        WelcomeView {
                            withAnimation(.easeInOut(duration: 0.6)) {
                                viewModel.requestLocationPermission()
                            }
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                }
                .animation(.easeInOut(duration: 0.8), value: viewModel.isLoading)
                .animation(.easeInOut(duration: 0.8), value: viewModel.qiblaDirection)
            }
            .navigationTitle("qibla_compass")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    LanguageSelector()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showInstructions.toggle()
                    } label: {
                        Image(systemName: "questionmark.circle.fill")
                            .foregroundColor(.blue)
                    }
                    .scaleEffect(showInstructions ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: showInstructions)
                }
            }
            .sheet(isPresented: $showInstructions) {
                NavigationView {
                    QiblaInstructionsView()
                        .navigationTitle("instructions")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("done") {
                                    showInstructions = false
                                }
                                .fontWeight(.medium)
                            }
                        }
                }
                .presentationDetents([.medium, .large])
            }
        }
        .id(LocalizationManager.shared.currentLanguage)
        .onAppear {
            if viewModel.permissionStatus == .authorizedWhenInUse || viewModel.permissionStatus == .authorizedAlways {
                viewModel.getCurrentLocation()
            }
        }
    }
}

struct QiblaContentView: View {
    let qiblaDirection: QiblaDirection
    @StateObject private var compassService = CompassService()
    @State private var animateDistance = false
    @State private var animateDegree = false
    @State private var showCompass = false

    private var currentHeading: Double {
        compassService.heading?.magneticHeading ?? 0
    }

    private var dynamicQiblaDirection: Double {
        let direction = qiblaDirection.bearing - currentHeading
        let normalizedDirection = direction < 0 ? direction + 360 : direction
        return normalizedDirection > 180 ? normalizedDirection - 360 : normalizedDirection
    }

    private var directionText: String {
        let absDirection = abs(dynamicQiblaDirection)
        if absDirection <= 5 {
            return "0° - Aligned!"
        }
        return "\(Int(absDirection))°"
    }

    private var directionColor: Color {
        let absDirection = abs(dynamicQiblaDirection)
        if absDirection <= 5 {
            return .green
        } else if absDirection <= 15 {
            return .orange
        } else {
            return .red
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                // Distance Card with enhanced design
                VStack(spacing: 16) {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.1))
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: "location.circle.fill")
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.blue, .cyan],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .font(.title2)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Distance to Kaaba")
                                .font(.headline)
                                .fontWeight(.medium)
                            
                            Text("Holy city of Mecca")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }

                    Text(qiblaDirection.formattedDistance)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.primary, .secondary],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .scaleEffect(animateDistance ? 1.05 : 1.0)
                        .animation(.easeInOut(duration: 0.6), value: animateDistance)
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.05), radius: 20, x: 0, y: 10)
                        .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
                )

                // Enhanced Compass
                CompassView(qiblaDirection: qiblaDirection)
                    .scaleEffect(showCompass ? 1.0 : 0.8)
                    .opacity(showCompass ? 1.0 : 0.0)
                    .animation(.spring(response: 0.8, dampingFraction: 0.8), value: showCompass)

                // Direction Card with enhanced design
                VStack(spacing: 16) {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(directionColor.opacity(0.1))
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: "safari.fill")
                                .foregroundColor(directionColor)
                                .font(.title2)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Qibla Direction")
                                .font(.headline)
                                .fontWeight(.medium)
                            
                            Text("Turn until aligned")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        // Status indicator
                        HStack(spacing: 6) {
                            Circle()
                                .fill(directionColor)
                                .frame(width: 8, height: 8)
                            
                            Text(abs(dynamicQiblaDirection) <= 5 ? "ALIGNED" : "TURN")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(directionColor)
                        }
                    }

                    Text(directionText)
                        .font(.system(size: 40, weight: .heavy, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [directionColor, directionColor.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .scaleEffect(animateDegree ? 1.02 : 1.0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateDegree)
                        .animation(.easeInOut(duration: 0.3), value: directionText)
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.systemBackground))
                        .shadow(color: directionColor.opacity(0.1), radius: 20, x: 0, y: 10)
                        .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
                )
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .onAppear {
            compassService.startCompass()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showCompass = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                animateDistance = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                animateDegree = true
            }
        }
        .onDisappear {
            compassService.stopCompass()
        }
    }
}

struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .stroke(Color.blue.opacity(0.3), lineWidth: 4)
                    .frame(width: 60, height: 60)
                
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(
                        LinearGradient(
                            colors: [.blue, .cyan],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
                
                Image(systemName: "location.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            
            Text("Getting your location...")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Please wait while we determine your position")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct WelcomeView: View {
    let onGetStarted: () -> Void
    @State private var animateIcon = false
    @State private var showContent = false
    
    var body: some View {
        VStack(spacing: 32) {
            // Animated Icon
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.blue.opacity(0.2), .clear],
                            center: .center,
                            startRadius: 20,
                            endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)
                    .scaleEffect(animateIcon ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: animateIcon)
                
                Image(systemName: "compass.drawing")
                    .font(.system(size: 64, weight: .light))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .cyan],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .rotationEffect(.degrees(animateIcon ? 15 : -15))
                    .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: animateIcon)
            }
            
            VStack(spacing: 16) {
                Text("Find Qibla Direction")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                
                Text("Get accurate Qibla direction based on your current location for precise prayer alignment")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
            .opacity(showContent ? 1 : 0)
            .offset(y: showContent ? 0 : 20)
            .animation(.easeOut(duration: 0.8).delay(0.5), value: showContent)
            
            Button {
                onGetStarted()
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "location.fill")
                    Text("Get Started")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [.blue, .blue.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(Capsule())
                .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .scaleEffect(showContent ? 1 : 0.8)
            .opacity(showContent ? 1 : 0)
            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.8), value: showContent)
        }
        .padding(.horizontal, 32)
        .onAppear {
            animateIcon = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showContent = true
            }
        }
    }
}

struct ErrorView: View {
    let message: String
    let onRetry: () -> Void
    @State private var animateIcon = false
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 64))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.orange, .red],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .scaleEffect(animateIcon ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animateIcon)
            
            VStack(spacing: 12) {
                Text("Oops!")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                
                Text(message)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
            
            Button {
                onRetry()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.clockwise")
                    Text("Try Again")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    LinearGradient(
                        colors: [.blue, .blue.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(Capsule())
                .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
            }
        }
        .padding(.horizontal, 32)
        .onAppear {
            animateIcon = true
        }
    }
}

