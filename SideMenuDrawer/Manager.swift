//
//  Manager.swift
//  SideMenuDrawer
//
//  Created by IosDeveloper on 31/01/18.
//  Copyright © 2018 iOSDeveloper. All rights reserved.
//

import Foundation
import UIKit

struct Manager
{
    ///Side Menu Index Status
    static var sideIndex = Int()
    
}

//MARK:- UIViewController Extension
extension UIViewController
{
    //MARK: Toast Message
    func showToast(message : String)
    {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-(self.view.frame.size.height*0.1), width: 150, height: 25))
        toastLabel.backgroundColor = UIColor.black
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        toastLabel.adjustsFontSizeToFitWidth = true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
