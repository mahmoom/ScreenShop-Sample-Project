//
//  Alert.swift
//  ScreenShopProject
//
//  Created by Suhaib Mahmood on 6/29/19.
//  Copyright © 2019 CodingProject. All rights reserved.
//

import UIKit

class Alert{
    class func showBasic(title: String, message: String, vc:UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert,animated: true)
    }
}
