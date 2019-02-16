//
//  ViewController.swift
//  Cash Register
//
//  Created by 芝本　将豊 on 2018/11/09.
//  Copyright © 2018 芝本　将豊. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var start : UIButton!
    @IBOutlet var BillLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        start.layer.cornerRadius = UIScreen.main.bounds.size.width * 0.35 * 0.25 //スタートボタンの角を丸くする
        start.titleLabel?.font = UIFont(name: "HiraginoSans-W6", size: UIScreen.main.bounds.size.width * 0.42 * 0.25)
        BillLabel.font = UIFont(name: "GillSans-Bold", size: UIScreen.main.bounds.size.width * 15 / 32)
    }


}

