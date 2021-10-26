//
// File: LOGViewController.swift
// Copyright (c) 2021, SwaraLink Technologies
// All Rights Reserved
// Licensed by SwaraLink Technologies, subject to terms of Software License Agreement

import UIKit
import SWLCentral

class KnownDeviceViewController: UIViewController,SWLConnectionWrapperDelegate {
    func internalDeviceParametersReceived(_ parameters: [String : Any]) {
        
    }
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var clearDeviceButton: UIButton!
    var selectedDeviceIndex = -1

    var knownDeviceList = [[String: Any]](){
        didSet{
            self.tableView.reloadData()
        }
    }
    var swlConection =  SWLConnection.shared
    
    func knownDeviceListReceived(_ devices: [[String : Any]]) {
        knownDeviceList = devices
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        swlConection.swlConnectionWrapperDelegate = self
        swlConection.getKnownDeviceList()
        StaticHelper.shared.addLogViewController(self)
        descriptionLabel.attributedText = SWLConstants().remove_kdl_desc.getFunctionDescription()
        self.tableView.layer.borderColor = UIColor.lightGray.cgColor
        self.tableView.layer.borderWidth = 1.0
        
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clearDeviceAction(_ sender: UIButton) {
      
        if knownDeviceList.count == 0 || selectedDeviceIndex == -1{
            StaticHelper.shared.logControllerVC.setActionInfo( SWAction.removeFromKnownDeviceList.rawValue, param: "")
            StaticHelper.shared.logControllerVC.setInvalidState("INVALID_STATE")
            return
        }
        let device = knownDeviceList[selectedDeviceIndex]
        let identifier  = device["identifier"] as! String
        swlConection.removeFromKnownDeviceList(identifier)
    }

}
extension KnownDeviceViewController: UITableViewDelegate, UITableViewDataSource{
    
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
        self.tableView.reloadData()
    }
}

