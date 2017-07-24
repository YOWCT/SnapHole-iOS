//
//  ViewController.swift
//  SnapHole
//
//  Created by Thomas Devisscher on 2017-03-19.
//  Copyright © 2017 Thomas Devisscher. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import MapKit
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,

CLLocationManagerDelegate  {
    let API_ENDPOINT = "https://ott311.esdev.xyz"
    // This uuid should be passed on through all screens
    var uuid = UUID().uuidString
    var lat = String()
    // Picked image
    @IBOutlet weak var uuidLabel: UILabel!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var longLabel: UILabel!
    
    
    @IBOutlet weak var pickedImage: UIImageView!
    let manager = CLLocationManager()
    let bundleIdentifier = Bundle.main.bundleIdentifier
    
    //service_code:2000164-2
    //attribute[cmb_councillorcheckbox]:Yes_No.Yes
    //lat:45.35432785
    //long:-75.78771586
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        //let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        self.uuidLabel.text = uuid
        self.latLabel.text = "\(location.coordinate.latitude)"
        self.longLabel.text = "\(location.coordinate.longitude)"
        print(bundleIdentifier)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.uuidLabel.text = uuid
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let DestViewController: tableSizeViewController = segue.destination as! tableSizeViewController
        DestViewController.uuid = uuid
    }

    @IBAction func cameraButtonAction(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker,animated: true, completion: nil)
        }
    }
    @IBAction func saveAction(_ sender: UIButton) {
        let imageData = UIImageJPEGRepresentation(pickedImage.image!, 0.6)
        let compressedJPEGImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedJPEGImage!, nil, nil, nil)
        initiateUpload()
        //uploadImage()
        
        self.performSegue(withIdentifier: "toSizeView", sender: nil)
        // Show confirmation Screen
        
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject: AnyObject]!) {
        pickedImage.image = image 
        self.dismiss(animated: true, completion: nil);
    }
    
    func initiateUpload(){
        let parameters = ["uuid": self.uuid, "lat": latLabel.text ?? "45", "long":longLabel.text ?? "75"]
        Alamofire.request("\(API_ENDPOINT)/sr_information", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseString { response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                    self.uploadImage()
                case .failure(let error):
                    print(error)
                }
                print(response)
               
        }
    }
   
    func uploadImage(){
        Alamofire.upload(multipartFormData: { (multipartFormData) in
        multipartFormData.append(UIImageJPEGRepresentation(self.pickedImage.image!, 0.5)!, withName: "userPhoto", fileName: self.uuid, mimeType: "image/jpeg")
        
    }, to:"\(API_ENDPOINT)/sr")
    { (result) in
    switch result {
            case .success(let upload, _, _):
    
            upload.uploadProgress(closure: { (progress) in
                //Print progress
            })
    
            upload.responseString { response in
                //print response.result
            }
            case .failure(let _): break
                // self.delegate?.showFailAlert()
                // print(encodingError)

            }
        }
    }
}

