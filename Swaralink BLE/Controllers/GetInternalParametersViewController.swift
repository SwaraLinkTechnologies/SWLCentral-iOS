//
//  GetInternalParametersViewController.swift
//  Swaralink BLE
//
//  Created by Dushyant Varshney on 07/02/22.
//

import UIKit

class GetInternalParametersViewController: UIViewController,SWLConnectionWrapperDelegate {
    func knownDeviceListReceived(_ devices: [[String : Any]]) {
        
    }
    
    func internalDeviceParametersReceived(_ parameters: [String : Any]) {

    }

    var swlConection =  SWLConnection.shared
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swlConection.swlConnectionWrapperDelegate = self
        StaticHelper.shared.addLogViewController(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true
        )
    }
    @IBAction func getInternalParameterAction(_ sender: UIButton) {

        swlConection.getInternalParameters()
    }
    

    func fetchPeripheralStatus(status: String, func_description: String?) {

        StaticHelper.shared.logControllerVC.functiondescription = func_description ?? ""
        StaticHelper.shared.logControllerVC.currentStatusLabel = status
    }
}
