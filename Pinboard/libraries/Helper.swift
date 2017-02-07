//
//  Helper.swift
//  Pinboard
//
//  Created by khaledannajar on 2/6/17.
//  Copyright © 2017 mindvalley. All rights reserved.
//

import UIKit

class Helper {
    
    class func displayAlert(title: String, message: String, inViewController controller: UIViewController) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
        })
        controller.present(alert, animated: true) {}
    }
}
