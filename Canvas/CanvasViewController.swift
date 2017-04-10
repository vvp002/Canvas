//
//  CanvasViewController.swift
//  Canvas
//
//  Created by Vivian Pham on 4/4/17.
//  Copyright © 2017 Vivian Pham. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {

    //Vars for tray offets and points
    var trayOriginalCenter: CGPoint!
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    
    //Vars for new faces added onto Canvas
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    
    //Outlets to the tray and arrow
    @IBOutlet weak var trayView: UIView!
    @IBOutlet weak var arrow: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Initialize the tray offsets
        trayDownOffset = 160
        trayUp = trayView.center
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset)
        
        //Initialize the tap gesture recognizer for the arrow and allow interaction
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(rotateArrow(tapGestureRecognizer:)))
        arrow.isUserInteractionEnabled = true
        arrow.addGestureRecognizer(tapGestureRecognizer)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        
        //Initialize any vars needed to pan the tray or arrow
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(rotateArrow(tapGestureRecognizer:)))
        
        //Set beginning center of tray if haven't dont anything
        if sender.state == .began {
            trayOriginalCenter = trayView.center
        }
            
        //If gesture recognized, then move tray according to it
        else if sender.state == .changed {
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
        }
            
        //Once gesture if finished, return the tray to its original position
        else if sender.state == .ended {
            
            if velocity.y > 0 {
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.trayView.center = self.trayDown
                }, completion: nil)
            }
            else {
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.trayView.center = self.trayUp
                }, completion: nil)
            
            }
        }
        
        //Rotate arrow if tapped on
        rotateArrow(tapGestureRecognizer: tapGestureRecognizer)
    }
    func panningFace (_ sender: UIPanGestureRecognizer) {
        
        //Initialize translation var
        let translation = sender.translation(in: view)
        
        //Check beginning state of newlycreated faces and initiate their center
        if sender.state == .began {
            newlyCreatedFace = sender.view as! UIImageView
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            
            //Scale the face to improve UI
            newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }
            
        //Face is being panned, so moved the face to where it is directed
        else if sender.state == .changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        }
            
        //Face has stopped panning so we end movement with spring animation
        else if sender.state == .ended {
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
                self.newlyCreatedFace.transform = self.newlyCreatedFace.transform.scaledBy(x: 0.7, y: 0.7)
            }, completion: nil)
        }
    }
    
    @IBAction func didPanFace(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        //Create instances for the newly created face that was from the tray
        //and it onto the view
        if sender.state == .began {
            let imageView = sender.view as! UIImageView
            newlyCreatedFace = UIImageView(image: imageView.image)
            view.addSubview(newlyCreatedFace)

            //Scale the face bigger as it is being moved for UI reason
            newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            
            //Add gesture recognizer to allow user to continue panning face later
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panningFace(_:)))
            newlyCreatedFace.isUserInteractionEnabled = true
            newlyCreatedFace.addGestureRecognizer(panGestureRecognizer)
            
        }
        
        //Move the face to where it is being directed to
        else if sender.state == .changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        }
        
        //Stop movement of face with spring animation onto the canvas
        else if sender.state == .ended {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 1, options: [], animations: {
                self.newlyCreatedFace.transform = self.newlyCreatedFace.transform.scaledBy(x: 0.7, y: 0.7)
            }, completion: nil)
            //newlyCreatedFace.transform = CGAffineTransform.identity
        }
    }
    
    func rotateArrow(tapGestureRecognizer: UITapGestureRecognizer) {
        //Rotate the arrow 180 degrees if it was tapped
        arrow.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
