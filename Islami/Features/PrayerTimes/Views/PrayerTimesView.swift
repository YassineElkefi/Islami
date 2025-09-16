//
//  PrayerTimesView.swift
//  Islami
//
//  Created by Yassine EL KEFI on 16/9/2025.
//

import SwiftUI

struct PrayerTimesView:View {
    @StateObject private var viewModel = PrayerTimesViewModel()
    @StateObject private var notificationViewModel = PrayerNotificationViewModel()
    @State private var showSettings = false
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(spacing:20){
                    //Header Section
                    headerSection
                    
                    //Next Prayer Section
                    NextPrayerView(nextPrayer: viewModel.nextPrayer,
                                   timeUntilNext: viewModel.timeUntilNext,
                                   nextPrayerTime: viewModel.nextPrayerTime)
                    
                    //Prayer Times Grid
                    prayerTimesGrid
                    
                    //Refresh Button
                    refreshButton
                }
                .padding()
            }
            .navigationTitle("Prayer Times")
            .navigationBarItems(trailing: settingsButton)
            .sheet(isPresented: $showSettings){
                PrayerSettingsView(viewModel: viewModel, notificationViewModel: notificationViewModel)
            }
            .onAppear{
                viewModel.requestLocation()
            }
        }
    }
    private var headerSection: some View {
        VStack(spacing:8){
            if !viewModel.hijriDate.isEmpty {
                Text(viewModel.hijriDate)
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            
            if !viewModel.gregorianDate.isEmpty {
                Text(viewModel.gregorianDate)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var prayerTimesGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
            if let timings = viewModel.prayerTimes {
                PrayerTimeCardView(prayer: .fajr, time: timings.fajr, isNext: viewModel.nextPrayer == .fajr)
                PrayerTimeCardView(prayer: .dhuhr, time: timings.dhuhr, isNext: viewModel.nextPrayer == .dhuhr)
                PrayerTimeCardView(prayer: .asr, time: timings.asr, isNext: viewModel.nextPrayer == .asr)
                PrayerTimeCardView(prayer: .maghrib, time: timings.maghrib, isNext: viewModel.nextPrayer == .maghrib)
                PrayerTimeCardView(prayer: .isha, time: timings.isha, isNext: viewModel.nextPrayer == .isha)
            } else if viewModel.isLoading {
                ForEach(0..<5, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                        .frame(height: 100)
                        .shimmering()
                }
            }
        }
    }
    
    private var refreshButton: some View {
        Button(action: {
            viewModel.refreshPrayerTimes()
        }) {
            HStack {
                Image(systemName: "arrow.clockwise")
                Text("Refresh")
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .cornerRadius(12)
        }
        .disabled(viewModel.isLoading)
    }
    
    private var settingsButton: some View {
        Button(action: {
            showSettings = true
        }) {
            Image(systemName: "gear")
        }
    }
}

// Shimmering effect for loading state
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
