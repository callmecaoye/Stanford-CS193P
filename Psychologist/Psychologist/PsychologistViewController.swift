//
//  ViewController.swift
//  Psychologist
//
//  Created by CAOYE on 8/24/16.
//  Copyright © 2016 CAOYE. All rights reserved.
//

import UIKit

class PsychologistViewController: UIViewController {
    
    @IBAction func nothing(sender: UIButton) {
        // perform a segue manually instead of from storyboard
        performSegueWithIdentifier("Nothing", sender: nil)
    }
    
    // show detail segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var destination = segue.destinationViewController
        
        if let navCon = destination as? UINavigationController {
            destination = navCon.visibleViewController! // top of the Stack
        }
        
        if let hvc = destination as? HappinessViewController {
            if let identifier = segue.identifier {
                switch identifier {
                    case "Show Sad": hvc.happiness = 0
                    case "Show Happy": hvc.happiness = 100
                    case "Nothing": hvc.happiness = 25
                    default: hvc.happiness = 50
                }
            }
        }
    } // FaceView outlet has not been set -> faceView? in updateUI()
}

