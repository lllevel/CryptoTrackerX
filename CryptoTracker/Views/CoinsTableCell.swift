//
//  ItemCell.swift
//  ToTheMoon
//
//  Created by Шевель on 12.07.2018.
//  Copyright © 2018 ShevelAA. All rights reserved.
//

import UIKit

class CoinsTableCell: UITableViewCell {
    
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var percentChange24h: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
