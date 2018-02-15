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
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,

CLLocationManagerDelegate  {
    let API_ENDPOINT = "https://ott311.esdev.xyz"
    // This uuid should be passed on through all screens
    var uuid = UUID().uuidString
    var lat = String()
    var long = String()
    
    let captureSession = AVCaptureSession()
    let stillImageOutput = AVCaptureStillImageOutput()
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    var captureDevice : AVCaptureDevice?
    
    @IBOutlet weak var pickedImage: UIImageView!
    let manager = CLLocationManager()
    let bundleIdentifier = Bundle.main.bundleIdentifier
    
    //service_code:2000164-2
    //attribute[cmb_councillorcheckbox]:Yes_No.Yes
    //lat:45.35432785
    //long:-75.78771586
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let _:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let _:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        //let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        lat = "\(location.coordinate.latitude)"
        long = "\(location.coordinate.longitude)"
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        captureSession.sessionPreset = AVCaptureSession.Preset.high
    
        if let cameraID = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.front).devices.first?.localizedName{
            print(cameraID)
            beginSession()
        }
//        if let devices = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back){
//            // Loop through all the capture devices on this phone
//            for device in devices {
//                // Make sure this particular device supports video
//                if (device.hasMediaType(AVMediaType.video)) {
//                    // Finally check the position and confirm we've got the back camera
//                    if(device.position == AVCaptureDevice.Position.back) {
//                        captureDevice = device
//                        if captureDevice != nil {
//                            print("Capture device found")
//                            beginSession()
//                        }
//                    }
//                }
//            }
//        }
    }
    
    func beginSession() {

        do {
            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice!))
            stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]

            if captureSession.canAddOutput(stillImageOutput) {
                captureSession.addOutput(stillImageOutput)
            }

        }
        catch {
            print("error: \(error.localizedDescription)")
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) 
        // this is what displays the camera view. But - it's on TOP of the drawn view, and under the overview. ??
        self.view.layer.addSublayer(previewLayer)
        previewLayer.frame = self.view.layer.frame


        pickedImage.frame = self.view.frame
        //pickedImage.image = self.drawCirclesOnImage(fromImage: nil, targetSize: pickedImage.bounds.size)

        //self.view.bringSubview(toFront: navigationBar)
        self.view.bringSubview(toFront: pickedImage)
       // self.view.bringSubview(toFront: btnCapture)
        // don't use shapeLayer anymore...
        //      self.view.bringSubview(toFront: shapeLayer)


        captureSession.startRunning()
        print("Capture session running")

    }
    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: size.width, height: size.height))
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        let parameters = ["uuid": self.uuid, "lat": lat , "long": long]
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
    case .failure( _): break
                // self.delegate?.showFailAlert()
                // print(encodingError)

            }
        }
    }
}

