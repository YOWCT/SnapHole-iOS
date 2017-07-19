//
//  DetailsViewController.swift
//  SnapHole
//
//  Created by Thomas Devisscher on 2017-03-27.
//  Copyright © 2017 Thomas Devisscher. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit
import Alamofire

class DetailsViewController: UIViewController, CLLocationManagerDelegate  {
    // Map view
    var uuid = String()
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var uuidLabel: UILabel!
    
    let manager = CLLocationManager()
    //service_code:2000164-2
    @IBOutlet weak var service_request_id_Label: UILabel!
    //attribute[cmb_councillorcheckbox]:Yes_No.Yes
    //lat:45.35432785
    //long:-75.78771586
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        map.setRegion(region, animated:true)
        self.map.showsUserLocation = true
        self.longitudeLabel.text = "Longitude: \(location.coordinate.longitude)"
        self.latitudeLabel.text = "Latitude: \(location.coordinate.latitude)"
        self.uuidLabel.text = uuid
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        getSrRequestId()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func getSrRequestId(){
        Alamofire.request("https://ott311.esdev.xyz/sr/\(uuid)").responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                self.service_request_id_Label.text = "\(JSON)"
            }
        }
    }
}
