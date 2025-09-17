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
        NavigationView {
            VStack(spacing: 20) {
                if viewModel.isLoading {
                    ProgressView("Getting your location...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
            .navigationTitle("Qibla")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showInstructions.toggle()
                    } label: {
                        Image(systemName: "questionmark.circle")
                    }
                }
            }
            .sheet(isPresented: $showInstructions) {
                NavigationView {
                    QiblaInstructionsView()
                        .navigationTitle("Instructions")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Done") {
                                    showInstructions = false
                                }
                            }
                        }
                }
            }
        }
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
        VStack(spacing: 30) {
            VStack(spacing: 8) {
                Text("Distance to Kaaba")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(qiblaDirection.formattedDistance)
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            
            CompassView(qiblaDirection: qiblaDirection)
            
            VStack(spacing: 8) {
                Text("Qibla Direction")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(directionText)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(directionColor)
                    .animation(.easeInOut(duration: 0.3), value: directionText)
            }
        }
        .padding()
        .onAppear {
            compassService.startCompass()
        }
        .onDisappear {
            compassService.stopCompass()
        }
    }
}

struct WelcomeView: View {
    let onGetStarted: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "compass.drawing")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text("Find Qibla Direction")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Get accurate Qibla direction based on your current location")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Get Started") {
                onGetStarted()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

struct ErrorView: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text("Error")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Try Again") {
                onRetry()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
struct QiblaView_Previews: PreviewProvider {
    static var previews: some View {
        QiblaView()
    }
}
