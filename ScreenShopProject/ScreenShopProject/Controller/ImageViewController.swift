//
//  ImageViewController.swift
//  ScreenShopProject
//
//  Created by Suhaib Mahmood on 6/28/19.
//  Copyright © 2019 CodingProject. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController{
    
    //MARK: - Declare IB Outlets
    @IBOutlet weak var modelImageView: UIImageView!
    
    let path = UIBezierPath()
    struct Constants{
        static let modelPhoto = "modelPhoto"
        static let noSelectionErrorMessage = "You haven't made a valid selection yet!"
        static let noSelectionErrorTitle = "Whoops"
    }
    
    //MARK: Instance Variables
    var lastPoint = CGPoint.zero
    var color = UIColor.black
    var brushWidth: CGFloat = 2.0
    var opacity: CGFloat = 1.0
    var swiped = false
    //array to hold points in vector of user selection
    var allPoints: [CGPoint] = []
    //used to break out of intersection loop when more points added
    var intersectionCounter = 0
    //stores intersection point indicating complete shape
    var intersectionPoint: CGPoint?
    //model object for user selected area
    var selectedArea: CircledArea!
    
    
    //MARK: VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
    }
    
    
    // MARK: - Set up UI
    func setUpNavBar(){
        self.navigationItem.title = "Circle What You Like"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetSelection))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneSelection))
    }
    
    //MARK: - Gesture recognizers
    @objc private func resetSelection(){
        //refresh image and remove current selection
        modelImageView.image = UIImage(named: Constants.modelPhoto)
        allPoints.removeAll()
        selectedArea = nil
        intersectionPoint = nil
    }
    
    @objc private func doneSelection(){
        //print json data of user selection and image scale so vector array has context
        if intersectionPoint != nil{
            //make sure we have context of current scaled image size
            guard let imageSize = modelImageView.image?.size else {return}
            
            //convert data to JSON
            selectedArea = CircledArea(imageSize: imageSize, pointsArray: allPoints)
            guard let data = selectedArea.toJSON() else {return}
            
            //convert JSON to string and print
            let jsonString = String(data: data, encoding: .utf8)
            print(jsonString ?? "No Data")
     
        } else{
            Alert.showBasic(title: Constants.noSelectionErrorTitle, message: Constants.noSelectionErrorMessage, vc: self)
        }
    }
    
    //MARK: - Draw Line Logic
    func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        
        UIGraphicsBeginImageContextWithOptions(modelImageView.bounds.size, true, 0.0)
        let aspect = modelImageView.image!.size.width / modelImageView.image!.size.height
        let rect: CGRect
        if modelImageView.frame.width / aspect > modelImageView.frame.height {
            let height = modelImageView.frame.width / aspect
            rect = CGRect(x: 0, y: (modelImageView.frame.height - height) / 2,
                          width: modelImageView.frame.width, height: height)
        } else {
            let width = modelImageView.frame.height * aspect
            rect = CGRect(x: (modelImageView.frame.width - width) / 2, y: 0,
                          width: width, height: modelImageView.frame.height)
        }
        
        modelImageView.image?.draw(in: rect)


        let context = UIGraphicsGetCurrentContext()
        context?.move(to: fromPoint)
        context?.addLine(to: toPoint)
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushWidth)
        context?.setStrokeColor(color.cgColor)
        context?.setBlendMode(CGBlendMode.normal)
        context?.strokePath()
        
        if fromPoint != toPoint{
            allPoints.append(toPoint)
        }


        modelImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        modelImageView.alpha = opacity
        UIGraphicsEndImageContext()
        
    }
    
    
    // MARK: - Override Gesture Functions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        swiped = false
        resetSelection()
        lastPoint = touch.location(in: modelImageView)
        allPoints.append(lastPoint)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        //if intersection point is found, then stop drawing
        guard intersectionPoint == nil else {
            return
        }
        swiped = true
        let currentPoint = touch.location(in: modelImageView)
        
        //draw only in image bounds
        let boundedRect = modelImageView.bounds
        if boundedRect.contains(currentPoint) && boundedRect.contains(lastPoint){
            drawLine(from: lastPoint, to: currentPoint)
        } else{
            return
        }
        
        lastPoint = currentPoint
        
        //check if interesction exists, but drop previous evaluation if user keeps drawing
        intersectionCounter = allPoints.count
        if let intersectionPoint = allPoints.determineIntersect(intersectionCounter: intersectionCounter){
            self.intersectionPoint = intersectionPoint
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            // draw a single point
            drawLine(from: lastPoint, to: lastPoint)
        }
        
        //check one more time for intersection
        if intersectionPoint == nil{
            intersectionPoint = allPoints.determineIntersect()
        }
    }
    
}
