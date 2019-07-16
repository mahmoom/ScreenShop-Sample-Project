//
//  UIView+Extensions.swift
//  ScreenShopProject
//
//  Created by Suhaib Mahmood on 6/28/19.
//  Copyright © 2019 CodingProject. All rights reserved.
//

import UIKit

extension Array where Iterator.Element == CGPoint{
    func intersectionBetweenSegments(p0: CGPoint, _ p1: CGPoint, _ p2: CGPoint, _ p3: CGPoint) -> CGPoint? {
        var denominator = (p3.y - p2.y) * (p1.x - p0.x) - (p3.x - p2.x) * (p1.y - p0.y)
        var ua = (p3.x - p2.x) * (p0.y - p2.y) - (p3.y - p2.y) * (p0.x - p2.x)
        var ub = (p1.x - p0.x) * (p0.y - p2.y) - (p1.y - p0.y) * (p0.x - p2.x)
        if (denominator < 0) {
            ua = -ua; ub = -ub; denominator = -denominator
        }
        
        if ua >= 0.0 && ua <= denominator && ub >= 0.0 && ub <= denominator && denominator != 0 {
            return CGPoint(x: p0.x + ua / denominator * (p1.x - p0.x), y: p0.y + ua / denominator * (p1.y - p0.y))
        }
        
        return nil
    }
    
    func determineIntersect(intersectionCounter: Int? = nil) -> CGPoint?{
        let n = self.count - 1
        guard n >= 1 else {return nil}
        outer: for i in 1 ..< n {
            for j in 0 ..< i-1 {
                //optional parameter in case we expect to run this with dynamic data and want to preserve effeciency
                if let counter = intersectionCounter {
                    if counter != self.count{
                        break outer
                    }
                }
                if let intersection = intersectionBetweenSegments(p0: self[i], self[i+1], self[j], self[j+1]) {
                    return intersection
                }
            }
        }
        return nil
    }
}

