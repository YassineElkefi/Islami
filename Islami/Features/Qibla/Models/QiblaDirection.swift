//
//  QiblaDirection.swift
//  Islami
//
//  Created by Yassine EL KEFI on 16/9/2025.
//

import Foundation
import CoreLocation

struct QiblaDirection: Equatable {
    let bearing: Double
    let distance: Double
    let userLocation: CLLocation
    
    var bearingInRadians: Double {
        return bearing * .pi / 180
    }
    
    var formattedDistance: String {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        let distance = Measurement(value: self.distance, unit: UnitLength.kilometers)
        return formatter.string(from: distance)
    }
}
