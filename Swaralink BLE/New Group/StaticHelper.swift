//
// File: StaticHelper.h
// Copyright (c) 2021, SwaraLink Technologies
// All Rights Reserved
// Licensed by SwaraLink Technologies, subject to terms of Software License Agreement

import UIKit

class StaticHelper: NSObject {

    static let shared = StaticHelper()
    
    let logControllerVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LOGViewController") as! LOGViewController
    
    func addLogViewController(_ forVC: UIViewController){
     
   //    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LOGViewController") as! LOGViewController
       let bottomSheetVC = logControllerVC

       // Add bottomSheetVC as a child view
        forVC.addChild(bottomSheetVC)
        forVC.view.addSubview(bottomSheetVC.view)
        bottomSheetVC.didMove(toParent: forVC)
       // Adjust bottomSheet frame and initial position.
        let height = forVC.view.frame.height
        let width  = forVC.view.frame.width
        
       bottomSheetVC.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - CGFloat(viewInitialHeight), width: width, height: CGFloat(viewInitialHeight))
       forVC.view.addSubview(bottomSheetVC.view)
    }
}
