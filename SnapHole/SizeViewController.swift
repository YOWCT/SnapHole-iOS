//
//  SizeViewController.swift
//  SnapHole
//
//  Created by Thomas Devisscher on 2017-03-27.
//  Copyright © 2017 Thomas Devisscher. All rights reserved.
//

import Foundation
import UIKit

class SizeViewController: UIViewController {
    
    @IBOutlet weak var uuidLabel: UILabel!
    var uuid = String()
    
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
        self.performSegue(withIdentifier: "toDetailsView", sender: nil)
    }
    
    @IBAction func mediumButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toDetailsView", sender: nil)
    }
    
    @IBAction func smallButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toDetailsView", sender: nil)
    }
}


