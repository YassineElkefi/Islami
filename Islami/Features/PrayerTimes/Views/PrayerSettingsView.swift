//
//  PrayerSettingsView.swift
//  Islami
//
//  Created by Yassine EL KEFI on 16/9/2025.
//

import SwiftUI

struct PrayerSettingsView: View {
    @ObservedObject var viewModel: PrayerTimesViewModel
    @ObservedObject var notificationViewModel: PrayerNotificationViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var animateContent = false
    @State private var pulseAnimation = false
    @State private var rotationAnimation = 0.0
    
    var body: some View {
        NavigationView {
            ZStack {
                // Animated background
                backgroundGradient
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header section
                        headerSection
                            .opacity(animateContent ? 1.0 : 0.0)
                            .offset(y: animateContent ? 0 : -30)
                            .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.1), value: animateContent)
                        
                        // Calculation Method Section
                        calculationMethodSection
                            .opacity(animateContent ? 1.0 : 0.0)
                            .offset(x: animateContent ? 0 : -50)
                            .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2), value: animateContent)
                        
                        // Notifications Section
                        notificationsSection
                            .opacity(animateContent ? 1.0 : 0.0)
                            .offset(x: animateContent ? 0 : 50)
                            .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.3), value: animateContent)
                        
                        // Actions Section
                        actionsSection
                            .opacity(animateContent ? 1.0 : 0.0)
                            .offset(y: animateContent ? 0 : 30)
                            .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.4), value: animateContent)
                        
                        // About Section
                        aboutSection
                            .opacity(animateContent ? 1.0 : 0.0)
                            .offset(y: animateContent ? 0 : 40)
                            .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.5), value: animateContent)
                        
                        Spacer(minLength: 50)
                    }
                    .padding()
                }
            }
            .navigationTitle("Prayer Settings")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: doneButton
            )
        }
        .onAppear {
            notificationViewModel.checkNotificationStatus()
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                animateContent = true
            }
            pulseAnimation = true
        }
        .onChange(of: viewModel.selectedMethod) { _ in
            viewModel.refreshPrayerTimes()
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(.systemBackground),
                Color.blue.opacity(0.02),
                Color.purple.opacity(0.01),
                Color(.systemBackground)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        .opacity(animateContent ? 1.0 : 0.0)
        .animation(.easeOut(duration: 1.0), value: animateContent)
    }
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue.opacity(0.2), .purple.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .scaleEffect(pulseAnimation ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: pulseAnimation)
                
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 36, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .rotationEffect(.degrees(rotationAnimation))
                    .animation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true), value: pulseAnimation)
            }
            
            Text("Customize Your Prayer Experience")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .multilineTextAlignment(.center)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(cardBorder)
        .onAppear {
            withAnimation(.linear(duration: 10.0).repeatForever(autoreverses: false)) {
                rotationAnimation = 360
            }
        }
    }
    
    private var calculationMethodSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(
                icon: "compass.drawing",
                title: "Calculation Method",
                subtitle: "Choose the method for calculating prayer times"
            )
            
            Picker("Method", selection: $viewModel.selectedMethod) {
                ForEach(CalculationMethod.allCases, id: \.self) { method in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(method.name)
                            .font(.headline)
                            .fontWeight(.semibold)
                        Text(method.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                    .tag(method)
                }
            }
            .pickerStyle(.navigationLink)
            .accentColor(.blue)
        }
        .padding(20)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(cardBorder)
    }
    
    private var notificationsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(
                icon: "bell.fill",
                title: "Notifications",
                subtitle: "Manage prayer time notifications"
            )
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Prayer Notifications")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .fill(notificationViewModel.isNotificationEnabled ? .green.opacity(0.2) : .red.opacity(0.2))
                            .frame(width: 40, height: 40)
                            .scaleEffect(pulseAnimation ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulseAnimation)
                        
                        Image(systemName: notificationViewModel.isNotificationEnabled ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(notificationViewModel.isNotificationEnabled ? .green : .red)
                            .font(.system(size: 20, weight: .semibold))
                    }
                }
                
                Text(notificationViewModel.notificationStatus)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.leading, 4)
                
                if !notificationViewModel.isNotificationEnabled {
                    Button("Enable Notifications") {
                        notificationViewModel.requestNotificationPermission()
                    }
                    .buttonStyle(AnimatedButtonStyle(colors: [.green, .blue]))
                }
            }
        }
        .padding(20)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(cardBorder)
    }
    
    private var actionsSection: some View {
        VStack(spacing: 16) {
            sectionHeader(
                icon: "bolt.fill",
                title: "Actions",
                subtitle: "Quick actions and updates"
            )
            
            VStack(spacing: 12) {
                Button("Refresh Prayer Times") {
                    viewModel.refreshPrayerTimes()
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(AnimatedButtonStyle(colors: [.blue, .purple]))
                
                if notificationViewModel.isNotificationEnabled, let timings = viewModel.prayerTimes {
                    Button("Update Notifications") {
                        notificationViewModel.schedulePrayerNotifications(timings: timings)
                    }
                    .buttonStyle(AnimatedButtonStyle(colors: [.green, .teal]))
                }
            }
        }
        .padding(20)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(cardBorder)
    }
    
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(
                icon: "info.circle.fill",
                title: "About",
                subtitle: "Information about data sources"
            )
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Data Source")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text("Prayer times are provided by the Aladhan API, which calculates accurate prayer times based on your location and selected calculation method.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding(20)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(cardBorder)
    }
    
    private var doneButton: some View {
        Button("Done") {
            presentationMode.wrappedValue.dismiss()
        }
        .font(.headline)
        .fontWeight(.semibold)
        .foregroundStyle(
            LinearGradient(
                colors: [.blue, .purple],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .scaleEffect(pulseAnimation ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: pulseAnimation)
    }
    
    private func sectionHeader(icon: String, title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.blue.opacity(0.2), .purple.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [.blue.opacity(0.3), .purple.opacity(0.2)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 2)
                .clipShape(RoundedRectangle(cornerRadius: 1))
        }
    }
    
    private var cardBackground: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(.systemGray6).opacity(0.8),
                    Color(.systemGray5).opacity(0.3)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    RadialGradient(
                        colors: [.blue.opacity(0.05), .clear],
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: 150
                    )
                )
                .opacity(pulseAnimation ? 0.8 : 0.4)
                .animation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true), value: pulseAnimation)
        }
    }
    
    private var cardBorder: some View {
        RoundedRectangle(cornerRadius: 16)
            .stroke(
                LinearGradient(
                    colors: [.blue.opacity(0.2), .purple.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 1.5
            )
    }
}

struct AnimatedButtonStyle: ButtonStyle {
    let colors: [Color]
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                LinearGradient(
                    colors: colors,
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: colors.first?.opacity(0.3) ?? .clear, radius: 8, x: 0, y: 4)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct PrayerSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        PrayerSettingsView(
            viewModel: PrayerTimesViewModel(),
            notificationViewModel: PrayerNotificationViewModel()
        )
    }
}
