//
// File: DiscoverAndConnectViewController.swift
// Copyright (c) 2021, SwaraLink Technologies
// All Rights Reserved
// Licensed by SwaraLink Technologies, subject to terms of Software License Agreement

import UIKit
//import SWLCentral
import CoreBluetooth

class DirectConnectViewController: UIViewController,SWLConnectionWrapperDelegate {
    func internalDeviceParametersReceived(_ parameters: [String : Any]) {
        
    }

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var knownDeviceLabel: UILabel!
    @IBOutlet weak var knownDeviceTableView: UITableView!
    @IBOutlet weak var beginButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var timeoutTextField: UITextField!
    @IBOutlet weak var knownDeviceBkView: UIView!

    
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
    
    func knownDeviceListReceived(_ devices: [[String : Any]]) {
        
        knownDeviceList = devices
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swlConection.swlConnectionWrapperDelegate = self
        StaticHelper.shared.addLogViewController(self)
  
        knownDeviceBkView.isHidden = false
        nearByPeripheralDevice.removeAll()
        descriptionLabel.attributedText = SWLConstants().directConnect.getFunctionDescription()
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
       
        knownDeviceTableView.layer.borderWidth = 2.0
   
        knownDeviceTableView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func beginAcceptAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        var timerValue : Int? = nil
        if let timeoutValue = timeoutTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines){
            timerValue = Int(timeoutValue)
        }
        
        if selectedDeviceIndex < 0{
            let alert = UIAlertController.init(title: "", message: "Please select device.", preferredStyle: .alert)
            let action = UIAlertAction.init(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }

        swlConection.directConnect("\(knownDeviceList[selectedDeviceIndex]["identifier"] ?? "(Unnamed)")", timeout: timerValue)
    
    }
    

    
  
}

extension DirectConnectViewController: UITableViewDelegate, UITableViewDataSource{
    
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
