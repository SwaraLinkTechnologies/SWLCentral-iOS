//
//  UpdateFirmwareViewController.swift
//  Swaralink BLE
//
//  Created by Dushyant Varshney on 29/12/21.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import SWLCentral

class UpdateFirmwareViewController: UIViewController {

    @IBOutlet weak var fileNAmeLAbel: UILabel!
//    var connectionManager = SWConnectionManager.shared
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var fileURL : URL?
 
    var theFileName = ""{
        didSet{
            fileNAmeLAbel.text = "File Name : " + theFileName
        }
    }
    var swlConection =  SWLConnection.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLabel.attributedText = SWLConstants().update_peripheral_firmware_desc.getFunctionDescription()
        StaticHelper.shared.addLogViewController(self)
    }
    
    func selectFiles() {
        let documentPickerController = UIDocumentPickerViewController(documentTypes: ["public.item", "com.apple.iwork.pages.pages", "public.data"], in: .open)


        documentPickerController.delegate = self
        self.present(documentPickerController, animated: true, completion: nil)
//       let types = (UTType.types(tag: "bin",
//                                 tagClass: UTTagClass.filenameExtension,
//                                 conformingTo: nil)) + (UTType.types(tag: "zip",
//                                                                   tagClass: UTTagClass.filenameExtension,
//                                                                   conformingTo: nil))
//
//        let documentPickerController = UIDocumentPickerViewController(
//                forOpeningContentTypes: types)
//
//
//      documentPickerController.delegate = self
//        self.present(documentPickerController, animated: true, completion: nil)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectFileAction(_ sender: UIButton) {
        selectFiles()
    }
    
    @IBAction func updateFirmwareAction(_ sender: UIButton) {
        
        let urlPath = fileURL//Bundle.main.url(forResource: "swl", withExtension: "zip")
        
        
        if urlPath == nil{
            let alert = UIAlertController.init(title: "", message: "Please Select File.", preferredStyle: .alert)
            let action = UIAlertAction.init(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
        if let  url = urlPath{
//            if (StaticHelper.shared.logControllerVC.currentStatusLabel == SWStatusEvents.SWLCentralStateConnected.rawValue){

              let str = "\nFirmware File: " + theFileName
              StaticHelper.shared.logControllerVC.setActionInfo( SWAction.updatePeripheralFirmware.rawValue, param: str)
              let isAccessing = url.startAccessingSecurityScopedResource()
          
              if isAccessing{
                  swlConection.updatePeripheralFirmware(url)
              }
              else{
                  let alert = UIAlertController.init(title: "", message: "You don't have sufficient permission to select this file.",   preferredStyle: .alert)
                  let action = UIAlertAction.init(title: "Ok", style: .cancel, handler: nil)
                  alert.addAction(action)
                  self.present(alert, animated: true, completion: nil)
              }
             
        }
        
       
    }
}

extension UpdateFirmwareViewController: UIDocumentPickerDelegate{
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print(controller)
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        print(url)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(urls)
        
      if let url = urls.first{
      //    var isAccessing = url.startAccessingSecurityScopedResource()
          fileURL = url
          theFileName = url.lastPathComponent
        }
    }
}

