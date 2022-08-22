//
//  LocationModel.swift
//  Prototype002 WatchKit Extension
//
//  Created by Dave Duprey on 14/10/2019.
//  Copyright © 2019 Dave Duprey. All rights reserved.
//

import Foundation
import CoreLocation


/// status of the W3WGps object
public enum GpsStatus {
  case active       // system is recieving GPS coordinates
  case unavailable  // temporary issues getting coordinates
  case error        // no GPS is available
}


/// Holds location and hearding along with accuracy values
public struct GpsInfo {
  
  /// the device's heading
  public var heading: Double?
  
  /// accuracy of the device heading in degrees
  public var headdingAccuracy: Double?
  
  /// the current location
  public var location: CLLocationCoordinate2D?
  
  /// the accuracy of the current location in meters
  public var accuracy: Double?
  
}


/// Keeps track of the devices current location, and heading, and provides some calculatios such as distance
public class Gps: NSObject, CLLocationManagerDelegate {
  
  // MARK: Member Variables
  
  /// the current location and heading and such
  public var info = GpsInfo()
  
  /// app's authorization for user's location
  public var status: GpsStatus = .unavailable
  
  /// CoreLocation interface
  private let locationManager: CLLocationManager
  
  /// location update callback
  public var onUpdate: ((GpsInfo) -> ())?
  
  /// called when there is a change in the GPS status
  public var onStatusUpdate:((GpsStatus) -> ())?
  
  
  // MARK: Initialization
  
  
  public override init() {
    self.locationManager = CLLocationManager()
    
    super.init()
    
    self.locationManager.delegate = self
    self.setup()
  }
  
  
  /// Setup and start the location services
  private func setup() {
    //self.locationManager.requestWhenInUseAuthorization()
    self.askUserForGpsAccess()
    
    if #available(watchOS 3.0, *) {
      self.locationManager.startUpdatingLocation()
    }
    
    if compassExists() {
      self.locationManager.startUpdatingHeading()
    }
  }
  
  
  /// asks the user permission to use the GPS
  public func askUserForGpsAccess() {
    self.locationManager.requestWhenInUseAuthorization()
  }
  
  
  
  // MARK: Accessors
  
  public func compassExists() -> Bool {
    return CLLocationManager.headingAvailable()
  }
  
  
  // MARK: Distance Calculations
  
  /// Calculate the distance between the current location and a provided location - takes into account the spherical coordinates of the planet
  /// - Parameters:
  ///     - to: the distance to measure to
  public func distance(to:CLLocationCoordinate2D?) -> Double? {
    
    var distance:Double?
    
    if let lat1 = info.location?.latitude, let lon1 = info.location?.longitude, let lat2 = to?.latitude, let lon2 = to?.longitude {
      
      let lat1rad = lat1 * Double.pi/180
      let lon1rad = lon1 * Double.pi/180
      let lat2rad = lat2 * Double.pi/180
      let lon2rad = lon2 * Double.pi/180
      
      let dLat = lat2rad - lat1rad
      let dLon = lon2rad - lon1rad
      let a = sin(dLat/2) * sin(dLat/2) + sin(dLon/2) * sin(dLon/2) * cos(lat1rad) * cos(lat2rad)
      let c = 2 * asin(sqrt(a))
      let R = 6000.0
      
      distance = R * c
    }
    
    return distance
  }
  
  
  
  // MARK:  CoreLocation functions
  
  /// CoreLocation callback when location is updated
  public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let currentLocation = locations.last {
      info.location = currentLocation.coordinate
      info.accuracy = currentLocation.horizontalAccuracy
      onUpdate?(info)
    }
  }
  
  
  /// CoreLocations callback when the heading has changed, we update the heading and headingAccuracy, which should then update SwiftUI views via Combine
  public func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    info.heading = newHeading.trueHeading / -360.0 * 2.0 * .pi  // convert from degrees to radians, and invert since the device orientation is the opposite of the world direction it's pointed
    info.headdingAccuracy = newHeading.headingAccuracy
    onUpdate?(info)
  }
  
  
  private func update(status: GpsStatus) {
    self.status = status
    onStatusUpdate?(self.status)
  }
  
  
  /// CoreLocation callback when the user's authorization changes
  public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    
    switch status {
    case .authorizedAlways:
      update(status: .active)
      
    case .authorizedWhenInUse:
      update(status: .active)
      
    case .denied:
      update(status: .error)
      
    case .notDetermined:
      update(status: .unavailable)
      askUserForGpsAccess()
      
    case .restricted:
      update(status: .error)
      
    default:
      print("unknown gps status, ignoring")
    }
    
    print(#function, status)
  }
  
  
  /// CoreLocation callback for errors, we just print them to stdout for now
  public func locationManager(_ manager: CLLocationManager, didFailWithError error: Swift.Error) {
    
    if let clErr = error as? CLError {
      switch clErr {
      case CLError.locationUnknown:   // Temporary issue, system will tr again, no need to report as error A constant that indicates the location manager was unable to obtain a location value right now.
        update(status: .unavailable)
      case CLError.denied:           // A constant that indicates the user denied access to the location service.
        update(status: .error)
      default:
        print(#function, "other Core Location issue")
      }
      
    } else {
      print(#function, "other error:", error.localizedDescription)
    }
  }
  
  
}


