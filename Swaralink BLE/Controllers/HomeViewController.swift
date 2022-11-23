//
// File: HomeViewController.swift
// Copyright (c) 2021, SwaraLink Technologies
// All Rights Reserved
// Licensed by SwaraLink Technologies, subject to terms of Software License Agreement

import UIKit

let viewInitialHeight = 250.0

class HomeViewController: UIViewController {
  
    @IBOutlet weak var logimgView: UIImageView!
    @IBOutlet weak var aboutUsButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var centralStatus: UILabel!
    @IBOutlet weak var connectionInfoLabel: UILabel!
    @IBOutlet weak var buttonTableView: UITableView!
    
    var functionNameArray = [ "SWLCentral.discoverAndConnect",
                              "SWLCentral.directConnect",
                              "SWLCentral.cancelConnect",
                              "SWLCentral.terminateConnection",
                              "SWLCentral.sendData",
                              "SWLCentral.getKnownDeviceList",
                              "SWLCentral.clearKnownDeviceList",
                              "SWLCentral.removeFromKnownDeviceList",
                              "SWLCentral.updatePeripheralFirmware",
                              "SWLCentral.requestDiagnosticLogs",
                              "SWLCentral.setPeripheralPriorities",
                              "SWLCentral.getPeripheralPriorities",
                              "SWLCentral.getCurrentState",
                              "SWLCentral.setConfigurationProfile"
//                              "SWLCentral.sendInternalData",
//                              "SWLCentral.setInternalParameters",
//                              "SWLCentral.getInternalParameters"
                          ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        SWLConnection.shared.getInternalParameters()
        setupUI()
        bottomView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        StaticHelper.shared.addLogViewController(self)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setupUI(){
        
        aboutUsButton.layer.cornerRadius = 10.0 * (UIScreen.main.bounds.height/568)
        bottomView.layer.cornerRadius = 10.0 * (UIScreen.main.bounds.height/568)
        aboutUsButton.layer.borderWidth = 2.0
        bottomView.layer.borderWidth = 2.0
        aboutUsButton.layer.borderColor = UIColor.init(named: "ThemeColor")!.cgColor
        bottomView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
     func clearKnownDeviceListAction() {
         let vc = self.storyboard?.instantiateViewController(withIdentifier: "ClearKnownDeviceViewController") as! ClearKnownDeviceViewController
         self.navigationController?.pushViewController(vc, animated: true)

    }
    
     func getKnownDeviceLIst() {
         
         let vc = self.storyboard?.instantiateViewController(withIdentifier: "GetKnownDeviceViewController") as! GetKnownDeviceViewController
         self.navigationController?.pushViewController(vc, animated: true)
    }
    
  func discoverConnectAction() {
      
      let vc = self.storyboard?.instantiateViewController(withIdentifier: "DiscoverAndConnectViewController") as! DiscoverAndConnectViewController
      self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func directConnectAction() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DirectConnectViewController") as! DirectConnectViewController
        self.navigationController?.pushViewController(vc, animated: true)
      }
    
    func getInternalParameters(){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GetInternalParametersViewController") as! GetInternalParametersViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setInternalParameters(){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SetInternalParameterViewController") as! SetInternalParameterViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func sendInternalAction() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SendReceiveViewController") as! SendReceiveViewController
        vc.isFromInternalData = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func cancelDiscoverAndConnect() {
     
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "CancelDiscoverAndConnectViewController") as! CancelDiscoverAndConnectViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func terminateAction() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TerminateConnectionViewController") as! TerminateConnectionViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func updatePeripheralFirmware() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpdateFirmwareViewController") as! UpdateFirmwareViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func sendReceiveAction() {

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SendReceiveViewController") as! SendReceiveViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func aboutAction(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func removeFromKnownDevice() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "KnownDeviceViewController") as! KnownDeviceViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func requestDiagnosticLog() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DiagnosticLogViewController") as! DiagnosticLogViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
    func setInternalPriorities(){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PeripheralPrioritiesViewController") as! PeripheralPrioritiesViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func getPeripheralPriorities(){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GetPeripheralPrioritiesViewController") as! GetPeripheralPrioritiesViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func getCurrentState() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GetCurrentStateViewController") as! GetCurrentStateViewController
        self.navigationController?.pushViewController(vc, animated: true)

    }
    func setConfigurationProfile(){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SetConfigurationProfileViewController") as! SetConfigurationProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return functionNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonTableViewCell", for: indexPath) as! ButtonTableViewCell
        cell.buttonNameLAbel.text = functionNameArray[indexPath.row]
        
//        if indexPath.row == functionNameArray.count - 1 || indexPath.row == functionNameArray.count - 2 || indexPath.row == functionNameArray.count - 3{
//            cell.buttonBkImageView.image = UIImage.init(named: "btn_secondary")
//        }
//        else{
            cell.buttonBkImageView.image = UIImage.init(named: "btn")
//       }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.discoverConnectAction()
        case 1:
            self.directConnectAction()
        case 2:
            self.cancelDiscoverAndConnect()
        case 3:
            self.terminateAction()
        case 4:
            self.sendReceiveAction()
        case 5:
            self.getKnownDeviceLIst()
        case 6:
            self.clearKnownDeviceListAction()
        case 7:
            self.removeFromKnownDevice()
        case 8:
            self.updatePeripheralFirmware()
        case 9:
            self.requestDiagnosticLog()
        case 10:
            self.setInternalPriorities()
        case 11:
            self.getPeripheralPriorities()
        case 12:
            self.getCurrentState()
        case 13:
            self.setConfigurationProfile()
//        case 10:
//            self.sendInternalAction()
//        case 11:
//            self.setInternalParameters()
//        case 12:
//            self.getInternalParameters()
        default:
           break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0 * (UIScreen.main.bounds.height / 568)
    }
}

