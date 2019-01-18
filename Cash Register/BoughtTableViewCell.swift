//
//  BoughtTableViewCell.swift
//  Cash Register
//
//  Created by 芝本　将豊 on 2018/12/22.
//  Copyright © 2018 芝本　将豊. All rights reserved.
//

import UIKit

class BoughtTableViewCell: UITableViewCell {

    //買った商品の情報を書くためのラベル
    @IBOutlet var NameLabel: UILabel!
    @IBOutlet var CountLabel: UILabel!
    @IBOutlet var PriceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
