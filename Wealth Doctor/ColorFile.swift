//
//  ColorFile.swift
//  KochiMetro
//
//  Created by Chinnu M V on 4/27/17.
//  Copyright © 2017 Citrus. All rights reserved.
//

import UIKit

class ColorFile: NSObject {
    
    
    
    func getPrimaryColor() -> UIColor{
      return  UIColor(red:0, green:147/255, blue:221/255, alpha:1.0)
    }
    func getMarkerLightAshColor() -> UIColor{
        return  UIColor(red:112, green:112, blue:112, alpha:1.0)
    }
    func getMarkerDarkAshColor() -> UIColor{
        return  UIColor(red:96, green:96, blue:96, alpha:1.0)
    }
}
