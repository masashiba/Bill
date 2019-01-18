//
//  BoughtTableView.swift
//  Cash Register
//
//  Created by 芝本　将豊 on 2019/01/17.
//  Copyright © 2019 芝本　将豊. All rights reserved.
//

import Foundation
import UIKit

class BoughtTableView: UITableView {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
