//
//  QiblaService.swift
//  Islami
//
//  Created by Yassine EL KEFI on 16/9/2025.
//

import Foundation
import CoreLocation

class QiblaService {
    // Kaaba coordinates
    private let kaabaLocation = CLLocation(latitude: 21.4225, longitude: 39.8262)
    
    func calculateQiblaDirection(from userLocation: CLLocation) -> QiblaDirection {
        let bearing = calculateBearing(from: userLocation, to: kaabaLocation)
        let distance = userLocation.distance(from: kaabaLocation) / 1000
        
        return QiblaDirection(
            bearing: bearing,
            distance: distance,
            userLocation: userLocation
        )
    }
    
    private func calculateBearing(from startLocation: CLLocation, to endLocation: CLLocation) -> Double {
        let lat1 = startLocation.coordinate.latitude.toRadians()
        let lon1 = startLocation.coordinate.longitude.toRadians()
        let lat2 = endLocation.coordinate.latitude.toRadians()
        let lon2 = endLocation.coordinate.longitude.toRadians()
        
        let deltaLon = lon2 - lon1
        let y = sin(deltaLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLon)
        
        let bearing = atan2(y, x).toDegrees()
        return bearing >= 0 ? bearing : bearing + 360
    }
}

extension Double {
    func toRadians() -> Double {
        return self * .pi / 180
    }
    
    func toDegrees() -> Double {
        return self * 180 / .pi
    }
}
