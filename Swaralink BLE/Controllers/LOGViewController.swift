//
// File: LOGViewController.swift
// Copyright (c) 2021, SwaraLink Technologies
// All Rights Reserved
// Licensed by SwaraLink Technologies, subject to terms of Software License Agreement

import UIKit
import SWLCentral

class LOGViewController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var topBackView: UIButton!
    @IBOutlet weak var logLabel: UILabel!
  //  @IBOutlet weak var logTextView: UITextView!
    @IBOutlet weak var saveFileButton: UIButton!
    @IBOutlet weak var clearLogButton: UIButton!
    @IBOutlet weak var swlCentralLabel: UILabel!
    @IBOutlet weak var currentSWLStatus: UILabel!
    @IBOutlet weak var viewTopConstant: NSLayoutConstraint!
    
    @IBOutlet weak var packetTableView: UITableView!
    
    @IBOutlet weak var autoScrollButton: UIButton!
    
    var packetsArray = [NSMutableAttributedString](){
        didSet{
            DispatchQueue.main.async {
                self.packetTableView.reloadData()
                if self.isAutoScoll,self.packetsArray.count > 0{
                    let index = self.packetTableView!.numberOfRows(inSection: 0) - 1
                    self.packetTableView.scrollToRow(at: IndexPath.init(row: index, section: 0), at: .bottom, animated: true)
                }
            }
        }
    }
    
    var pairID = "-1"
    var functiondescription = ""
    
    var currentStatusLabel = "SWLCentralStateIdle"{
        didSet{
            //StaticHelper.shared.logControllerVC.setUpdateEventInfo(event: SWConnectionEvents.evtUpdateState.rawValue, description: functiondescription)
            self.currentSWLStatus.text = currentStatusLabel
           
        }
    }
    
    var connectionManager = SWConnectionManager.shared
    var systemInfo =  [(Info:"Chip Vendor ID", byteCount :1),
                       (Info:"Peripheral Max Rx Payload Size", byteCount :2),
                       (Info:"Build Revision Number", byteCount :4),
                       (Info:"Chip Device ID", byteCount :1),
                       (Info:"Bluetooth SDK ID", byteCount :1),
                       (Info:"Peripheral Tx Op Queue Size", byteCount :2),
                       (Info:"Tx By Copy Buffer Size", byteCount :2),
                       (Info:"Initial Power Mode", byteCount :1),
                       (Info:"Max Number of Paired Devices", byteCount :1),
                       (Info:"Pairing Unlock Key Size", byteCount :1),
                       (Info:"Diagnostic Log Size", byteCount :2),
                       (Info:"Peripheral Internal Tx Op Queue Size", byteCount :2),
                       (Info:"Peripheral Internal Tx By Copy Buffer Size", byteCount :2),
                       (Info:"Peripheral Internal Tx Max Payload Length", byteCount :2),
                       (Info:"Peripheral Internal Rx Buffer Size", byteCount :2),
                       (Info:"Pairing Mode Minimum Time (s)", byteCount :2),
                       (Info:"Pairing Mode Maximum Time (s)", byteCount :2),
                       (Info:"Mode 1 Advertising Interval (Units of 0.625ms)", byteCount :2),
                       (Info:"Mode 1 Connection Interval Min (Units of 1.25ms)", byteCount :2),
                       (Info:"Mode 1 Connection Interval Max (Units of 1.25ms)", byteCount :2),
                       (Info:"Mode 1 Peripheral Latency", byteCount :2),
                       (Info:"Mode 1 Supervision Timeout (Units of 10ms)", byteCount :2),
                       (Info:"Mode 2A Advertising Interval (Units of 0.625ms)", byteCount :2),
                       (Info:"Mode 2A Connection Interval Min (Units of 1.25ms)", byteCount :2),
                       (Info:"Mode 2A Connection Interval Max (Units of 1.25ms)", byteCount :2),
                       (Info:"Mode 2A Peripheral Latency", byteCount :2),
                       (Info:"Mode 2A Supervision Timeout (Units of 10ms)", byteCount :2),
                       (Info:"Mode 2B Advertising Interval (Units of 0.625ms)", byteCount :2),
                       (Info:"Mode 2B Connection Interval Min (Units of 1.25ms)", byteCount :2),
                       (Info:"Mode 2B Connection Interval Max (Units of 1.25ms)", byteCount :2),
                       (Info:"Mode 2B Peripheral Latency", byteCount :2),
                       (Info:"Mode 2B Supervision Timeout (Units of 10ms)", byteCount :2),
                       (Info:"Mode 2C Advertising Interval (Units of 0.625ms)", byteCount :2),
                       (Info:"Mode 2C Connection Interval Min (Units of 1.25ms)", byteCount :2),
                       (Info:"Mode 2C Connection Interval Max (Units of 1.25ms)", byteCount :2),
                       (Info:"Mode 2C Peripheral Latency", byteCount :2),
                       (Info:"Mode 2C Supervision Timeout (Units of 10ms)", byteCount :2),
                       (Info:"Mode 3 Advertising Interval (Units of 0.625ms)", byteCount :2),
                       (Info:"Mode 3 Connection Interval Min (Units of 1.25ms)", byteCount :2),
                       (Info:"Mode 3 Connection Interval Max (Units of 1.25ms)", byteCount :2),
                       (Info:"Mode 3 Peripheral Latency", byteCount :2),
                       (Info:"Mode 3 Supervision Timeout (Units of 10ms)", byteCount :2),
                       (Info:"Mode 4 Advertising Interval (Units of 0.625ms)", byteCount :2),
                       (Info:"Mode 4 Connection Interval Min (Units of 1.25ms)", byteCount :2),
                       (Info:"Mode 4 Connection Interval Max (Units of 1.25ms)", byteCount :2),
                       (Info:"Mode 4 Peripheral Latency", byteCount :2),
                       (Info:"Mode 4 Supervision Timeout (Units of 10ms)", byteCount :2)
                    ]
    
    
    var packetText = NSMutableAttributedString.init(string: "")
    var isAutoScoll = true{
        didSet{
            if isAutoScoll{
                autoScrollButton.setTitle("Auto Scroll Off", for: .normal)
            }
            else{
                autoScrollButton.setTitle("Auto Scroll On", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture(recognizer:)))
//        view.addGestureRecognizer(gesture)
        self.createDirectory(modelPath)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(recognizer:)))
         swipeRight.direction = .up
         self.view.addGestureRecognizer(swipeRight)

         let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(recognizer:)))
         swipeDown.direction = .down
         self.view.addGestureRecognizer(swipeDown)
        packetTableView.delegate = self
        packetTableView.dataSource  = self
        self.currentSWLStatus.text = SWStatusEvents.SWLCentralStateIdle.rawValue
   //     self.currentStatusLabel =  SWStatusEvents.SWL_CENTRAL_STATE_IDLE.rawValue
//        let swipeGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeAction(recognizer:)))
//        swipeGesture.allowedPressTypes
//        view.addGestureRecognizer(swipeGesture)
     
        self.setupUI()
    }
    
    @IBAction func clearLogAction(_ sender: UIButton) {
        self.packetsArray.removeAll()
    }
    
    var modelPath = "/project/logs/"
    var modelText = "Its a log"
    
    @IBAction func autoScrollAction(_ sender: UIButton) {
        isAutoScoll = !isAutoScoll
    }
    
    @IBAction func saveLogAction(_ sender: UIButton) {
        packetText = NSMutableAttributedString.init(string: "")
        for pt in 0..<packetsArray.count{
            packetText.append(packetsArray[pt])
            packetText.append(NSAttributedString.init(string: "\n"))
            if pt == (packetsArray.count - 1){
                let file = "logs.txt"
                self.createModelFile((modelPath+file))
            }
        }
        

    }
    
    private func createDirectory(_ directory: String){
         let DocumentDirectory = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
         let DirPath = DocumentDirectory.appendingPathComponent(directory)
         do
         {
             try FileManager.default.createDirectory(atPath: DirPath!.path, withIntermediateDirectories: true, attributes: nil)
          
         }
         catch let error as NSError
         {
             print("Unable to create directory \(error.debugDescription)")
         }
       //  print("Dir Path = \(DirPath!)")
     }
    
    private func deleteFiles(_ filePath : String){
        do {
             let fileManager = FileManager.default
            
            // Check if file exists
            if fileManager.fileExists(atPath: filePath) {
                // Delete file
                try fileManager.removeItem(atPath: filePath)
            } else {
                print("File does not exist")
            }
         
        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }
    }
//    func createModel(_ fileName: String){
//
//        let file = modelPath + "logs.txt"
//        self.createModelFile((modelPath+file))
//    }
    private func createModelFile(_ fileName: String){
        
        let DocumentDirectory = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let directory = DocumentDirectory.path! + fileName
        
        print(DocumentDirectory.path!)
        print(fileName)
        
        do {
             let fileManager = FileManager.default
            
            // Check if file exists
            if fileManager.fileExists(atPath: directory) {
                // Delete file
                try fileManager.removeItem(atPath: directory)
            } else {
                print("File does not exist")
            }
         
        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }
        
        
        if (FileManager.default.createFile(atPath: directory, contents: nil, attributes: nil)) {
            print(directory,"File created successfully.")
            
            //writing
            do {
              
                try packetText.string.write(to:  URL.init(fileURLWithPath: directory), atomically: false, encoding: .utf8)
                self.share(url: URL.init(fileURLWithPath: directory))
            }
            catch let error as NSError{
                print(error.localizedDescription)
            }
            
        } else {
            print("File not created.")
        }
    }
    
    let documentInteractionController = UIDocumentInteractionController()
     func share(url: URL) {
         documentInteractionController.url = url
      //   documentInteractionController.uti = url.typeIdentifier ?? "public.data, public.content"
      //   documentInteractionController.name = url.localizedName ?? url.lastPathComponent
         documentInteractionController.presentOptionsMenu(from: view.frame, in: view, animated: true)
     }
    
    
    func getDirectoryContents(){
        
        let documentDirectory = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).path
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: URL.init(fileURLWithPath: documentDirectory!), includingPropertiesForKeys: nil)
            print(fileURLs)
            // process files
        } catch {
            print("Error while enumerating files \(documentDirectory): \(error.localizedDescription)")
        }
    }
    
    func getCurrentTime()-> String{
        let dtFormat = DateFormatter()
        let date = Date()
        dtFormat.dateFormat = "HH:mm:ss.SSS"
        let strDate = dtFormat.string(from: date)
        return "--------------\n" + strDate
    }
    
    func showCharacteristicsAcknowledgement(event: String,description: String,data: String){
   
            let time = getCurrentTime()
            let stringAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                    NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12.0)
                                   ]
          
            let timeAttrString = NSMutableAttributedString(string: time, attributes: stringAttributes)
         //   let timeAttrString = NSAttributedString(string: time, attributes: stringAttributes)
  
            let combination = NSMutableAttributedString()
            let space = NSAttributedString.init(string: "\n")

//            let min = NSMutableAttributedString(string: "Payload : ", attributes: stringAttributes)
            let minData = NSMutableAttributedString.init(string: data, attributes: stringAttributes)

            let ack =  NSMutableAttributedString(string: "Acknowledged : ", attributes: stringAttributes)
            let ackData = NSMutableAttributedString.init(string: "Success")
         
            let evenetName = NSMutableAttributedString(string: "Event: ", attributes: stringAttributes)
            let evetData = NSMutableAttributedString.init(string:  event)
        
            combination.append(space)
            combination.append(space)
            combination.append(timeAttrString)
            combination.append(space)
            combination.append(evenetName)
            combination.append(evetData)
            combination.append(space)
            combination.append(minData)
            combination.append(space)
            combination.append(ack)
            combination.append(ackData)

            if !description.isEmpty{
                let desc = NSMutableAttributedString(string: "Description: ", attributes: stringAttributes)
                let descData = NSMutableAttributedString.init(string:  description)
                combination.append(space)
                combination.append(desc)
                combination.append(descData) //+ "\nCurrentPairedCentralDeviceId: " + currentDevicePairID
            }
        
            DispatchQueue.global().async {
                self.packetsArray.append(combination)
            }
        
    }
    
    func setupLogInfo(_ packetInfo: [Data], event: String, isAck: Bool,description: String){
        for packet in packetInfo{
            let time = getCurrentTime()
            let stringAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                    NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12.0)
                                   ]
          
            let timeAttrString = NSMutableAttributedString(string: time, attributes: stringAttributes)
         //   let timeAttrString = NSAttributedString(string: time, attributes: stringAttributes)
  
            let combination = NSMutableAttributedString()
            let space = NSAttributedString.init(string: "\n")

            
            let min = NSMutableAttributedString(string: "Minor ID Header : ", attributes: stringAttributes)
            let minData = NSMutableAttributedString.init(string: String(format: "0x%02X", packet[1]))
           
            let maj = NSMutableAttributedString(string: "Major ID Header : ", attributes: stringAttributes)
            let majData = NSMutableAttributedString.init(string: String(format: "0x%02X", packet[0]))
         //   let maj = "Major ID Header : " + String(format: "0x%02X", packet[0])
            let ak = isAck ? "true": "false"
            let ack =  NSMutableAttributedString(string: "Acknowledged : ", attributes: stringAttributes)
            let ackData = NSMutableAttributedString.init(string: ak)
            var dt = packet
            dt.removeFirst(2)
            let payload =  NSMutableAttributedString(string: "Payload : ", attributes: stringAttributes)
            let payloadData = NSMutableAttributedString.init(string:  dt.hexEncodedString())
            
            let evenetName = NSMutableAttributedString(string: "Event: ", attributes: stringAttributes)
            let evetData = NSMutableAttributedString.init(string:  event)
            combination.append(space)
            combination.append(space)
            combination.append(timeAttrString)
            combination.append(space)
            combination.append(evenetName)
            combination.append(evetData)
            combination.append(space)
            combination.append(maj)
            combination.append(majData)
            combination.append(space)
            combination.append(min)
            combination.append(minData)
            combination.append(space)
            combination.append(ack)
            combination.append(ackData)
            combination.append(space)
            combination.append(payload)
            combination.append(payloadData)
         //   let finalInfo = time + "\n" + evenetName + "\n" + maj + "\n" + min + "\n" +  ack + "\n" + payload
            if !description.isEmpty{
                let desc = NSMutableAttributedString(string: "Description: ", attributes: stringAttributes)
                let descData = NSMutableAttributedString.init(string:  description)
                combination.append(space)
                combination.append(desc)
                combination.append(descData) //+ "\nCurrentPairedCentralDeviceId: " + currentDevicePairID
            }
            DispatchQueue.global().async {
                self.packetsArray.append(combination)
            }
        }
    }
    
    func setUpdateEventInfo(event: String,description: String){
        let time = getCurrentTime()
        let stringAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12.0)
                               ]
        let space = NSAttributedString.init(string: "\n")
        let timeAttrString = NSMutableAttributedString(string: time, attributes: stringAttributes)
    //    if packetInfo.isEmpty{
            let combination = NSMutableAttributedString()
            let evenetName = NSMutableAttributedString(string: "Event: ", attributes: stringAttributes)
            let evetData = NSMutableAttributedString.init(string:  "SWLCentral." + event)
            let stateName = NSMutableAttributedString(string: "State: ", attributes: stringAttributes)
            let stateData = NSMutableAttributedString.init(string:   currentStatusLabel)
       
            combination.append(space)
            combination.append(space)
            combination.append(timeAttrString)
            combination.append(space)
            combination.append(evenetName)
            combination.append(evetData)
            combination.append(space)
            combination.append(stateName)
            combination.append(stateData)
        
        if currentStatusLabel == SWStatusEvents.SWLCentralStateConnected.rawValue || currentStatusLabel ==     SWStatusEvents.SWLCentralStateDiscovered.rawValue {
            let deviceName = NSMutableAttributedString(string: "\ndeviceName: ", attributes: stringAttributes)
            let deviceUUID = NSMutableAttributedString(string: "\nNSUUID: ", attributes: stringAttributes)
            let pairedDevice = NSMutableAttributedString(string: "\ncurrentPairedCentralDeviceId: ", attributes: stringAttributes)
            let pairID = NSMutableAttributedString.init(string:   self.pairID)
            let name = NSMutableAttributedString.init(string:   self.connectionManager.peripheralManager.peripheralDevice?.name ?? "")
            let uuid = NSMutableAttributedString.init(string:   self.connectionManager.peripheralManager.peripheralDevice?.identifier.uuidString ?? "")

            combination.append(deviceName)
            combination.append(name)
            
            combination.append(deviceUUID)
            combination.append(uuid)
            
            combination.append(pairedDevice)
            combination.append(pairID)
        }
        
        if !description.isEmpty{
            let desc = NSMutableAttributedString(string: "Description: ", attributes: stringAttributes)
            let descData = NSMutableAttributedString.init(string:  description)
            combination.append(space)
            combination.append(desc)
            combination.append(descData) //+ "\nCurrentPairedCentralDeviceId: " + currentDevicePairID
        }

            self.packetsArray.append(combination)
          //  return
       // }
    }
    
    func setDiagonosticInfo(_ packetInfo: [Data], event: String,evtDesc: String){
        let time = getCurrentTime()
        let stringAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12.0)
                               ]
        let space = NSAttributedString.init(string: "\n")
        let timeAttrString = NSMutableAttributedString(string: time, attributes: stringAttributes)
        for packet in packetInfo{

          let combination = NSMutableAttributedString()
//            let min = NSMutableAttributedString(string: "Minor ID Header : ", attributes: stringAttributes)
//            let minData = NSMutableAttributedString.init(string: String(format: "0x%02X", packet[1]))
//
//            let maj = NSMutableAttributedString(string: "Major ID Header : ", attributes: stringAttributes)
//            let majData = NSMutableAttributedString.init(string: String(format: "0x%02X", packet[0]))

            var dt = packet
            dt.removeFirst(2)
            let payload =  NSMutableAttributedString(string: "Payload : ", attributes: stringAttributes)
            let payloadData = NSMutableAttributedString.init(string:  dt.hexEncodedString())
            

            
            let evenetName = NSMutableAttributedString(string: "Event: ", attributes: stringAttributes)
            let evetData = NSMutableAttributedString.init(string:  event)
            
            combination.append(space)
            combination.append(space)
            combination.append(timeAttrString)
            combination.append(space)
            combination.append(evenetName)
            combination.append(evetData)
            combination.append(space)
//            combination.append(maj)
//            combination.append(majData)
//            combination.append(space)
//            combination.append(min)
//            combination.append(minData)
//            combination.append(space)

            combination.append(payload)
            combination.append(payloadData)

         //   let finalInfo = time + "\n" + evenetName + "\n" + maj + "\n" + min + "\n" +  ack + "\n" + payload
            if !description.isEmpty{
                let desc = NSMutableAttributedString(string: "Description: ", attributes: stringAttributes)
                let descData = NSMutableAttributedString.init(string:  evtDesc)
                combination.append(space)
                combination.append(desc)
                combination.append(descData) //+ "\nCurrentPairedCentralDeviceId: " + currentDevicePairID
            }
            let myRange = NSRange(location: 0, length: combination.length)
            combination.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.black], range: myRange)
            DispatchQueue.global().async {
                self.packetsArray.append(combination)
            }
        }
        
    }
    
    func setExceptionFlagInfo(event:String, evtDesc: String){
        let time = getCurrentTime()
        let stringAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12.0)
                               ]
        let space = NSAttributedString.init(string: "\n")
        
        let timeAttrString = NSMutableAttributedString(string: time, attributes: stringAttributes)
        let combination = NSMutableAttributedString()
        combination.append(space)
        combination.append(timeAttrString)
        let evenetName = NSMutableAttributedString(string: "Event: ", attributes: stringAttributes)
        let evetData = NSMutableAttributedString.init(string:  event)
        combination.append(space)
        combination.append(evenetName)
        combination.append(evetData)
        if !evtDesc.isEmpty{
            let desc = NSMutableAttributedString(string: "Description: ", attributes: stringAttributes)
            let descData = NSMutableAttributedString.init(string:  evtDesc)
            combination.append(space)
            combination.append(desc)
            combination.append(descData) //+ "\nCurrentPairedCentralDeviceId: " + currentDevicePairID
        }
        self.packetsArray.append(combination)
    }
    
    
    func setUpdateOTAEventInfo(event: String,description: String,state: String){
        let time = getCurrentTime()
        let stringAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12.0)
                               ]
        let space = NSAttributedString.init(string: "\n")
        
        let timeAttrString = NSMutableAttributedString(string: time, attributes: stringAttributes)
    //    if packetInfo.isEmpty{
            let combination = NSMutableAttributedString()
            let evenetName = NSMutableAttributedString(string: "Event: ", attributes: stringAttributes)
            let evetData = NSMutableAttributedString.init(string:  "SWLCentral." + event)
            let stateName = NSMutableAttributedString(string: "State: ", attributes: stringAttributes)
            let stateData = NSMutableAttributedString.init(string:   state)
       
            combination.append(space)
            combination.append(space)
            combination.append(timeAttrString)
            combination.append(space)
            combination.append(evenetName)
            combination.append(evetData)
            combination.append(space)
            combination.append(stateName)
            combination.append(stateData)
        
        if !description.isEmpty{
            let desc = NSMutableAttributedString(string: "Description: ", attributes: stringAttributes)
            let descData = NSMutableAttributedString.init(string:  description)
            combination.append(space)
            combination.append(desc)
            combination.append(descData) //+ "\nCurrentPairedCentralDeviceId: " + currentDevicePairID
        }

            self.packetsArray.append(combination)
          //  return
       // }
    }
    
    
    func setGetInternalParamEventInfo(_ info: [String:Any], event: String){
        let time = getCurrentTime()
        let stringAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12.0)
                               ]
        let space = NSAttributedString.init(string: "\n")
        let timeAttrString = NSMutableAttributedString(string: time, attributes: stringAttributes)
        
        let evenetName = NSMutableAttributedString(string: "Event: ", attributes: stringAttributes)
        let evetData = NSMutableAttributedString.init(string:  "SWLCentral." + event)
        
        let serviceUUID = NSMutableAttributedString(string: "Service UUID : ", attributes: stringAttributes)
        let serviceUUIDData = NSMutableAttributedString.init(string: info["PeripheralServiceUUID"] as! String)
       
        let characteristicsUUID = NSMutableAttributedString(string: "Characteristics UUID : ", attributes: stringAttributes)
        let characteristicsUUIDData = NSMutableAttributedString.init(string: info["PeripheralBaseCharacteristicUUID"] as! String)
        
        
         let companyIdentifier = NSMutableAttributedString(string: "Company Identifier : ", attributes: stringAttributes)
         let companyIdentifierData = NSMutableAttributedString.init(string: info["PeripheralCompanyIdentifier"] as! String)

        let combination = NSMutableAttributedString()
        combination.append(space)
        combination.append(space)
        combination.append(timeAttrString)
        combination.append(space)
        combination.append(evenetName)
        combination.append(evetData)
        combination.append(space)
        combination.append(serviceUUID)
        combination.append(serviceUUIDData)
        combination.append(space)
        combination.append(characteristicsUUID)
        combination.append(characteristicsUUIDData)
        combination.append(space)
        combination.append(companyIdentifier)
        combination.append(companyIdentifierData)
        
        let myRange = NSRange(location: 0, length: combination.length)
        combination.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.black], range: myRange)
        DispatchQueue.global().async {
            self.packetsArray.append(combination)
        }
        
    }
    
    func setSendDataEventInfo(_ packetInfo: [Data], event: String,isAcknowledged:Bool,evtDesc: String){
        let time = getCurrentTime()
        let stringAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12.0)
                               ]
        let space = NSAttributedString.init(string: "\n")
        let timeAttrString = NSMutableAttributedString(string: time, attributes: stringAttributes)
        for packet in packetInfo{

            let combination = NSMutableAttributedString()
            let min = NSMutableAttributedString(string: "Minor ID Header : ", attributes: stringAttributes)
            let minData = NSMutableAttributedString.init(string: String(format: "0x%02X", packet[1]))
           
            let maj = NSMutableAttributedString(string: "Major ID Header : ", attributes: stringAttributes)
            let majData = NSMutableAttributedString.init(string: String(format: "0x%02X", packet[0]))

            let ack = NSMutableAttributedString(string: "Acknowledgement : ", attributes: stringAttributes)
            let ackData = NSMutableAttributedString.init(string: isAcknowledged ? "true" : "false")
            
            var dt = packet
            dt.removeFirst(2)
            let payload =  NSMutableAttributedString(string: "Payload : ", attributes: stringAttributes)
            let payloadData = NSMutableAttributedString.init(string:  dt.hexEncodedString())
            

            
            let evenetName = NSMutableAttributedString(string: "Event: ", attributes: stringAttributes)
            let evetData = NSMutableAttributedString.init(string:  event)
            
            combination.append(space)
            combination.append(space)
            combination.append(timeAttrString)
            combination.append(space)
            combination.append(evenetName)
            combination.append(evetData)
            combination.append(space)
            combination.append(maj)
            combination.append(majData)
            combination.append(space)
            combination.append(min)
            combination.append(minData)
            combination.append(space)
            
            combination.append(ack)
            combination.append(ackData)
            combination.append(space)
//            combination.append(ack)
//            combination.append(ackData)
//            combination.append(space)
            combination.append(payload)
            combination.append(payloadData)

         //   let finalInfo = time + "\n" + evenetName + "\n" + maj + "\n" + min + "\n" +  ack + "\n" + payload
            
            
             if !evtDesc.isEmpty{
                 let desc = NSMutableAttributedString(string: "Description: ", attributes: stringAttributes)
                 let descData = NSMutableAttributedString.init(string:  evtDesc)
                 combination.append(space)
                 combination.append(desc)
                 combination.append(descData) //+ "\nCurrentPairedCentralDeviceId: " + currentDevicePairID
             }
            
            
            let myRange = NSRange(location: 0, length: combination.length)
            combination.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.black], range: myRange)
            DispatchQueue.global().async {
                self.packetsArray.append(combination)
            }
        }
        
    }
    
    func setInternalEventInfo(_ packetInfo: [Data], event: String){
        let time = getCurrentTime()
        let stringAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12.0)
                               ]
        let space = NSAttributedString.init(string: "\n")
        let timeAttrString = NSMutableAttributedString(string: time, attributes: stringAttributes)
        for packet in packetInfo{

            let combination = NSMutableAttributedString()
            let min = NSMutableAttributedString(string: "Minor ID Header : ", attributes: stringAttributes)
            let minData = NSMutableAttributedString.init(string: String(format: "0x%02X", packet[1]))
           
            let maj = NSMutableAttributedString(string: "Major ID Header : ", attributes: stringAttributes)
            let majData = NSMutableAttributedString.init(string: String(format: "0x%02X", packet[0]))

            var dt = packet
            dt.removeFirst(2)
            let payload =  NSMutableAttributedString(string: "Payload : ", attributes: stringAttributes)
            let payloadData = NSMutableAttributedString.init(string:  dt.hexEncodedString())
            

            
            let evenetName = NSMutableAttributedString(string: "Event: ", attributes: stringAttributes)
            let evetData = NSMutableAttributedString.init(string:  event)
            
            combination.append(space)
            combination.append(space)
            combination.append(timeAttrString)
            combination.append(space)
            combination.append(evenetName)
            combination.append(evetData)
            combination.append(space)
            combination.append(maj)
            combination.append(majData)
            combination.append(space)
            combination.append(min)
            combination.append(minData)
            combination.append(space)
//            combination.append(ack)
//            combination.append(ackData)
//            combination.append(space)
            combination.append(payload)
            combination.append(payloadData)

         //   let finalInfo = time + "\n" + evenetName + "\n" + maj + "\n" + min + "\n" +  ack + "\n" + payload
            
            let myRange = NSRange(location: 0, length: combination.length)
            combination.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.black], range: myRange)
            DispatchQueue.global().async {
                self.packetsArray.append(combination)
            }
        }
        
    }
    
    
    
    
    func setPeripheralPairedStatus(_ packetInfo: [Data], event: String){
        let time = getCurrentTime()
        let stringAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12.0)
                               ]
        let space = NSAttributedString.init(string: "\n")
        let timeAttrString = NSMutableAttributedString(string: time, attributes: stringAttributes)
        for packet in packetInfo{

            let combination = NSMutableAttributedString()
            let min = NSMutableAttributedString(string: "Minor ID Header : ", attributes: stringAttributes)
            let minData = NSMutableAttributedString.init(string: String(format: "0x%02X", packet[1]))
           
            let maj = NSMutableAttributedString(string: "Major ID Header : ", attributes: stringAttributes)
            let majData = NSMutableAttributedString.init(string: String(format: "0x%02X", packet[0]))

            var dt = packet
            dt.removeFirst(2)
            let payload =  NSMutableAttributedString(string: "Payload : ", attributes: stringAttributes)
            let payloadData = NSMutableAttributedString.init(string:  dt.hexEncodedString())
            
            let r = Range.init(NSRange.init(location: 2, length: 1))
            let deviceIDdata = packet.subdata(in: r!)
            let CurrentDeviceId =  NSMutableAttributedString(string: "Current Device ID : ", attributes: stringAttributes)
            let deviceID = NSMutableAttributedString.init(string:  deviceIDdata.hexEncodedString())
            self.pairID = deviceIDdata.hexEncodedString()
            
            let pairingKeydata = packet.subdata(in: Range.init(NSRange.init(location: 3, length: 4))!)
            let painringKey =  NSMutableAttributedString(string: "Pairing Key : ", attributes: stringAttributes)
            let pairingKeyID = NSMutableAttributedString.init(string:  pairingKeydata.hexEncodedString())
            
            let evenetName = NSMutableAttributedString(string: "Event: ", attributes: stringAttributes)
            let evetData = NSMutableAttributedString.init(string:  event)
            combination.append(space)
            combination.append(space)
            combination.append(timeAttrString)
            combination.append(space)
            combination.append(evenetName)
            combination.append(evetData)
            combination.append(space)
            combination.append(maj)
            combination.append(majData)
            combination.append(space)
            combination.append(min)
            combination.append(minData)
            combination.append(space)
//            combination.append(ack)
//            combination.append(ackData)
//            combination.append(space)
            combination.append(payload)
            combination.append(payloadData)
            combination.append(space)
            combination.append(CurrentDeviceId)
            combination.append(deviceID)
            combination.append(space)
            combination.append(painringKey)
            combination.append(pairingKeyID)
         //   let finalInfo = time + "\n" + evenetName + "\n" + maj + "\n" + min + "\n" +  ack + "\n" + payload
            
            let myRange = NSRange(location: 0, length: combination.length)
            combination.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.black], range: myRange)
            DispatchQueue.global().async {
                self.packetsArray.append(combination)
            }
        }
        
    }
    
    func showPeripheralCurrentStatus(_ packetInfo: [Data], event: String){
        let time = getCurrentTime()
        let stringAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12.0)
                               ]
        let space = NSAttributedString.init(string: "\n")
        let timeAttrString = NSMutableAttributedString(string: time, attributes: stringAttributes)
        for packet in packetInfo{

            let combination = NSMutableAttributedString()
            let min = NSMutableAttributedString(string: "Minor ID Header : ", attributes: stringAttributes)
            let minData = NSMutableAttributedString.init(string: String(format: "0x%02X", packet[1]))
           
            let maj = NSMutableAttributedString(string: "Major ID Header : ", attributes: stringAttributes)
            let majData = NSMutableAttributedString.init(string: String(format: "0x%02X", packet[0]))

            var dt = packet
            dt.removeFirst(2)
            let payload =  NSMutableAttributedString(string: "Payload : ", attributes: stringAttributes)
            let payloadData = NSMutableAttributedString.init(string:  dt.hexEncodedString())
            
 
            let powerData = packet.subdata(in: Range.init(NSRange.init(location: 2, length: 1))!)
            let powerModel =  NSMutableAttributedString(string: "Current Power Mode : ", attributes: stringAttributes)
            let powerModeID = NSMutableAttributedString.init(string:  powerData.hexEncodedString())
            
            let exceptionData = packet.subdata(in: Range.init(NSRange.init(location: 3, length: 1))!)
            let exception =  NSMutableAttributedString(string: "Exception occurred state : ", attributes: stringAttributes)
            let exceptionID = NSMutableAttributedString.init(string:  exceptionData.hexEncodedString())
            
            let bleLengthData = packet.subdata(in: Range.init(NSRange.init(location: 4, length: 2))!)
            let bleModel =  NSMutableAttributedString(string: "Max BLE payload length : ", attributes: stringAttributes)
            let bleID = NSMutableAttributedString.init(string:  bleLengthData.hexEncodedString())
            
            let evenetName = NSMutableAttributedString(string: "Event: ", attributes: stringAttributes)
            let evetData = NSMutableAttributedString.init(string:  event)
            combination.append(space)
            combination.append(space)
            combination.append(timeAttrString)
            combination.append(space)
            combination.append(evenetName)
            combination.append(evetData)
            combination.append(space)
            combination.append(maj)
            combination.append(majData)
            combination.append(space)
            combination.append(min)
            combination.append(minData)
            combination.append(space)

            combination.append(payload)
            combination.append(payloadData)
            combination.append(space)
            combination.append(powerModel)
            combination.append(powerModeID)
            combination.append(space)
            combination.append(exception)
            combination.append(exceptionID)
            combination.append(space)
            combination.append(bleModel)
            combination.append(bleID)

            let myRange = NSRange(location: 0, length: combination.length)
            combination.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.black], range: myRange)
            DispatchQueue.global().async {
                self.packetsArray.append(combination)
            }
        }
    }
    
    func showCanNotConnectReasons(_ event: String, reason: String, description: String){
        let time = getCurrentTime()
        let stringAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12.0)
                               ]
        let timeAttrString = NSMutableAttributedString(string: time, attributes: stringAttributes)
        let space = NSAttributedString.init(string: "\n")
      
        let deviceCount = NSMutableAttributedString()

        
        let evenetName = NSMutableAttributedString(string: "Event: ", attributes: stringAttributes)
        let evetData = NSMutableAttributedString.init(string:  event)
      
        let reasonName = NSMutableAttributedString(string: "Reason: ", attributes: stringAttributes)
        let reasonData = NSMutableAttributedString.init(string:  reason)
        
        deviceCount.append(space)
        deviceCount.append(timeAttrString)
        deviceCount.append(space)
        deviceCount.append(evenetName)
        deviceCount.append(evetData)
        deviceCount.append(space)
        deviceCount.append(reasonName)
        deviceCount.append(reasonData)


        if !description.isEmpty{
            let desc = NSMutableAttributedString(string: "Description: ", attributes: stringAttributes)
            let descData = NSMutableAttributedString.init(string:  description)
            deviceCount.append(space)
            deviceCount.append(desc)
            deviceCount.append(descData) //+ "\nCurrentPairedCentralDeviceId: " + currentDevicePairID
        }
        
        self.packetsArray.append(deviceCount)

    }
    
    
    func showDeviceInfo(_ deviceInfo: [[String: Any]], event: String, description: String){
        let time = getCurrentTime()
        let stringAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12.0)
                               ]
        let timeAttrString = NSMutableAttributedString(string: time, attributes: stringAttributes)
        let space = NSAttributedString.init(string: "\n")
      
        let deviceCount = NSMutableAttributedString()
        let listSize = NSMutableAttributedString(string: "listSize : ", attributes: stringAttributes)
        let listCount = NSMutableAttributedString.init(string: String(deviceInfo.count))
        
        let evenetName = NSMutableAttributedString(string: "Event: ", attributes: stringAttributes)
        let evetData = NSMutableAttributedString.init(string:  event)
      
        deviceCount.append(space)
        deviceCount.append(timeAttrString)
        deviceCount.append(space)
        deviceCount.append(evenetName)
        deviceCount.append(evetData)
        deviceCount.append(space)
        
        deviceCount.append(listSize)
        deviceCount.append(listCount)
        self.packetsArray.append(deviceCount)

        var i = 0
        for device in deviceInfo{
            
            let combination = NSMutableAttributedString()
            
            let name = NSMutableAttributedString(string: "Device\(i).deviceName : ", attributes: stringAttributes)
            let nameData = NSMutableAttributedString.init(string: device["device_name"] as! String)
          
            let uuid = NSMutableAttributedString(string: "Device\(i).NSUUID : ", attributes: stringAttributes)
            let uuidData = NSMutableAttributedString.init(string: device["identifier"] as! String)
           
//            let id = NSMutableAttributedString(string: "Device\(i).assignedPairedDeviceID : ", attributes: stringAttributes)
//            let idData = NSMutableAttributedString.init(string: device["id"] as! String)
//
//            let paringKey =  NSMutableAttributedString(string: "Device0.assignedPairingKey : ", attributes: stringAttributes)
//            let pairingKeyData = NSMutableAttributedString.init(string:  device["pairingKey"] as! String)
            
            combination.append(space)
            combination.append(name)
            combination.append(nameData)
            combination.append(space)
            combination.append(uuid)
            combination.append(uuidData)
//            combination.append(space)
//            combination.append(id)
//            combination.append(idData)
//            combination.append(space)
//            combination.append(paringKey)
//            combination.append(pairingKeyData)

            let myRange = NSRange(location: 0, length: combination.length)
            combination.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.black], range: myRange)
            i += 1
            if !description.isEmpty{
                let desc = NSMutableAttributedString(string: "Description: ", attributes: stringAttributes)
                let descData = NSMutableAttributedString.init(string:  description)
                combination.append(space)
                combination.append(desc)
                combination.append(descData) //+ "\nCurrentPairedCentralDeviceId: " + currentDevicePairID
            }
            self.packetsArray.append(combination)
        }
    }
    
    
    func showSystemInfo(_ packetInfo: [Data], event: String){
        let time = getCurrentTime()
        let stringAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12.0)
                               ]
        let space = NSAttributedString.init(string: "\n")
        let timeAttrString = NSMutableAttributedString(string: time, attributes: stringAttributes)
        for packet in packetInfo{

            let combination = NSMutableAttributedString()
            let min = NSMutableAttributedString(string: "Minor ID Header : ", attributes: stringAttributes)
            let minData = NSMutableAttributedString.init(string: String(format: "0x%02X", packet[1]))
           
            let maj = NSMutableAttributedString(string: "Major ID Header : ", attributes: stringAttributes)
            let majData = NSMutableAttributedString.init(string: String(format: "0x%02X", packet[0]))

            var dt = packet
            dt.removeFirst(2)
            let payload =  NSMutableAttributedString(string: "Payload : ", attributes: stringAttributes)
            let payloadData = NSMutableAttributedString.init(string:  dt.hexEncodedString())
            
            let evenetName = NSMutableAttributedString(string: "Event: ", attributes: stringAttributes)
            let evetData = NSMutableAttributedString.init(string:  event)
            combination.append(space)
            combination.append(space)
            combination.append(timeAttrString)
            combination.append(space)
            combination.append(evenetName)
            combination.append(evetData)
            combination.append(space)
            combination.append(maj)
            combination.append(majData)
            combination.append(space)
            combination.append(min)
            combination.append(minData)
            combination.append(space)
            combination.append(payload)
            combination.append(payloadData)
            combination.append(space)
            
            var count = 2
            
            for i in systemInfo{

                print(count)
                let range = Range.init(NSRange.init(location: count, length: i.byteCount))!
                let infoData = packet.subdata(in: range)
                let info = NSMutableAttributedString.init(string:  i.Info + ": " )
                print(infoData)
                let infoID = NSMutableAttributedString(string: infoData.hexEncodedString(), attributes: stringAttributes)
                count += i.byteCount
                combination.append(space)
                combination.append(info)
                combination.append(infoID)
            }
  
            let myRange = NSRange(location: 0, length: combination.length)
            combination.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.black], range: myRange)
            DispatchQueue.global().async {
                self.packetsArray.append(combination)
            }
        }
    }
    
    func setInvalidState(_ text: String){
        let time = getCurrentTime()
    //    DispatchQueue.global().async {
            
            var stringAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                    NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12.0)
                                   ]
            
            let combination = NSMutableAttributedString()
            let space = NSAttributedString.init(string: "\n")
            
            let timeAttrString = NSMutableAttributedString(string: time, attributes: stringAttributes)
            let state =  NSMutableAttributedString(string: "State: ", attributes: stringAttributes)
            let stateData = NSMutableAttributedString.init(string: text)
            combination.append(space)
            combination.append(space)
            combination.append(timeAttrString)
            combination.append(space)
            combination.append(state)
            combination.append(stateData)
        //    let finalInfo =  time + "\n" + "CALL: " + callingFunctions
            self.packetsArray.append(combination)
  //      }
    }
    
    func showPeripheralPrioritiesEventInfo(_ packetInfo: Data, event: String, description: String){
        let time = getCurrentTime()
        let stringAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12.0)
                               ]
        let space = NSAttributedString.init(string: "\n")
        let timeAttrString = NSMutableAttributedString(string: time, attributes: stringAttributes)
    //    for packet in packetInfo{

            let combination = NSMutableAttributedString()
//            let min = NSMutableAttributedString(string: "Minor ID Header : ", attributes: stringAttributes)
//            let minData = NSMutableAttributedString.init(string: String(format: "0x%02X", packet[1]))
//
//            let maj = NSMutableAttributedString(string: "Major ID Header : ", attributes: stringAttributes)
//            let majData = NSMutableAttributedString.init(string: String(format: "0x%02X", packet[0]))

            var dt = packetInfo
//            let payload =  NSMutableAttributedString(string: "Payload : ", attributes: stringAttributes)
//            let payloadData = NSMutableAttributedString.init(string:  dt.hexEncodedString())
            let range1 = Range.init(NSRange.init(location: 0, length: 1))!
            let p1 = dt.subdata(in: range1)
            let priority1 =  NSMutableAttributedString(string: "Priority 1 : ", attributes: stringAttributes)
            let priority1Data = NSMutableAttributedString.init(string:  self.getPriority(p1.hexEncodedString()))
        
            let range2 = Range.init(NSRange.init(location: 1, length: 1))!
            let p2 = dt.subdata(in: range2)
            let priority2 =  NSMutableAttributedString(string: "Priority 2 : ", attributes: stringAttributes)
            let priority2Data = NSMutableAttributedString.init(string:  self.getPriority(p2.hexEncodedString()))
           
            let range3 = Range.init(NSRange.init(location: 2, length: 1))!
            let p3 = dt.subdata(in: range3)
            let priority3 =  NSMutableAttributedString(string: "Priority 3 : ", attributes: stringAttributes)
            let priority3Data = NSMutableAttributedString.init(string:  self.getPriority(p3.hexEncodedString()))

            
        
        
            let evenetName = NSMutableAttributedString(string: "Event: ", attributes: stringAttributes)
            let evetData = NSMutableAttributedString.init(string:  event)
            
            combination.append(space)
            combination.append(space)
            combination.append(timeAttrString)
            combination.append(space)
            combination.append(evenetName)
            combination.append(evetData)
            combination.append(space)
            combination.append(priority1)
            combination.append(priority1Data)
            combination.append(space)
            combination.append(priority2)
            combination.append(priority2Data)
            combination.append(space)
            combination.append(priority3)
            combination.append(priority3Data)
        
            if !description.isEmpty{
                let desc = NSMutableAttributedString(string: "Description: ", attributes: stringAttributes)
                let descData = NSMutableAttributedString.init(string:  description)
                combination.append(space)
                combination.append(desc)
                combination.append(descData) //+ "\nCurrentPairedCentralDeviceId: " + currentDevicePairID
            }
        
         //   let finalInfo = time + "\n" + evenetName + "\n" + maj + "\n" + min + "\n" +  ack + "\n" + payload
            
//            let myRange = NSRange(location: 0, length: combination.length)
//            combination.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.blue], range: myRange)
            DispatchQueue.global().async {
                self.packetsArray.append(combination)
            }
 //       }
        
    }
    func getPriority(_ dataString: String)-> String{
        print(dataString)
        if dataString == "01"{
            return "Reduce Power"
        }
        else if dataString == "02"{
            return "Increase Throughput"
        }
        else {
            return "Improve Range"
        }
        
    }
    func setFirmwareUpdateLog(event: String, description: String){
        let time = getCurrentTime()
 
            var stringAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                    NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12.0)
                                   ]
            
//            if SWAction.sendInternalData == SWAction.init(rawValue: callingFunctions){
//                stringAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blue,
//                                        NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12.0)
//                                       ]
//            }
//
            let combination = NSMutableAttributedString()
            let space = NSAttributedString.init(string: "\n")
            
            let timeAttrString = NSMutableAttributedString(string: time, attributes: stringAttributes)
            let eventHead =  NSMutableAttributedString(string: "Event: ", attributes: stringAttributes)
            let eventData = NSMutableAttributedString.init(string: event)
            let desciption = NSMutableAttributedString.init(string: description)
            
            combination.append(space)
            combination.append(space)
            combination.append(timeAttrString)
            combination.append(space)
            combination.append(eventHead)
            combination.append(eventData)
            combination.append(space)
            combination.append(desciption)

            self.packetsArray.append(combination)

    }
    
    func setActionInfo(_ callingFunctions: String, param: String){
        let time = getCurrentTime()
   //     DispatchQueue.global().async {
            
            var stringAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                    NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12.0)
                                   ]
            
            if SWAction.sendInternalData == SWAction.init(rawValue: callingFunctions){
                stringAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                        NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12.0)
                                       ]
            }
            
            let combination = NSMutableAttributedString()
            let space = NSAttributedString.init(string: "\n")
            
            let timeAttrString = NSMutableAttributedString(string: time, attributes: stringAttributes)
            let call =  NSMutableAttributedString(string: "CALL: ", attributes: stringAttributes)
            let callData = NSMutableAttributedString.init(string: "SWLCentral."+callingFunctions, attributes: stringAttributes)
            combination.append(space)
            combination.append(space)
            combination.append(timeAttrString)
            combination.append(space)
            combination.append(call)
            combination.append(callData)
            
            
            if !param.isEmpty{
                let attributedParam = NSMutableAttributedString.init(string: param, attributes: stringAttributes)
                combination.append(attributedParam)
            }
            
        //    let finalInfo =  time + "\n" + "CALL: " + callingFunctions
            self.packetsArray.append(combination)
   //     }
    }
    
    func setupUI(){
        
        packetTableView.layer.borderWidth = 2.0
        packetTableView.layer.borderColor = UIColor.lightGray.cgColor
        saveFileButton.layer.cornerRadius = 5.0 * (UIScreen.main.bounds.height/568)
        clearLogButton.layer.cornerRadius = 5.0 * (UIScreen.main.bounds.height/568)
        autoScrollButton.layer.cornerRadius = 5.0 * (UIScreen.main.bounds.height/568)
        topBackView.layer.cornerRadius = 3.0
    }

    @objc func swipeAction(recognizer: UISwipeGestureRecognizer) {
        

        if recognizer.direction == .up{
            
            let y = CGFloat(0.0)//CGFloat(100.0)
            let height = UIScreen.main.bounds.height - y
            UIView.animate(withDuration: 0.2,
            delay: 0.1,
            options: UIView.AnimationOptions.curveEaseIn,
            animations: {
                self.viewTopConstant.constant = 180
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0.2) //init(red: 1, green: 1, blue: 1, alpha: 0.2)
                self.view.frame = CGRect(x: 0, y: y, width: UIScreen.main.bounds.width, height: CGFloat(height))
                self.view.layoutIfNeeded()
            },completion: nil)
        }
        else if recognizer.direction == .down{
            
            let y = (UIScreen.main.bounds.height - CGFloat(viewInitialHeight))
            UIView.animate(withDuration: 0.2,
            delay: 0.1,
            options: UIView.AnimationOptions.curveEaseIn,
            animations: {
                self.viewTopConstant.constant = 0
                self.view.backgroundColor = UIColor.clear
                self.view.frame = CGRect(x: 0, y: y, width: UIScreen.main.bounds.width, height: CGFloat(viewInitialHeight))
                self.view.layoutIfNeeded()
            },completion: nil)
        }
    }
}
extension LOGViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return packetsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PacketInfoTableViewCell", for: indexPath) as! PacketInfoTableViewCell
        cell.packetLabel.attributedText = self.packetsArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
}






 
extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }

    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return self.map { String(format: format, $0) }.joined()
    }
}
