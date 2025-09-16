import Foundation
import CoreLocation
import Combine

@MainActor
class PrayerTimesViewModel: NSObject, ObservableObject {
    @Published var prayerTimes: PrayerTimings?
    @Published var hijriDate: String = ""
    @Published var gregorianDate: String = ""
    @Published var nextPrayer: Prayer = .fajr
    @Published var nextPrayerTime: String = ""
    @Published var timeUntilNext: String = "00:00:00"
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedMethod: CalculationMethod = .worldIslamicLeague
    
    private let locationManager = CLLocationManager()
    private let prayerService = PrayerTimesService.shared
    private let calculationService = PrayerCalculationService.shared
    private var timer: Timer?
    
    override init() {
        super.init()
        setupLocationManager()
        startTimer()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    func fetchPrayerTimes(latitude: Double, longitude: Double) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let response = try await prayerService.fetchPrayerTimes(
                    latitude: latitude,
                    longitude: longitude,
                    method: selectedMethod
                )
                
                prayerTimes = response.data.timings
                hijriDate = "\(response.data.date.hijri.date) \(response.data.date.hijri.month.en)"
                gregorianDate = response.data.date.readable
                
                updateNextPrayer()
                
            } catch {
                errorMessage = "Failed to fetch prayer times: \(error.localizedDescription)"
            }
            
            isLoading = false
        }
    }
    
    private func updateNextPrayer() {
        guard let timings = prayerTimes else { return }
        
        if let next = calculationService.getNextPrayer(from: timings) {
            nextPrayer = next.prayer
            nextPrayerTime = next.time
        }
        
        updateCountdown()
    }
    
    private func updateCountdown() {
        timeUntilNext = calculationService.timeUntilNextPrayer(nextPrayerTime: nextPrayerTime)
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            Task { @MainActor in
                self.updateCountdown()
            }
        }
    }
    
    func refreshPrayerTimes() {
        requestLocation()
    }
    
    deinit {
        timer?.invalidate()
    }
}

extension PrayerTimesViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        fetchPrayerTimes(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorMessage = "Failed to get location: \(error.localizedDescription)"
    }
}
