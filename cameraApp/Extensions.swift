//
//  Extensions.swift
//  cameraApp
//
//  Created by shishir sapkota on 12/21/16.
//  Copyright © 2016 shishir sapkota. All rights reserved.
//

import UIKit


extension UIButton {
    func set(title: String) {
        self.setTitle(title, for: .normal)
    }
}

extension UIViewController {
    func push(inNavigation controller: UIViewController) {
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
