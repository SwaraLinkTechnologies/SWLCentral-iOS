//
//  SetConfigurationProfileViewController.swift
//  Swaralink BLE
//
//  Created by Dushyant Varshney on 19/09/22.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class SetConfigurationProfileViewController: UIViewController {

    
    @IBOutlet weak var fileNameLabel: UILabel!
    var swlConection =  SWLConnection.shared
    var fileURL : URL?
 
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var theFileName = ""{
        didSet{
            self.fileNameLabel.text = "File Name : " + theFileName
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        StaticHelper.shared.addLogViewController(self)
        descriptionLabel.attributedText = SWLConstants().configurationParameters.getFunctionDescription()
        self.navigationController?.isNavigationBarHidden = true

    }
    
    func selectFiles() {
        let documentPickerController = UIDocumentPickerViewController(documentTypes: ["public.item", "com.apple.iwork.pages.pages", "public.data"], in: .open)


        documentPickerController.delegate = self
        self.present(documentPickerController, animated: true, completion: nil)
//       let typesArray = UTType.types(tag: "swlprofile",tagClass: UTTagClass.filenameExtension,
//                                                                   conformingTo: nil)
//        let documentPickerController = UIDocumentPickerViewController(forOpeningContentTypes: typesArray)
//
//
//        documentPickerController.delegate = self
//        self.present(documentPickerController, animated: true, completion: nil)
    }
    
    @IBAction func backAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectFileAction(_ sender: UIButton) {
        selectFiles()
    }
    
    @IBAction func saveInfoAction(_ sender: UIButton) {

     
        let urlPath = fileURL
        
        if urlPath == nil{
            let alert = UIAlertController.init(title: "", message: "Please Select File.", preferredStyle: .alert)
            let action = UIAlertAction.init(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
        if let  url = urlPath{

              let str = "\nJSON File: " + theFileName
          //    StaticHelper.shared.logControllerVC.setActionInfo( SWAction.setConfigurationProfile.rawValue, param: str)
              let isAccessing = url.startAccessingSecurityScopedResource()
          
              if isAccessing{
                  swlConection.setConfigurationProfile(jsonPath: fileURL!)
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

extension SetConfigurationProfileViewController: UIDocumentPickerDelegate{
    
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
