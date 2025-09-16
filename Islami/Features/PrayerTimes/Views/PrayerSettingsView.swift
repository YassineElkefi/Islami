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
    
    var body: some View {
        NavigationView {
            Form {
                Section("Calculation Method") {
                    Picker("Method", selection: $viewModel.selectedMethod) {
                        ForEach(CalculationMethod.allCases, id: \.self) { method in
                            VStack(alignment: .leading) {
                                Text(method.name)
                                    .font(.headline)
                                Text(method.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .tag(method)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                
                Section("Notifications") {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Prayer Notifications")
                                .font(.headline)
                            Spacer()
                            if notificationViewModel.isNotificationEnabled {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            } else {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                        
                        Text(notificationViewModel.notificationStatus)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        if !notificationViewModel.isNotificationEnabled {
                            Button("Enable Notifications") {
                                notificationViewModel.requestNotificationPermission()
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .padding(.vertical, 4)
                }
                
                Section("Actions") {
                    Button("Refresh Prayer Times") {
                        viewModel.refreshPrayerTimes()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.blue)
                    
                    if notificationViewModel.isNotificationEnabled, let timings = viewModel.prayerTimes {
                        Button("Update Notifications") {
                            notificationViewModel.schedulePrayerNotifications(timings: timings)
                        }
                        .foregroundColor(.green)
                    }
                }
                
                Section("About") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Data Source")
                            .font(.headline)
                        Text("Prayer times are provided by the Aladhan API, which calculates accurate prayer times based on your location and selected calculation method.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Prayer Settings")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
        .onAppear {
            notificationViewModel.checkNotificationStatus()
        }
        .onChange(of: viewModel.selectedMethod) { _ in
            viewModel.refreshPrayerTimes()
        }
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
