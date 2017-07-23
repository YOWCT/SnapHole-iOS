//
//  SizeViewController.swift
//  SnapHole
//
//  Created by Thomas Devisscher on 2017-03-27.
//  Copyright © 2017 Thomas Devisscher. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class SizeViewController: UIViewController {
    
    @IBOutlet weak var uuidLabel: UILabel!
    var uuid = String()
    let API_ENDPOINT = "https://ott311.esdev.xyz"
    override func viewDidLoad() {
        self.uuidLabel.text = uuid
        
    }
    override func didReceiveMemoryWarning() {
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let DestViewController: DetailsViewController = segue.destination as! DetailsViewController
        DestViewController.uuid = uuid
    }
    
    @IBAction func largeButton(_ sender: UIButton) {
        specifySize(size: "large")
        self.performSegue(withIdentifier: "toDetailsView", sender: nil)
    }
    
    @IBAction func mediumButton(_ sender: UIButton) {
        specifySize(size: "medium")
        self.performSegue(withIdentifier: "toDetailsView", sender: nil)
    }
    
    @IBAction func smallButton(_ sender: UIButton) {
        specifySize(size: "small")
        self.performSegue(withIdentifier: "toDetailsView", sender: nil)
    }
    
    func specifySize(size: String){
        let parameters = ["uuid": self.uuid, "size": size] as [String : Any]
        Alamofire.request("\(API_ENDPOINT)/size", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseString { response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                case .failure(let error):
                    print(error)
                }
                print(response)
                
        }
    }
    
}


