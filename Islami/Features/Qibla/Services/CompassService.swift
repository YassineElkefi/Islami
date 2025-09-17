//
//  CompassService.swift
//  Islami
//
//  Created by Yassine EL KEFI on 16/9/2025.
//

import Foundation
import CoreLocation
import Combine

class CompassService: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    @Published var heading: CLHeading?
    @Published var isCompassAvailable = false

    override init() {
        super.init()
        setupLocationManager()
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.headingFilter = 1.0
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        isCompassAvailable = CLLocationManager.headingAvailable()

        if isCompassAvailable {
            locationManager.startUpdatingHeading()
        }
    }

    func startCompass() {
        guard isCompassAvailable else { return }
        locationManager.startUpdatingHeading()
    }

    func stopCompass() {
        locationManager.stopUpdatingHeading()
    }
}

extension CompassService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if newHeading.headingAccuracy < 0 { return }
        heading = newHeading
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
}
