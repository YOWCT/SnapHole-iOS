//
//  ExtensionTester.swift
//  SnapHole
//
//  Created by Thomas Devisscher on 2017-06-15.
//  Copyright © 2017 Thomas Devisscher. All rights reserved.
//

import UIKit

class ExtensionTester: UIViewController, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var networkStatusLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
        
        
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let toViewController: ViewController = segue.destination as! ViewController
//    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        updateUserInterface()
        
    }
    
    func updateUserInterface() {
        guard let status = Network.reachability?.status else { return }
        switch status {
        case .unreachable:
            view.backgroundColor = .red
            // show unreachable screen
            networkStatusLabel.text = "This app requires network connectivity."
        case .wifi:
            view.backgroundColor = .green
            networkStatusLabel.text = "Network available. (wifi)"
            self.performSegue(withIdentifier: "toViewControllerSecond", sender: self)
            // segue to login/register screen
        case .wwan:
            networkStatusLabel.text = "Network available. (3g/LTE)"
            view.backgroundColor = .yellow
        }
        print("Reachability Summary")
        print("Status:", status)
        print("HostName:", Network.reachability?.hostname ?? "nil")
        print("Reachable:", Network.reachability?.isReachable ?? "nil")
        print("Wifi:", Network.reachability?.isReachableViaWiFi ?? "nil")
    }
    @objc func statusManager(_ notification: NSNotification) {
        updateUserInterface()
    }
}
