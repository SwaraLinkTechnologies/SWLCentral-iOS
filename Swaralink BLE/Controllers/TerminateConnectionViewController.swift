//
//  TerminateConnectionViewController.swift
//  Swaralink BLE
//
//  Created by Dushyant Varshney on 03/01/22.
//

import UIKit

class TerminateConnectionViewController: UIViewController   {


    var swlConection =  SWLConnection.shared
    
    @IBOutlet weak var descriptionLabel: UILabel!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionLabel.attributedText = SWLConstants().terminate_conn_desc.getFunctionDescription()
        StaticHelper.shared.addLogViewController(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true
        )
    }
    
    @IBAction func terminateAction(_ sender: UIButton) {
        swlConection.terminateConnection()
    }
    


}
