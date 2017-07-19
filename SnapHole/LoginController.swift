//
//  LoginController.swift
//  SnapHole
//
//  Created by Thomas Devisscher on 2017-06-27.
//  Copyright © 2017 Thomas Devisscher. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class LoginController: UIViewController {
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var first_nameTxt: UITextField!
    @IBOutlet weak var last_nameTxt: UITextField!
    @IBAction func sendLink(_ sender: Any) {
        initiateLoginProcedure()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let DestViewController: ViewController = segue.destination as! ViewController
//        }
    
    
    func initiateLoginProcedure(){
        let parameters = ["email": emailTxt.text, "first_name": first_nameTxt.text, "last_name":last_nameTxt.text]
        
        Alamofire.request("https://ott311.esdev.xyz/users/register", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("success")
                case .failure(let error):
                    print(error)
                }
                print(response)
                
        }
    }
}
