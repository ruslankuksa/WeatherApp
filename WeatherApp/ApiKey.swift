//
//  ApiKey.swift
//  WeatherApp
//
//  Created by Руслан Кукса on 12/2/18.
//  Copyright © 2018 Ruslan Kuksa. All rights reserved.
//

import Foundation

func APIKey(keyname: String) -> String {
    let filePath = Bundle.main.path(forResource: "Keys", ofType: "plist")
    let plist = NSDictionary(contentsOfFile: filePath!)
    let value = plist?.object(forKey: keyname) as! String
    
    return value
}
