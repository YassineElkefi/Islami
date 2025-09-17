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
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header section
                    headerSection
                        .opacity(animateContent ? 1.0 : 0.0)
                        .offset(y: animateContent ? 0 : -20)
                        .animation(.easeInOut(duration: 0.6).delay(0.1), value: animateContent)
                    
                    // Calculation Method Section
                    calculationMethodSection
                        .opacity(animateContent ? 1.0 : 0.0)
                        .offset(x: animateContent ? 0 : -30)
                        .animation(.easeInOut(duration: 0.6).delay(0.2), value: animateContent)
                    
                    // Notifications Section
                    notificationsSection
                        .opacity(animateContent ? 1.0 : 0.0)
                        .offset(x: animateContent ? 0 : 30)
                        .animation(.easeInOut(duration: 0.6).delay(0.3), value: animateContent)
                    
                    // Actions Section
                    actionsSection
                        .opacity(animateContent ? 1.0 : 0.0)
                        .offset(y: animateContent ? 0 : 20)
                        .animation(.easeInOut(duration: 0.6).delay(0.4), value: animateContent)
                    
                    // About Section
                    aboutSection
                        .opacity(animateContent ? 1.0 : 0.0)
                        .offset(y: animateContent ? 0 : 30)
                        .animation(.easeInOut(duration: 0.6).delay(0.5), value: animateContent)
                    
                    Spacer(minLength: 50)
                }
                .padding()
            }
            .background(
                colorScheme == .dark ? Color(.systemBackground) : Color(.systemGray6).opacity(0.5)
            )
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    doneButton
                }
            }
        }
        .onAppear {
            notificationViewModel.checkNotificationStatus()
            withAnimation(.easeInOut(duration: 0.5)) {
                animateContent = true
            }
        }
        .onChange(of: viewModel.selectedMethod) { oldValue, newValue in
            viewModel.refreshPrayerTimes()
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 60, height: 60)
                    .shadow(color: Color.blue.opacity(0.2), radius: 4, x: 0, y: 2)
                
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.blue)
            }
            
            Text("Prayer Settings")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Customize your prayer experience")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.blue.opacity(0.1), lineWidth: 1)
        )
    }
    
    private var calculationMethodSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(
                icon: "compass.drawing",
                title: "Calculation Method"
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
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
    }
    
    private var notificationsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(
                icon: "bell.fill",
                title: "Notifications"
            )
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Prayer Notifications")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .fill(notificationViewModel.isNotificationEnabled ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                            .frame(width: 32, height: 32)
                            .shadow(
                                color: notificationViewModel.isNotificationEnabled ? Color.green.opacity(0.2) : Color.red.opacity(0.2),
                                radius: 3, x: 0, y: 1
                            )
                        
                        Image(systemName: notificationViewModel.isNotificationEnabled ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(notificationViewModel.isNotificationEnabled ? .green : .red)
                            .font(.system(size: 16, weight: .semibold))
                    }
                }
                
                Text(notificationViewModel.notificationStatus)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if !notificationViewModel.isNotificationEnabled {
                    Button("Enable Notifications") {
                        notificationViewModel.requestNotificationPermission()
                    }
                    .buttonStyle(SimpleButtonStyle(color: .green))
                }
            }
        }
        .padding(20)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
    }
    
    private var actionsSection: some View {
        VStack(spacing: 16) {
            sectionHeader(
                icon: "bolt.fill",
                title: "Actions"
            )
            
            VStack(spacing: 12) {
                Button("Refresh Prayer Times") {
                    viewModel.refreshPrayerTimes()
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(SimpleButtonStyle(color: .blue))
                
                if notificationViewModel.isNotificationEnabled, let timings = viewModel.prayerTimes {
                    Button("Update Notifications") {
                        notificationViewModel.schedulePrayerNotifications(timings: timings)
                    }
                    .buttonStyle(SimpleButtonStyle(color: .green))
                }
            }
        }
        .padding(20)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
    }
    
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(
                icon: "info.circle.fill",
                title: "About"
            )
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Data Source")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text("Prayer times are calculated using the Aladhan API based on your location and selected calculation method.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding(20)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
    }
    
    private var doneButton: some View {
        Button("Done") {
            presentationMode.wrappedValue.dismiss()
        }
        .font(.headline)
        .fontWeight(.semibold)
        .foregroundColor(.blue)
    }
    
    private func sectionHeader(icon: String, title: String) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 32, height: 32)
                
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.blue)
            }
            
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
    
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(
                colorScheme == .dark ? Color(.systemGray6) : Color.white
            )
    }
}

// Simple button style matching the main UI
struct SimpleButtonStyle: ButtonStyle {
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: color.opacity(0.3), radius: 4, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(color.opacity(0.2), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
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
