//
// File: SendReceiveViewController.swift
// Copyright (c) 2021, SwaraLink Technologies
// All Rights Reserved
// Licensed by SwaraLink Technologies, subject to terms of Software License Agreement

import UIKit
import CoreBluetooth
//import SWLCentral

class SendReceiveViewController: UIViewController,UNUserNotificationCenterDelegate {
 
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var headLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var sendDataLabel: UILabel!
    @IBOutlet weak var ackTransferLabel: UILabel!
    @IBOutlet weak var noLabel: UILabel!
    @IBOutlet weak var yesLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var centralStatus: UILabel!
    @IBOutlet weak var connectionInfoLabel: UILabel!
    @IBOutlet weak var receivedPacketsLAbel: UILabel!
    @IBOutlet weak var idHeaderLabel: UILabel!
    @IBOutlet weak var ackLabel: UILabel!
    @IBOutlet weak var minPacketLabel: UILabel!
    @IBOutlet weak var majPacketLabel: UILabel!
    @IBOutlet weak var payloadPacketLabel: UILabel!
    
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!

    @IBOutlet weak var yesImageView: UIImageView!
    @IBOutlet weak var noImageView: UIImageView!
    
    @IBOutlet weak var dataTextView: UITextView!
    @IBOutlet weak var minHeaderTextField: UITextField!
    @IBOutlet weak var majorHeaderTextField: UITextField!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var idHeaderBkView: UIView!
   
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var yesBackView: UIView!
    @IBOutlet weak var noBackView: UIView!
    
    var packetsArray = [Data](){
        didSet{
        }
    }
    
    var receivedPackets = String()
    var peripheralString = ""
    
    var isAckEnabled = Bool(){
        
        didSet{
            if isAckEnabled{
                yesImageView.image = UIImage.init(named: "radio_btn_selected")
                noImageView.image = UIImage.init(named: "radio_btn_unselected")
            }
            else{
                noImageView.image = UIImage.init(named: "radio_btn_selected")
                yesImageView.image = UIImage.init(named: "radio_btn_unselected")
            }
        }
    }
   
    var isFromInternalData = false
    
    
    var swlConection =  SWLConnection.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StaticHelper.shared.addLogViewController(self)
        receivedPacketsLAbel.isHidden = true
        idHeaderBkView.isHidden = true
        bottomView.isHidden = true
        self.setupUI()
        isAckEnabled  = false
        descriptionLabel.attributedText = SWLConstants().send_data_desc.getFunctionDescription()
        if isFromInternalData{
            self.ackTransferLabel.isHidden = true
            self.yesBackView.isHidden = true
            self.noBackView.isHidden = true
            descriptionLabel.text = ""
            descriptionLabel.isHidden = true
        }
        self.setDoneOnKeyboard()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }

    func setupUI(){

        bottomView.layer.cornerRadius = 10.0 * (UIScreen.main.bounds.height/568)
        bottomView.layer.borderWidth = 2.0
        bottomView.layer.borderColor = UIColor.lightGray.cgColor

        idHeaderBkView.layer.cornerRadius = 10.0 * (UIScreen.main.bounds.height/568)
        idHeaderBkView.layer.borderWidth = 2.0
        idHeaderBkView.layer.borderColor = UIColor.lightGray.cgColor


    }

    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func sendAction(_ sender: UIButton) {
        
        let dataString = (self.dataTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines)) ?? ""
        let minheader = (self.minHeaderTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        let majorHeader = (self.majorHeaderTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!

        
        if isFromInternalData{
            
            if minheader.isEmpty{

                let alert = UIAlertController.init(title: "", message: "Please enter min header.", preferredStyle: .alert)
                let action = UIAlertAction.init(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            else if majorHeader.isEmpty{

                let alert = UIAlertController.init(title: "", message: "Please enter major header.", preferredStyle: .alert)
                let action = UIAlertAction.init(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            else if !majorHeader.isHexNumber{
                let alert = UIAlertController.init(title: "", message: "Please enter valid major header value.", preferredStyle: .alert)
                let action = UIAlertAction.init(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            else if !minheader.isHexNumber == nil{
                let alert = UIAlertController.init(title: "", message: "Please enter valid min header value.", preferredStyle: .alert)
                let action = UIAlertAction.init(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }

            else if (!dataString.isEmpty && !dataString.isHexNumber){
                let alert = UIAlertController.init(title: "", message: "Please enter valid data value.", preferredStyle: .alert)
                let action = UIAlertAction.init(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            else{
               
                swlConection.sendInternalData(majorHeader, minheader, data: dataString)
            }
        }
        else{
            
            if minheader.isEmpty{

                let alert = UIAlertController.init(title: "", message: "Please enter min header.", preferredStyle: .alert)
                let action = UIAlertAction.init(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            else if majorHeader.isEmpty{

                let alert = UIAlertController.init(title: "", message: "Please enter major header.", preferredStyle: .alert)
                let action = UIAlertAction.init(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            else if dataString.isEmpty{

                let alert = UIAlertController.init(title: "", message: "Please enter data.", preferredStyle: .alert)
                let action = UIAlertAction.init(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
             }
            else if !majorHeader.isHexNumber{
                let alert = UIAlertController.init(title: "", message: "Please enter valid major header value.", preferredStyle: .alert)
                let action = UIAlertAction.init(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            else if  !minheader.isHexNumber{
                let alert = UIAlertController.init(title: "", message: "Please enter valid min header value.", preferredStyle: .alert)
                let action = UIAlertAction.init(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
         
            else if (!dataString.isHexNumber){
                let alert = UIAlertController.init(title: "", message: "Please enter valid data value.", preferredStyle: .alert)
                let action = UIAlertAction.init(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            else{

                swlConection.sendData(majorHeader, minheader, data: dataString, isAcknowledged: isAckEnabled)
            }
        }
        

        self.view.endEditing(true)
    }

    @IBAction func yesAction(_ sender: UIButton) {
         isAckEnabled = true
    }

    @IBAction func noAction(_ sender: UIButton) {
         isAckEnabled = false
    }
    
    func setDoneOnKeyboard() {
        
        let keyboardToolbar = UIToolbar()
        
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        self.dataTextView.inputAccessoryView = keyboardToolbar
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension SendReceiveViewController: UITextFieldDelegate{

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == minHeaderTextField || textField == majorHeaderTextField{
            
            let maxLength = 2
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        else{
            return true
        }
    }
}

extension SendReceiveViewController: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return packetsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceivedPacketsTableViewCell", for: indexPath) as! ReceivedPacketsTableViewCell
        let indvPAcket  =  "No"//(packetsArray[indexPath.row][0] == 0 ? "No":"Yes")
        cell.ackLabel.text  = indvPAcket
        cell.minLabel.text =  String(format: "0x%02X", packetsArray[indexPath.row][1])
        cell.maxLabel.text =  String(format: "0x%02X", packetsArray[indexPath.row][0])
        cell.viewButton.tag = indexPath.row
        cell.viewButton.addTarget(self, action: #selector(viewAction(_:)), for: .touchUpInside)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25.0
    }

    @objc func viewAction(_ selector: UIButton){
        let id = selector.tag
        var dt = packetsArray[id]
        dt.removeFirst(2)

        let alert = UIAlertController.init(title: "Packet Info", message: dt.hexEncodedString(), preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension String {
    var isHexNumber: Bool {
        filter(\.isHexDigit).count == count
    }
}
