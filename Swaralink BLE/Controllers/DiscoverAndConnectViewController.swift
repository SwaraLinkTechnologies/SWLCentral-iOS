//
// File: DiscoverAndConnectViewController.swift
// Copyright (c) 2021, SwaraLink Technologies
// All Rights Reserved
// Licensed by SwaraLink Technologies, subject to terms of Software License Agreement

import UIKit
import CoreBluetooth

class DiscoverAndConnectViewController: UIViewController,SWLConnectionWrapperDelegate {
    func internalDeviceParametersReceived(_ parameters: [String : Any]) {
        
    }

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var firstDiscoveredBkView: UIView!
    @IBOutlet weak var knownDeviceBkView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var specificDeviceBkView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var firstDeviceButton: UIButton!
    @IBOutlet weak var specificDeviceButton: UIButton!
    @IBOutlet weak var beginButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var firstDeviceLabel: UILabel!
    @IBOutlet weak var specificDeviceLabel: UILabel!
    @IBOutlet weak var knownDeviceLabel: UILabel!
    @IBOutlet weak var centralStatus: UILabel!
    @IBOutlet weak var connectionInfoLabel: UILabel!
    @IBOutlet weak var firstDeviceImgView: UIImageView!
    @IBOutlet weak var specificDeviceImgView: UIImageView!
    @IBOutlet weak var knownDeviceTableView: UITableView!

    var selectedDeviceIndex = -1
    var isAutoConnectEnabled = false
    var currentStateString = ""
   
    var nearByPeripheralDevice = [CBPeripheral](){
        didSet{
            self.knownDeviceTableView.reloadData()
        }
    }
    var currentDevicePairID = "-1"
    var knownDeviceList = [[String: Any]](){
        didSet{
            self.knownDeviceTableView.reloadData()
        }
    }
    
    var swlConection =  SWLConnection.shared
    
    @IBOutlet weak var timeoutTextField: UITextField!
    func knownDeviceListReceived(_ devices: [[String : Any]]) {
        self.knownDeviceList = devices
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        swlConection.swlConnectionWrapperDelegate = self
        StaticHelper.shared.addLogViewController(self)
        bottomView.isHidden = true
        isAutoConnectEnabled = false
        firstDeviceImgView.image =  UIImage.init(named: "radio_btn_unselected")
        specificDeviceImgView.image = UIImage.init(named: "radio_btn_selected")
        knownDeviceBkView.isHidden = false
        nearByPeripheralDevice.removeAll()
        descriptionLabel.attributedText = SWLConstants().disc_conn_desc.getFunctionDescription()
        swlConection.getKnownDeviceList()
        setupUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        nearByPeripheralDevice.removeAll()
    }
    
    func setupUI(){
        
        beginButton.layer.cornerRadius = 10.0 * (UIScreen.main.bounds.height/568)
        cancelButton.layer.cornerRadius = 10.0 * (UIScreen.main.bounds.height/568)
        bottomView.layer.cornerRadius = 10.0 * (UIScreen.main.bounds.height/568)
        cancelButton.layer.borderWidth = 2.0
        bottomView.layer.borderWidth = 2.0
        knownDeviceTableView.layer.borderWidth = 2.0
        cancelButton.layer.borderColor = UIColor.init(named: "ThemeColor")!.cgColor
        bottomView.layer.borderColor = UIColor.lightGray.cgColor
        knownDeviceTableView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func beginAcceptAction(_ sender: UIButton) {
        self.view.endEditing(true)
        

        if isAutoConnectEnabled{
            var timerValue : Int? = nil
            if let timeoutValue = timeoutTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines){
                timerValue = Int(timeoutValue)
            }

            SWLConnection.shared.discoverAndConnect(nil, timeout: timerValue)
        }
        else{
            
            if selectedDeviceIndex == -1{
                return
            }
            
            var timerValue : Int? = nil
            if let timeoutValue = timeoutTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines){
                timerValue = Int(timeoutValue)
            }

            SWLConnection.shared.discoverAndConnect("\(knownDeviceList[selectedDeviceIndex]["identifier"] ?? "(Unnamed)")", timeout: timerValue)
        }
        
    
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {

    }
    
    @IBAction func firstDeviceAction(_ sender: UIButton) {
        
        isAutoConnectEnabled = true
        firstDeviceImgView.image =  UIImage.init(named: "radio_btn_selected")
        specificDeviceImgView.image =  UIImage.init(named: "radio_btn_unselected")
        knownDeviceBkView.isHidden = true
    }
    
    @IBAction func specificDeviceAction(_ sender: UIButton) {
        
        isAutoConnectEnabled = false
        firstDeviceImgView.image =  UIImage.init(named: "radio_btn_unselected")
        specificDeviceImgView.image = UIImage.init(named: "radio_btn_selected")
        knownDeviceBkView.isHidden = false
    }
    
}

extension DiscoverAndConnectViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return knownDeviceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "KnownDeviceTableViewCell", for: indexPath) as! KnownDeviceTableViewCell
        cell.deviceNameLabel.text =  "\(knownDeviceList[indexPath.row]["device_name"] ?? "(Unnamed)")"
        if indexPath.row == selectedDeviceIndex{
            cell.backgroundColor = UIColor.init(red: 239/255, green: 245/255, blue: 251/255, alpha: 1)
            cell.deviceNameLabel.textColor = UIColor.init(named: "ThemeColor")
        }
        else{
            cell.backgroundColor = UIColor.white
            cell.deviceNameLabel.textColor = UIColor.black
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25.0 * (UIScreen.main.bounds.height / 568)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
                
        selectedDeviceIndex = indexPath.row
        self.knownDeviceTableView.reloadData()
    }
}
extension DiscoverAndConnectViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
