//
//  CircledArea.swift
//  ScreenShopProject
//
//  Created by Suhaib Mahmood on 6/29/19.
//  Copyright © 2019 CodingProject. All rights reserved.
//

import UIKit

//depending on the API we store data to, we may want to change this
//some are able to interpret arrays of arrays and would be able to
//handle arrays being stored by assigning numerically ascending keys
//i.e. "0", "1"...since I don't know what our API is capable of
//for now I am leaning on Swift 4+ lovely JSON Codable
//any JSON formatting logic I would do here though with a toJSON() -> Data?
struct CircledArea: Codable{
    var imageSize: CGSize
    var pointsArray: [CGPoint?]
    
    func toJSON() -> Data?{
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(self)
        return jsonData
    }
}
