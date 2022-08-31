//
//  TableViewCell1.swift
//  useCoreDataDemo
//
//  Created by iMac on 27/08/22.
//

import UIKit

class TableViewCell1: UITableViewCell {

    //MARK: - OUTLET
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelUserDesignation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
