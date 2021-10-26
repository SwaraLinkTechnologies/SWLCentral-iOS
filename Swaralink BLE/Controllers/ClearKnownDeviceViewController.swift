//
//  ClearKnownDeviceViewController.swift
//  Swaralink BLE
//
//  Created by Dushyant Varshney on 03/01/22.
//

import UIKit

class ClearKnownDeviceViewController: UIViewController {


    @IBOutlet weak var descriptionLabel: UILabel!
    var swlConection =  SWLConnection.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        

        descriptionLabel.attributedText = SWLConstants().clear_kdl_desc.getFunctionDescription()
        StaticHelper.shared.addLogViewController(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true
        )
    }
    @IBAction func clearAction(_ sender: UIButton) {

        swlConection.clearKnownDeviceList()
    }
}

extension String{
    
    func getFunctionDescription() -> NSAttributedString{
        let stringAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12.0)
                               ]
        
        let normalStringAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0)
                               ]
        let combination = NSMutableAttributedString()
        let min = NSMutableAttributedString(string: "Description:", attributes: stringAttributes)
        let minData = NSMutableAttributedString.init(string: self, attributes: normalStringAttributes)
        combination.append(min)
        combination.append(minData)
        return combination
    }
}
