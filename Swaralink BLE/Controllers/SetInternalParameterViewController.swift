//
//  SetInternalParameterViewController.swift
//  Swaralink BLE
//
//  Created by Dushyant Varshney on 27/01/22.
//

import UIKit

class SetInternalParameterViewController: UIViewController,SWLConnectionWrapperDelegate {
    func knownDeviceListReceived(_ devices: [[String : Any]]) {
        
    }
    
    func internalDeviceParametersReceived(_ parameters: [String : Any]) {
        self.savedDeviceParams = parameters
    }
    

    @IBOutlet weak var serviceUUidLabel: UILabel!
    @IBOutlet weak var characteristicsUUIDLabel: UILabel!
    @IBOutlet weak var companyIdentifierLabel: UILabel!
    
    @IBOutlet weak var serviceUUIDTextField: UITextField!
    @IBOutlet weak var characteristicsUUIDTextField: UITextField!
    @IBOutlet weak var companyIdentifierTextField: UITextField!
    
    @IBOutlet weak var saveInfoButton: UIButton!
    
    @IBOutlet weak var baseServiceUUIDLabel: UILabel!
    @IBOutlet weak var baseCharacteristicsUUIDLabel: UILabel!
    @IBOutlet weak var basecompanyIdentifierLabel: UILabel!

    var swlConection =  SWLConnection.shared
    
    var savedDeviceParams = [String: Any](){
        didSet{
            basecompanyIdentifierLabel.text = "CURRENT: " + ((savedDeviceParams["PeripheralCompanyIdentifier"] as? String) ?? "")
            baseServiceUUIDLabel.text = "CURRENT: " + ((savedDeviceParams["PeripheralServiceUUID"] as? String ) ?? "")
            baseCharacteristicsUUIDLabel.text = "CURRENT: " + ((savedDeviceParams["PeripheralBaseCharacteristicUUID"]  as? String) ?? "")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swlConection.swlConnectionWrapperDelegate = self
        StaticHelper.shared.addLogViewController(self)
        self.navigationController?.isNavigationBarHidden = true

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        swlConection.getInternalParameters()
    }
    
    @IBAction func restoreDefaultAction(_ sender: UIButton) {
        
        self.serviceUUIDTextField.text = swlConection.connectionManager.defaultSwaralinkUUID
        self.characteristicsUUIDTextField.text = swlConection.connectionManager.defaultCharacteristicsUUId
        self.companyIdentifierTextField.text = swlConection.connectionManager.defaultCompanyIdentifier
    }
    
    @IBAction func backAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveInfoAction(_ sender: UIButton) {
        
        let serviceUUID = serviceUUIDTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let characteristicsUUID = characteristicsUUIDTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let companyIdentifier = companyIdentifierTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if serviceUUID!.isEmpty,characteristicsUUID!.isEmpty,companyIdentifier!.isEmpty{
          
            let alert = UIAlertController.init(title: "", message: "Please updated atleast one parameter.", preferredStyle: .alert)
            let action = UIAlertAction.init(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        else{
            
            swlConection.setInternalParameters(peripheralServiceUUID: serviceUUID!.uppercased(), peripheralBaseCharacteristicUUID: characteristicsUUID!.uppercased(), peripheralCompanyIdentifier: companyIdentifier!.uppercased())
            
            let alert = UIAlertController.init(title: "", message: "Parameters Updated.", preferredStyle: .alert)
            let action = UIAlertAction.init(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
      
    }
}

extension SetInternalParameterViewController: UITextFieldDelegate{

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
               let isBackSpace = strcmp(char, "\\b")
               if (isBackSpace == -92) {
                   return true
               }
           }
        if textField.text?.count == 8 || textField.text?.count == 13 || textField.text?.count == 18 || textField.text?.count == 23{
            textField.text? = textField.text! + "-"
        }
        return (string.containsValidCharacter)
    }
}

extension String {

    var containsValidCharacter: Bool {
        guard self != "" else { return true }
        let hexSet = CharacterSet(charactersIn: "1234567890ABCDEFabcdef-")
        let newSet = CharacterSet(charactersIn: self)
        return hexSet.isSuperset(of: newSet)
      }
}
