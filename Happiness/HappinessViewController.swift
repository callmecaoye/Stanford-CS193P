 //
//  HappinessViewController.swift
//  Happiness
//
//  Created by CAOYE on 8/19/16.
//  Copyright © 2016 CAOYE. All rights reserved.
//

import UIKit

class HappinessViewController: UIViewController, FaceViewDataSource {
    
    // Model
    var happiness: Int = 50 { // 0 = sad, 100 = ecstatic
        didSet {
            happiness = min(max(happiness, 0), 100)
            updateUI()
        }
    }
    
    // Controller -> View, through outlet
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            faceView.dataSource = self
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: #selector(FaceView.scale)))
            // faceView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.changeHapiness)))
            // modifies the Model -> handled by controller
        }
    }
    
    func updateUI() {
        faceView.setNeedsDisplay() // redraw FaceView
    }
    
    private struct Constants {
        static let HappinessGestureScale: CGFloat = 4
    }
    
    // gesture from storyboard
    @IBAction func changeHappiness(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = gesture.translationInView(faceView)
            
            // interpret input from View for Model
            let happinessChange = Int(translation.y / Constants.HappinessGestureScale)
            if (happiness != 0) {
                happiness += happinessChange
                gesture.setTranslation(CGPointZero, inView: faceView)
            }
            
        default: break
        }
    }
    
    // FaceViewDataSource protocol method
    func smiliness4FaceView(sender: FaceView) -> Double? {
        // interpret Model for View
        return Double(happiness - 50) / 50
    }

}
