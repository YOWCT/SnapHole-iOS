//
//  ExtensionTester.swift
//  SnapHole
//
//  Created by Thomas Devisscher on 2017-06-15.
//  Copyright © 2017 Thomas Devisscher. All rights reserved.
//

import UIKit

class ExtensionTester: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
        updateUserInterface()
    }
    func updateUserInterface() {
        guard let status = Network.reachability?.status else { return }
        switch status {
        case .unreachable:
            view.backgroundColor = .red
        case .wifi:
            view.backgroundColor = .green
        case .wwan:
            view.backgroundColor = .yellow
        }
        print("Reachability Summary")
        print("Status:", status)
        print("HostName:", Network.reachability?.hostname ?? "nil")
        print("Reachable:", Network.reachability?.isReachable ?? "nil")
        print("Wifi:", Network.reachability?.isReachableViaWiFi ?? "nil")
    }
    func statusManager(_ notification: NSNotification) {
        updateUserInterface()
    }
}
