//
//  ConnectionDelegate.swift
//  Copyright (c) 2021, SwaraLink Technologies
//  All Rights Reserved
//  Licensed by SwaraLink Technologies, subject to terms of Software License Agreement
//

import Foundation
import CoreBluetooth
import SWLCentral

protocol SWLConnectionWrapperDelegate{
    func knownDeviceListReceived(_ devices: [[String: Any]])
    func internalDeviceParametersReceived(_ parameters: [String: Any])
}
class SWLConnection: NSObject,SWConnectionStatus{
    
    static let shared = SWLConnection()

    var connectionManager = SWConnectionManager.shared
    var currentDevicePairID = "-1"
    var peripheralDevice : CBPeripheral?
    var packetsArray = [Data](){
        didSet{
        }
    }
    var peripheralStatusLabel = ""
    
    var knownDeviceList = [[String: Any]](){
        didSet{
          
        }
    }
    var swlConnectionWrapperDelegate: SWLConnectionWrapperDelegate?
    
    //***************************************
    //MARK: - SWL DELEGATE
    //***************************************
    
    override init() {
        super.init()
        connectionManager.delegate = self
    }
    
    func discoverAndConnect(_ uuid: String?, timeout: Int?){
        
       let callBackString = self.connectionManager.discoverAndConnect(uuid, timeout: timeout)

        if callBackString == "Invalid_State" {
        
            StaticHelper.shared.logControllerVC.setInvalidState("INVALID_STATE")
        }
        else if callBackString == "Not_Found" {

            StaticHelper.shared.logControllerVC.setInvalidState("Not_Found")
        }
    }
    
    func directConnect(_ uuid: String?, timeout: Int?){
        
        let callBackString = self.connectionManager.directConnect(uuid!, timeout: timeout)

        if callBackString == "Invalid_State" {
        
            StaticHelper.shared.logControllerVC.setInvalidState("INVALID_STATE")
        }
    }
    
    func cancelConnect(){
        
        let callBackString = connectionManager.cancelConnect()
        
        if callBackString == "Invalid_State" {
        
            StaticHelper.shared.logControllerVC.setInvalidState("INVALID_STATE")
        }
    }

    func terminateConnection(){
        
        let callBackString = connectionManager.terminateConnection()
        
        if callBackString == "Invalid_State" {
        
            StaticHelper.shared.logControllerVC.setInvalidState("INVALID_STATE")
        }
    }
    
    func getKnownDeviceList(){
        
        self.connectionManager.getAllDeviceList()
    }
    
    func clearKnownDeviceList(){
        
        self.connectionManager.clearKnownDeviceList()
    }
    func getCurrentState(){
        connectionManager.getCurrentState()
//        let callBackString = connectionManager.getCurrentState()
        
//        if callBackString == "Invalid_State" {
//
//            StaticHelper.shared.logControllerVC.setInvalidState("INVALID_STATE")
//        }
    }
    
    func removeFromKnownDeviceList(_ identifier: String){
        
        self.connectionManager.removeFromKnownDeviceList(identifier)
    }
   
    func sendData(_ major: String, _ minor: String, data: String, isAcknowledged:Bool){
        let callBackString = connectionManager.sendData(major, minor, data: data, isAcknowledged: isAcknowledged)
        if callBackString == "Invalid_State" {
        
            StaticHelper.shared.logControllerVC.setInvalidState("INVALID_STATE")
        }
    }
    
   func sendInternalData(_ major: String, _ minor: String, data: String){
//        let callBackString = connectionManager.sendInternalData(major, minor, data: data)
//        if callBackString == "Invalid_State" {
//
//            StaticHelper.shared.logControllerVC.setInvalidState()
//        }
    }
    
    func setConfigurationProfile(jsonPath: URL?){
        

        
        let callBackString =   connectionManager.setConfigurationProfile(jsonURL: jsonPath)
        
        if callBackString == "Invalid_JSON" {
        
            StaticHelper.shared.logControllerVC.setInvalidState("INVALID_JSON")
        }

    }
    
    func updatePeripheralFirmware(_ zipURL: URL){
        let callBackString = connectionManager.updatePeripheralFirmware(zipURL)
        
        if callBackString == "Invalid_State" {
        
            StaticHelper.shared.logControllerVC.setInvalidState("INVALID_STATE")
        }
    }
    func setInternalParameters( peripheralServiceUUID: String, peripheralBaseCharacteristicUUID: String, peripheralCompanyIdentifier: String){
       
//        connectionManager.setInternalParameters(peripheralServiceUUID: peripheralServiceUUID, peripheralBaseCharacteristicUUID: peripheralBaseCharacteristicUUID, peripheralCompanyIdentifier: peripheralCompanyIdentifier, jsonURL: nil)

    }
    
    func getInternalParameters(){
        connectionManager.getInternalParameters()
    }
    
    func requestDiagnosticLogs(){
        let callBackString =  connectionManager.requestDiagnosticLogs()
        
        if callBackString == "Invalid_State" {
        
            StaticHelper.shared.logControllerVC.setInvalidState("INVALID_STATE")
        }
    }
    
    func setPeripheralPriorities(priorities: String){
        let callBackString =  connectionManager.setPeripheralPriorities(priorities: priorities)
        if callBackString == "Invalid_State" {
        
            StaticHelper.shared.logControllerVC.setInvalidState("INVALID_STATE")
        }
    }
    
    func getPeripheralPriorities(){
        
        self.connectionManager.getPeripheralPriorities()
    }
    
    //***************************************
    //MARK: - SWL DELEGATE
    //***************************************
    
    func fetchConnectionStatus(status: String, advertisementData: [String : Any]?, func_description: String?) {
        
        let currentStatus: SWConnectionEvents = SWConnectionEvents(rawValue: status)!
        switch(currentStatus){
            
        case .evtDiscovered:
            if connectionManager.peripheralManager.peripheralDevice != nil {
                currentDevicePairID = connectionManager.devicePairID
                StaticHelper.shared.logControllerVC.pairID = currentDevicePairID
                peripheralDevice = connectionManager.peripheralManager.peripheralDevice!
            }
              break
        case .evtConnectionEstablished:
            break
        case .evtConnectionDetails:
            break
        case .evtConnectionTerminated:
            
            break
        case .evtP2CDataReceived:
            packetsArray = connectionManager.packetsArray
            connectionManager.packetsArray.removeAll()
            StaticHelper.shared.logControllerVC.setSendDataEventInfo(packetsArray, event: currentStatus.rawValue, isAcknowledged: connectionManager.isAcknowledged, evtDesc: func_description ?? "" )
           
        case .evtC2PDataAcknowledged:
            let data = "\n" + "Major Header : " + (advertisementData!["major"] as! String) + "\n" + "Minor Header : " + (advertisementData!["minor"] as! String) + "\n"
            
            StaticHelper.shared.logControllerVC.showCharacteristicsAcknowledgement( event: currentStatus.rawValue, description: func_description ?? "", data: data)
        case .evtUpdateState:
//           StaticHelper.shared.logControllerVC.setUpdateEventInfo(event: currentStatus.rawValue,description: func_description ?? "")
            break
        case .evtPeripheralPairedStatus:
            let packetsArray = connectionManager.packetsArray
            connectionManager.packetsArray.removeAll()
//            StaticHelper.shared.logControllerVC.setInternalEventInfo(packetsArray, event: SWConnectionEvents.evtP2CInternalDataReceived.rawValue)
//            StaticHelper.shared.logControllerVC.setPeripheralPairedStatus(packetsArray, event: currentStatus.rawValue)
            break
        case .evtPeripheralCurrentStatusUpdate:
            let packetsArray = connectionManager.packetsArray
            connectionManager.packetsArray.removeAll()
//            StaticHelper.shared.logControllerVC.setInternalEventInfo(packetsArray, event: SWConnectionEvents.evtP2CInternalDataReceived.rawValue)
//            StaticHelper.shared.logControllerVC.showPeripheralCurrentStatus(packetsArray, event: currentStatus.rawValue)
        case .evtPeripheralSystemInfoReceived:
            let packetsArray = connectionManager.packetsArray
            connectionManager.packetsArray.removeAll()
//            StaticHelper.shared.logControllerVC.setInternalEventInfo(packetsArray, event: SWConnectionEvents.evtP2CInternalDataReceived.rawValue)
//            StaticHelper.shared.logControllerVC.showSystemInfo(packetsArray, event: currentStatus.rawValue)
        case .evtP2CInternalDataReceived:
            let packetsArray = connectionManager.packetsArray
            connectionManager.packetsArray.removeAll()
//            StaticHelper.shared.logControllerVC.setInternalEventInfo(packetsArray, event: currentStatus.rawValue)
        case .evtKnownDeviceList:
            knownDeviceList = connectionManager.knownDeviceList
            swlConnectionWrapperDelegate?.knownDeviceListReceived(knownDeviceList)
            StaticHelper.shared.logControllerVC.showDeviceInfo(connectionManager.knownDeviceList, event: SWConnectionEvents.evtKnownDeviceList.rawValue,description: func_description ?? "")
        case .evtFunctionCall:
                     
            if let advData = advertisementData{
                
                if let functionParams = advertisementData?["params"] as? String{
                    
                    StaticHelper.shared.logControllerVC.setActionInfo( (advData["function"] as! String), param: functionParams)
                }
                else if let str = advData["major"] as? String{
                    
                    let str1 = "\nMajor Header: " + (advData["major"] as! String) + "\nMinor Header: " + (advData["minor"] as! String) + "\nPayload: " + (advData["data"] as! String)
                    StaticHelper.shared.logControllerVC.setActionInfo( (advData["function"] as! String), param: str1)
                }
                else{
                    
                    StaticHelper.shared.logControllerVC.setActionInfo( (advData["function"] as! String), param: "")
                }
            }
        case .evtPeripheralFirmwareUpdateComplete:
            StaticHelper.shared.logControllerVC.setFirmwareUpdateLog(event: SWConnectionEvents.evtPeripheralFirmwareUpdateComplete.rawValue, description: "")
        case .evtPeripheralFirmwareUpdateFailure:
            StaticHelper.shared.logControllerVC.setFirmwareUpdateLog(event: SWConnectionEvents.evtPeripheralFirmwareUpdateFailure.rawValue, description: "")
        case .evtPeripheralFirmwareUpdateProgress:
            StaticHelper.shared.logControllerVC.setFirmwareUpdateLog(event: SWConnectionEvents.evtPeripheralFirmwareUpdateProgress.rawValue, description: "\(advertisementData!["progress"] as! Int)% completed")
        case .evtCannotConnect:
            let reason = advertisementData!["reason"] as! String
            StaticHelper.shared.logControllerVC.showCanNotConnectReasons( SWConnectionEvents.evtCannotConnect.rawValue,reason: reason , description: func_description ?? "")
        case .evtInternalParameters:
            break
//            swlConnectionWrapperDelegate?.internalDeviceParametersReceived(advertisementData!)
//            StaticHelper.shared.logControllerVC.setGetInternalParamEventInfo(advertisementData!, event: SWConnectionEvents.evtInternalParameters.rawValue)
        case .evtP2CDiagnosticDataReceived:
            let packetsArray = connectionManager.packetsArray
            connectionManager.packetsArray.removeAll()
            StaticHelper.shared.logControllerVC.setDiagonosticInfo(packetsArray, event: currentStatus.rawValue, evtDesc: func_description ?? "")

        case .evtUpdatedStateFirmwareUpdate:
            StaticHelper.shared.logControllerVC.setUpdateOTAEventInfo(event: currentStatus.rawValue, description: func_description ?? "", state: advertisementData!["state"] as! String)
            break
        case .evtConnectionConnected:
            break
        case .evtTestSequenceComplete:
            StaticHelper.shared.logControllerVC.setFirmwareUpdateLog(event: SWConnectionEvents.evtTestSequenceComplete.rawValue, description: "")
        case .evtCurrentPeripheralPriorities:
            StaticHelper.shared.logControllerVC.showPeripheralPrioritiesEventInfo(advertisementData!["priorities"] as! Data, event: SWConnectionEvents.evtCurrentPeripheralPriorities.rawValue, description: func_description ?? "")

        case .evtPeripheralExceptionOccurred:
            StaticHelper.shared.logControllerVC.setExceptionFlagInfo(event: SWConnectionEvents.evtPeripheralExceptionOccurred.rawValue, evtDesc: func_description ?? "")
        @unknown default:
            break
        }
    }
    
    func fetchPeripheralStatus(status: String, func_description: String?) {
        peripheralStatusLabel = status
        StaticHelper.shared.logControllerVC.currentStatusLabel = status
        StaticHelper.shared.logControllerVC.functiondescription = func_description ?? ""
        StaticHelper.shared.logControllerVC.setUpdateEventInfo(event: "evtUpdateState" ,description: func_description ?? "")
//        let currentState : SWStatusEvents = SWStatusEvents.init(rawValue: status)!
//        switch(currentState){
//        case .SWLCentralStateDiscovered:
//             //connectionManager.peripheralManager.peripheralDevice = nearByPeripheralDevice.first
//            StaticHelper.shared.logControllerVC.currentStatusLabel = status
//        case .SWLCentralStateConnected:
//            StaticHelper.shared.logControllerVC.currentStatusLabel = status
//        default:
//            StaticHelper.shared.logControllerVC.currentStatusLabel = status
//            break
//        }
    }

}
