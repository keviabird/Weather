
import Foundation
import CoreLocation

class LocationService: NSObject {

    var locationManager: CLLocationManager?
    var model: Model!
    
    init(model: Model) {
        super.init()
        self.model = model
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    }
    
    func startService() {
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
        updateCity()
    }
    
    func updateCity(location: CLLocation? = nil) {
        if let location = location ?? locationManager?.location {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location, preferredLocale: Locale(identifier: model.getSettings().language.rawValue)) { [weak self] (placemarks, error) in
                if let placemark = placemarks?.last {
                    self?.model.setCity(placemark.locality ?? "")
                }
            }
        }
    }
    
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        model.setCoordinates(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude)
        updateCity(location: location)
    }
    
}
