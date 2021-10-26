//
//  DiagnosisViewController.swift
// Copyright (c) 2021, SwaraLink Technologies
// All Rights Reserved
// Licensed by SwaraLink Technologies, subject to terms of Software License Agreement

import UIKit

class DiagnosticLogViewController: UIViewController {

    var swlConection =  SWLConnection.shared
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StaticHelper.shared.addLogViewController(self)
        descriptionLabel.attributedText = SWLConstants().diagnosticLog.getFunctionDescription()
    }
  
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true
        )
    }
    @IBAction func requestDiagnosticLogsAction(_ sender: UIButton) {
        
        swlConection.requestDiagnosticLogs()
    }
}
