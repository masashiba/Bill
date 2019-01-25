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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        start.layer.cornerRadius = 5.0 //スタートボタンの角を丸くする
    }


}

