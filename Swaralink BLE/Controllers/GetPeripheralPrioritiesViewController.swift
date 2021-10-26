//
//  GetPeripheralPrioritiesViewController.swift
//  Swaralink BLE
//
//  Created by Dushyant Varshney on 04/07/22.
//

import UIKit

class GetPeripheralPrioritiesViewController: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    var swlConection =  SWLConnection.shared
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLabel.attributedText = SWLConstants().getPeripheralPrioritesDesc.getFunctionDescription()
        StaticHelper.shared.addLogViewController(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clearAction(_ sender: UIButton) {
        swlConection.getPeripheralPriorities()
    }
}
