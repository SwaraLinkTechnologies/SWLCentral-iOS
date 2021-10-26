//
//  ButtonTableViewCell.swift
//  Swaralink BLE
//
//  Created by Dushyant Varshney on 23/12/21.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var buttonBkView: UIView!
    @IBOutlet weak var buttonBkImageView: UIImageView!
    @IBOutlet weak var buttonNameLAbel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
