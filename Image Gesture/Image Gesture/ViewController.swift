//
//  ViewController.swift
//  Image Gesture
//
//  Created by srk on 03/07/21.
//  Copyright © 2021 Nikunj. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @objc func selectimage() {
        print("image click")
        let imgcontroller = UIImagePickerController()
        imgcontroller.delegate = self
        imgcontroller.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imgcontroller, animated: true, completion: nil)
    }
    
    @objc func pinchaction(_ recognizer:UIPinchGestureRecognizer) {
        print("pinch clicked")
        self.view.bringSubviewToFront(ImageView)
        recognizer.view?.transform = (recognizer.view?.transform)!.scaledBy(x: recognizer.scale, y: recognizer.scale)
        pinchgesture.scale = 1.0
    }
    
    @objc func rotateaction(_ rotation:UIRotationGestureRecognizer) {
        if let view = rotation.view {
            view.transform = view.transform.rotated(by: rotation.rotation)
            rotation.rotation = 0
        }
    }
    
    @objc func swipwView(_ sender : UISwipeGestureRecognizer){
        UIView.animate(withDuration: 1.0) {
            if sender.direction == .right { // Swipe right action
                
                self.ImageView.frame = CGRect(x: self.view.frame.size.width - self.ImageView.frame.size.width, y: self.ImageView.frame.origin.y , width: self.ImageView.frame.size.width, height: self.ImageView.frame.size.height)
            }else if sender.direction == .left{ // Swipe left action
                
                self.ImageView.frame = CGRect(x: 0, y: self.ImageView.frame.origin.y , width: self.ImageView.frame.size.width, height: self.ImageView.frame.size.height)
                
            }else if sender.direction == .up{ // Swipe up action
                
                self.ImageView.frame = CGRect(x: self.view.frame.size.width - self.ImageView.frame.size.width, y: 0 , width: self.ImageView.frame.size.width, height: self.ImageView.frame.size.height)
            }else if sender.direction == .down{ // Swipe down action
                
                self.ImageView.frame = CGRect(x: self.view.frame.size.width - self.ImageView.frame.size.width, y: self.view.frame.size.height - self.ImageView.frame.height , width: self.ImageView.frame.size.width, height: self.ImageView.frame.size.height)
            }
            self.ImageView.layoutIfNeeded()
            self.ImageView.setNeedsDisplay()
        }
    }
    
    @objc func panaction(_ panning: UIPanGestureRecognizer){
        self.view.bringSubviewToFront(ImageView)
        let translation = panning.translation(in: self.view)
        ImageView.center = CGPoint(x: ImageView.center.x + translation.x, y: ImageView.center.y + translation.y)
        panning.setTranslation(CGPoint.zero, in: self.view)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        ImageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }

    let ImageView = UIImageView()
    let pinchgesture = UIPinchGestureRecognizer()
    let rotatationgesture = UIRotationGestureRecognizer()
    var swipeGesture  = UISwipeGestureRecognizer()
    var panGesture  = UIPanGestureRecognizer()
    
    private let size: CGFloat = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //image view
        ImageView.image = UIImage(named: "Image")
        ImageView.isUserInteractionEnabled = true
        ImageView.frame = CGRect(x: 100, y: 350, width: size, height: size)
        self.view.addSubview(ImageView)
        
        //tapgesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectimage))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        ImageView.addGestureRecognizer(tap)
        
        //pinchgesture
        ImageView.addGestureRecognizer(pinchgesture)
        pinchgesture.addTarget(self, action: #selector(self.pinchaction(_:)))
        
        //rotation gesture
        ImageView.addGestureRecognizer(rotatationgesture)
        rotatationgesture.addTarget(self, action: #selector(self.rotateaction(_:)))
        
        //swipe gesture
        let directions: [UISwipeGestureRecognizer.Direction] = [.up, .down, .right, .left]
        
        for direction in directions {
            swipeGesture.addTarget(self, action: #selector(self.swipwView(_:)))
            ImageView.addGestureRecognizer(swipeGesture)
            swipeGesture.direction = direction
        }
        
        //pan gesture
        ImageView.addGestureRecognizer(panGesture)
        panGesture.addTarget(self, action: #selector(self.panaction(_:)))
    }

}


