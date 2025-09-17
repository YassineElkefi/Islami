//
//  PrayerTimesView.swift
//  Islami
//
//  Created by Yassine EL KEFI on 16/9/2025.
//

import SwiftUI

struct PrayerTimesView: View {
    @StateObject private var viewModel = PrayerTimesViewModel()
    @StateObject private var notificationViewModel = PrayerNotificationViewModel()
    @State private var showSettings = false
    @State private var animateContent = false
    @State private var refreshRotation = 0.0
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        NavigationView {
            ZStack {
                // Animated background
                backgroundGradient

                ScrollView {
                    VStack(spacing: 24) {
                        // Animated header section
                        headerSection
                            .opacity(animateContent ? 1.0 : 0.0)
                            .offset(y: animateContent ? 0 : -20)
                            .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.1), value: animateContent)

                        // Next Prayer Section
                        NextPrayerView(
                            nextPrayer: viewModel.nextPrayer,
                            timeUntilNext: viewModel.timeUntilNext,
                            nextPrayerTime: viewModel.nextPrayerTime,
                            isLoading: viewModel.isLoading
                        )
                        .opacity(animateContent ? 1.0 : 0.0)
                        .offset(x: animateContent ? 0 : -50)
                        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2), value: animateContent)

                        // Prayer Times Grid
                        prayerTimesGrid
                            .opacity(animateContent ? 1.0 : 0.0)
                            .offset(y: animateContent ? 0 : 30)
                            .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.3), value: animateContent)

                        // Animated Refresh Button
                        refreshButton
                            .opacity(animateContent ? 1.0 : 0.0)
                            .offset(y: animateContent ? 0 : 40)
                            .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.4), value: animateContent)

                        Spacer(minLength: 50)
                    }
                    .padding()
                }
            }
            .navigationTitle("Prayer Times")
            .navigationBarItems(trailing: settingsButton)
            .sheet(isPresented: $showSettings) {
                PrayerSettingsView(viewModel: viewModel, notificationViewModel: notificationViewModel)
            }
            .onAppear {
                viewModel.requestLocation()
                withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                    animateContent = true
                }
            }
        }
    }

    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(.systemBackground),
                Color.blue.opacity(colorScheme == .dark ? 0.06 : 0.03),
                Color.purple.opacity(colorScheme == .dark ? 0.04 : 0.02),
                Color(.systemBackground)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        .opacity(animateContent ? 1.0 : 0.0)
        .animation(.easeOut(duration: 1.2), value: animateContent)
    }

    private var headerSection: some View {
        VStack(spacing: 12) {
            if !viewModel.hijriDate.isEmpty {
                Text(viewModel.hijriDate)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }

            if !viewModel.gregorianDate.isEmpty {
                Text(viewModel.gregorianDate)
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [
                                colorScheme == .dark ? Color(.systemGray5) : Color(.systemGray6),
                                colorScheme == .dark ? Color(.systemGray6) : Color(.systemGray5).opacity(0.5)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.blue.opacity(colorScheme == .dark ? 0.15 : 0.1),
                                Color.clear
                            ],
                            center: .topLeading,
                            startRadius: 0,
                            endRadius: 100
                        )
                    )
                    .opacity(animateContent ? 0.7 : 0.0)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animateContent)
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.blue.opacity(colorScheme == .dark ? 0.3 : 0.2),
                            Color.purple.opacity(colorScheme == .dark ? 0.2 : 0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
    }

    private func loadingCard(index: Int) -> some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(
                LinearGradient(
                    colors: [
                        colorScheme == .dark ? Color(.systemGray5) : Color(.systemGray6),
                        colorScheme == .dark ? Color(.systemGray6) : Color(.systemGray5).opacity(0.5)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(height: 120)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.clear,
                                colorScheme == .dark ? Color.primary.opacity(0.1) : Color.white.opacity(0.6),
                                Color.clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .offset(x: animateContent ? 200 : -200)
                    .animation(
                        .linear(duration: 1.5)
                        .repeatForever(autoreverses: false)
                        .delay(Double(index) * 0.1),
                        value: animateContent
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var prayerTimesGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 20) {
            if let timings = viewModel.prayerTimes {
                Group {
                    PrayerTimeCardView(prayer: .fajr, time: timings.fajr, isNext: viewModel.nextPrayer == .fajr)
                        .transition(.asymmetric(insertion: .move(edge: .leading).combined(with: .opacity), removal: .opacity))

                    PrayerTimeCardView(prayer: .dhuhr, time: timings.dhuhr, isNext: viewModel.nextPrayer == .dhuhr)
                        .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity), removal: .opacity))

                    PrayerTimeCardView(prayer: .asr, time: timings.asr, isNext: viewModel.nextPrayer == .asr)
                        .transition(.asymmetric(insertion: .move(edge: .leading).combined(with: .opacity), removal: .opacity))

                    PrayerTimeCardView(prayer: .maghrib, time: timings.maghrib, isNext: viewModel.nextPrayer == .maghrib)
                        .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity), removal: .opacity))

                    PrayerTimeCardView(prayer: .isha, time: timings.isha, isNext: viewModel.nextPrayer == .isha)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            } else if viewModel.isLoading {
                ForEach(0..<5, id: \.self) { index in
                    loadingCard(index: index)
                }
            }
        }
    }

    private var refreshButton: some View {
        Button(action: {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                refreshRotation += 360
            }
            viewModel.refreshPrayerTimes()
        }) {
            HStack(spacing: 12) {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 18, weight: .medium))
                    .rotationEffect(.degrees(refreshRotation))

                Text("Refresh Prayer Times")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
            .scaleEffect(viewModel.isLoading ? 0.95 : 1.0)
            .opacity(viewModel.isLoading ? 0.7 : 1.0)
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: viewModel.isLoading)
        }
        .disabled(viewModel.isLoading)
        .buttonStyle(ScaleButtonStyle())
    }

    private var settingsButton: some View {
        Button(action: {
            showSettings = true
        }) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue.opacity(0.1), .purple.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 35, height: 35)

                Image(systemName: "gearshape.fill")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// Custom button style to fix the error
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// Enhanced shimmering effect
extension View {
    func shimmering() -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [.clear, .white.opacity(0.4), .clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: false), value: UUID())
        )
    }
}

struct PrayerTimesView_Previews: PreviewProvider {
    static var previews: some View {
        PrayerTimesView()
    }
}
