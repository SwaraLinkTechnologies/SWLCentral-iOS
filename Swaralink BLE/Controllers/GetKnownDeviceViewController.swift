//
//  GetKnownDeviceViewController.swift
//  Swaralink BLE
//
//  Created by Dushyant Varshney on 04/01/22.
//

import UIKit

class GetKnownDeviceViewController: UIViewController,SWLConnectionWrapperDelegate {
    func internalDeviceParametersReceived(_ parameters: [String : Any]) {
        
    }
    

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var swlConection =  SWLConnection.shared
    
    func knownDeviceListReceived(_ devices: [[String : Any]]) {

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLabel.attributedText = SWLConstants().known_device_list.getFunctionDescription()
        StaticHelper.shared.addLogViewController(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

    }
    
    @IBAction func backAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func getDeviceListAction(_ sender: UIButton) {
     

        swlConection.swlConnectionWrapperDelegate = self
        swlConection.getKnownDeviceList()
    }
}
