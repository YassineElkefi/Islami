//
//  QiblaViewModel.swift
//  Islami
//
//  Created by Yassine EL KEFI on 16/9/2025.
//

import Foundation
import CoreLocation
import Combine

class QiblaViewModel: NSObject, ObservableObject {
    @Published var qiblaDirection: QiblaDirection?
    @Published var userLocation: CLLocation?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var permissionStatus: CLAuthorizationStatus = .notDetermined
    
    private let locationManager = CLLocationManager()
    private let qiblaService = QiblaService()
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        permissionStatus = locationManager.authorizationStatus
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getCurrentLocation() {
        guard permissionStatus == .authorizedWhenInUse || permissionStatus == .authorizedAlways else {
            errorMessage = "Location permission required"
            return
        }
        
        isLoading = true
        locationManager.requestLocation()
    }
    
    private func calculateQibla() {
        guard let location = userLocation else { return }
        qiblaDirection = qiblaService.calculateQiblaDirection(from: location)
        isLoading = false
    }
}

extension QiblaViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location
        calculateQibla()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        isLoading = false
        errorMessage = "Failed to get location: \(error.localizedDescription)"
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        permissionStatus = status
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            getCurrentLocation()
        }
    }
}
