//
// File: AboutViewController.swift
// Copyright (c) 2021, SwaraLink Technologies
// All Rights Reserved
// Licensed by SwaraLink Technologies, subject to terms of Software License Agreement

import UIKit
//import SWLCentral

class AboutViewController: UIViewController {

    @IBOutlet weak var backButton: UIView!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var logoImGview: UIImageView!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var moreInfoLabel: UILabel!
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var pleaseWaitLabel: UILabel!
    @IBOutlet weak var serviceUUIDLabel: UILabel!
    @IBOutlet weak var serviceUUIDInfoLAbel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        versionLabel.text = "v " + appVersion! + "\n" + "30-Sep-2022"
   //     serviceUUIDInfoLAbel.text = swaralinkServicesUDID.uuidString
        serviceUUIDLabel.isHidden = true
        serviceUUIDInfoLAbel.isHidden = true
    }

    @IBAction func backAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
}
