//
//  CustomTableViewCell.swift
//  Cash Register
//
//  Created by 芝本　将豊 on 2018/12/14.
//  Copyright © 2018 芝本　将豊. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    //商品名、値段、購入数を表示するラベルの宣言
    @IBOutlet var NameLabel: UILabel!
    @IBOutlet var PriceLabel: UILabel!
    @IBOutlet var CountLabel: UILabel!
    @IBOutlet var stepper: UIStepper!
    
    //ステッパーが押された時、購入数を1増やして表示させる
    @IBAction func changeStepperValue(stepper: UIStepper) {
        CountLabel.text = String(Int(stepper.value))
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NameLabel.font = UIFont(name: "HiraginoSans-W3", size: self.contentView.frame.size.height / 5)
        PriceLabel.font = UIFont(name: "HiraginoSans-W3", size: self.contentView.frame.size.height / 5)
        CountLabel.font = UIFont(name: "HiraginoSans-W3", size: self.contentView.frame.size.height / 5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
