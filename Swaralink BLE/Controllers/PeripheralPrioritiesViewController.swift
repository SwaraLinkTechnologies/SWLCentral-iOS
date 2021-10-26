//
//  PeripheralPrioritiesViewController.swift
//  Swaralink BLE
//
//  Created by Dushyant Varshney on 23/06/22.
//

import UIKit

class PeripheralPrioritiesViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var priorityFirstRangeImgView: UIImageView!
    @IBOutlet weak var priorityFirstThroughputImgView: UIImageView!
    @IBOutlet weak var priorityFirstPowerImgView: UIImageView!
    
    @IBOutlet weak var priorityFirstRangeButton: UIButton!
    @IBOutlet weak var priorityFirstThroughputButton: UIButton!
    @IBOutlet weak var priorityFirstPowerButton: UIButton!
    
    
    @IBOutlet weak var prioritySecondRangeImgView: UIImageView!
    @IBOutlet weak var prioritySecondThroughputImgView: UIImageView!
    @IBOutlet weak var prioritySecondPowerImgView: UIImageView!
    
    @IBOutlet weak var prioritySecondRangeButton: UIButton!
    @IBOutlet weak var prioritySecondThroughputButton: UIButton!
    @IBOutlet weak var prioritySecondPowerButton: UIButton!
    
    
    @IBOutlet weak var priorityThirdRangeImgView: UIImageView!
    @IBOutlet weak var priorityThirdThroughputImgView: UIImageView!
    @IBOutlet weak var priorityThirdPowerImgView: UIImageView!
    
    @IBOutlet weak var priorityThirdRangeButton: UIButton!
    @IBOutlet weak var priorityThirdThroughputButton: UIButton!
    @IBOutlet weak var priorityThirdPowerButton: UIButton!
    
    @IBOutlet weak var setPrioritiesButton: UIButton!
    
    var swlConection =  SWLConnection.shared
    
    var priorityFirst = 0
    var prioritySecond = 0
    var priorityThird = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StaticHelper.shared.addLogViewController(self)
        descLabel.attributedText = SWLConstants().setPeripheralPrioritesDesc.getFunctionDescription()
    }
    
    func updatUI(){
        
        switch priorityFirst {
        case 1:
            priorityFirstRangeImgView.image = UIImage.init(named: "radio_btn_selected")
            priorityFirstThroughputImgView.image = UIImage.init(named: "radio_btn_unselected")
            priorityFirstPowerImgView.image = UIImage.init(named: "radio_btn_unselected")
        case 2:
            priorityFirstRangeImgView.image = UIImage.init(named: "radio_btn_unselected")
            priorityFirstThroughputImgView.image = UIImage.init(named: "radio_btn_selected")
            priorityFirstPowerImgView.image = UIImage.init(named: "radio_btn_unselected")
        case 3:
            priorityFirstRangeImgView.image = UIImage.init(named: "radio_btn_unselected")
            priorityFirstThroughputImgView.image = UIImage.init(named: "radio_btn_unselected")
            priorityFirstPowerImgView.image = UIImage.init(named: "radio_btn_selected")
        default:
            break
        }
        
        
        switch prioritySecond {
        case 1:
            prioritySecondRangeImgView.image = UIImage.init(named: "radio_btn_selected")
            prioritySecondThroughputImgView.image = UIImage.init(named: "radio_btn_unselected")
            prioritySecondPowerImgView.image = UIImage.init(named: "radio_btn_unselected")
        case 2:
            prioritySecondRangeImgView.image = UIImage.init(named: "radio_btn_unselected")
            prioritySecondThroughputImgView.image = UIImage.init(named: "radio_btn_selected")
            prioritySecondPowerImgView.image = UIImage.init(named: "radio_btn_unselected")
        case 3:
            prioritySecondRangeImgView.image = UIImage.init(named: "radio_btn_unselected")
            prioritySecondThroughputImgView.image = UIImage.init(named: "radio_btn_unselected")
            prioritySecondPowerImgView.image = UIImage.init(named: "radio_btn_selected")
        default:
            break
        }
        
        switch priorityThird  {
        case 1:
            priorityThirdRangeImgView.image = UIImage.init(named: "radio_btn_selected")
            priorityThirdThroughputImgView.image = UIImage.init(named: "radio_btn_unselected")
            priorityThirdPowerImgView.image = UIImage.init(named: "radio_btn_unselected")
        case 2:
            priorityThirdRangeImgView.image = UIImage.init(named: "radio_btn_unselected")
            priorityThirdThroughputImgView.image = UIImage.init(named: "radio_btn_selected")
            priorityThirdPowerImgView.image = UIImage.init(named: "radio_btn_unselected")
        case 3:
            priorityThirdRangeImgView.image = UIImage.init(named: "radio_btn_unselected")
            priorityThirdThroughputImgView.image = UIImage.init(named: "radio_btn_unselected")
            priorityThirdPowerImgView.image = UIImage.init(named: "radio_btn_selected")
        default:
            break
        }
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true
        )
    }

    @IBAction func setPriorityAction(_ sender: UIButton) {
        if priorityFirst == 0 || prioritySecond == 0 || priorityThird == 0{
            let alert = UIAlertController.init(title: "", message: "Please select all priorities.", preferredStyle: .alert)
            let action = UIAlertAction.init(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let pr = String.init(format: "%02d", priorityFirst) +
                     String.init(format: "%02d", prioritySecond) +
                     String.init(format: "%02d", priorityThird)
            print(pr)
            swlConection.setPeripheralPriorities(priorities: pr)
        }
       
    }
    
    @IBAction func priorityAction(_ sender: UIButton) {
        print(sender.tag)
        if sender.tag >= 1, sender.tag<=3{
            priorityFirst = sender.tag
        }
        else if sender.tag >= 4, sender.tag<=6{
            prioritySecond = sender.tag - 3
        }
        else if sender.tag >= 7, sender.tag<=9{
            priorityThird = sender.tag - 6
        }
        updatUI()
        
    }
}
