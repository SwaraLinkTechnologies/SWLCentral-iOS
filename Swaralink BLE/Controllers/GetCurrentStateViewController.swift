//
//  GetCurrentStateViewController.swift
//  Swaralink BLE
//
//  Created by Dushyant Varshney on 31/08/22.
//

import UIKit

class GetCurrentStateViewController: UIViewController {

    var swlConection =  SWLConnection.shared
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StaticHelper.shared.addLogViewController(self)
        descriptionLabel.text = ""
//        descriptionLabel.attributedText = SWLConstants().diagnosticLog.getFunctionDescription()
    }
  
    
    @IBAction func backAction(_ sender: Any) {
       
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func getCurrentStateAction(_ sender: UIButton) {
        
        swlConection.getCurrentState()
    }
}
