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
        NavigationStack {
            ZStack {
                Color(.systemBackground).ignoresSafeArea()
                
                VStack(spacing: 20) {
                    if viewModel.isLoading {
                        LoadingView()
                    } else if let errorMessage = viewModel.errorMessage {
                        ErrorView(message: errorMessage) {
                            if viewModel.permissionStatus == .notDetermined {
                                viewModel.requestLocationPermission()
                            } else {
                                viewModel.getCurrentLocation()
                            }
                        }
                    } else if let qiblaDirection = viewModel.qiblaDirection {
                        QiblaContentView(qiblaDirection: qiblaDirection)
                    } else {
                        WelcomeView {
                            viewModel.requestLocationPermission()
                        }
                    }
                }
            }
            .navigationTitle("qibla_compass")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    LanguageSelector()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showInstructions.toggle()
                    } label: {
                        Image(systemName: "questionmark.circle.fill")
                            .foregroundColor(.blue)
                    }
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
            VStack(spacing: 30) {
                // Simplified distance card
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "location.circle.fill")
                            .foregroundColor(.blue)
                            .font(.title2)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Distance to Kaaba")
                                .font(.headline)
                            Text("Holy city of Mecca")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }

                    Text(qiblaDirection.formattedDistance)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemGray6))
                )

                // Compass
                CompassView(qiblaDirection: qiblaDirection)

                // Simplified direction card
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "safari.fill")
                            .foregroundColor(directionColor)
                            .font(.title2)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Qibla Direction")
                                .font(.headline)
                            Text("Turn until aligned")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Circle()
                                .fill(directionColor)
                                .frame(width: 6, height: 6)
                            Text(abs(dynamicQiblaDirection) <= 5 ? "ALIGNED" : "TURN")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(directionColor)
                        }
                    }

                    Text(directionText)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(directionColor)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemGray6))
                )
            }
            .padding(.horizontal, 20)
        }
        .onAppear {
            compassService.startCompass()
        }
        .onDisappear {
            compassService.stopCompass()
        }
    }
}

// Simplified loading view
struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.blue)
            
            Text("Getting your location...")
                .font(.headline)
            
            Text("Please wait while we determine your position")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

// Simplified welcome view
struct WelcomeView: View {
    let onGetStarted: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "compass.drawing")
                .font(.system(size: 64))
                .foregroundColor(.blue)
            
            VStack(spacing: 12) {
                Text("Find Qibla Direction")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("Get accurate Qibla direction based on your current location for precise prayer alignment")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button {
                onGetStarted()
            } label: {
                HStack {
                    Image(systemName: "location.fill")
                    Text("Get Started")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.blue)
                .clipShape(Capsule())
            }
        }
        .padding(32)
    }
}

// Simplified error view
struct ErrorView: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundColor(.orange)
            
            VStack(spacing: 8) {
                Text("Oops!")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(message)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button {
                onRetry()
            } label: {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Try Again")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.blue)
                .clipShape(Capsule())
            }
        }
        .padding(32)
    }
}

