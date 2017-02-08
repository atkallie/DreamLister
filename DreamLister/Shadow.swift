//
//  Shadow.swift
//  DreamLister
//
//  Created by Ahmed T Khalil on 2/7/17.
//  Copyright © 2017 kalikans. All rights reserved.
//

import UIKit

private var materialSetting:Bool = false

extension UIView {

    @IBInspectable var materialDesign: Bool{
        get{
            return materialSetting
        }
        set{
            
            materialSetting = newValue
            
            if materialSetting{
                self.layer.masksToBounds = false
                self.layer.cornerRadius = 3.0
                self.layer.shadowRadius = 3.0
                self.layer.shadowOpacity = 0.8
                self.layer.shadowColor = UIColor(colorLiteralRed: 157/255, green: 157/255, blue: 157/255, alpha: 1.0).cgColor
                self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                
            }else{
                self.layer.cornerRadius = 0
                self.layer.shadowOpacity = 0
                self.layer.shadowRadius = 0
                self.layer.shadowColor = nil
            }
        }
    }

}
