
import Foundation
import CoreLocation

protocol LocationServiceOutput: AnyObject {
    func setCoordinates(longitude: Double, latitude: Double)
    func setCity(_ city: String)
    func getLocale() -> Locale
}

protocol LocationServiceInput {
    func updateCity()
}

class LocationService: NSObject {

    var locationManager: CLLocationManager?
    weak var delegate: LocationServiceOutput?
    
    init(delegate: LocationServiceOutput?) {
        super.init()
        self.delegate = delegate
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    }
    
    func startService() {
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
        updateCity()
    }
    
    func updateCity(location: CLLocation?) {
        if let location = location ?? locationManager?.location {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location, preferredLocale: delegate?.getLocale()) { [weak self] (placemarks, error) in
                if let placemark = placemarks?.last {
                    self?.delegate?.setCity(placemark.locality ?? "")
                }
            }
        }
    }
    
}

extension LocationService: LocationServiceInput {
    
    func updateCity() {
        updateCity(location: nil)
    }
    
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        delegate?.setCoordinates(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude)
        updateCity(location: location)
    }
    
}
