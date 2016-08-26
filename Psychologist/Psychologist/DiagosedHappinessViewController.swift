 //
//  DiagosedHappinessViewController.swift
//  Psychologist
//
//  Created by CAOYE on 8/24/16.
//  Copyright © 2016 CAOYE. All rights reserved.
//

import UIKit
 
class DiagnosedHappinessViewController: HappinessViewController, UIPopoverPresentationControllerDelegate {
    
    override var happiness: Int {
        didSet {
            diagnosticHistory += [happiness]
        }
    }
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    var diagnosticHistory: [Int] {
        // segue will create a new instance each time and get from NSUserDefaults
        get { return defaults.objectForKey(History.DefaultsKey) as? [Int] ?? [] }
        
        // save diagosticHistory into NSUserDefaults
        set { defaults.setObject(newValue, forKey: History.DefaultsKey) }
    }
    
    private struct History {
        static let SegueIdentifier = "Show Diagnostic History"
        static let DefaultsKey = "DiagnosedHappinessViewController.History"
    }
    
    // popover segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case History.SegueIdentifier:
                if let tvc = segue.destinationViewController as? DiagnosisViewController {
                    
                    if let ppc = tvc.popoverPresentationController {
                        ppc.delegate = self
                    }
                    
                    tvc.text = "\(diagnosticHistory)"
                }
            default: break
            }
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        // do not adapt for iPhone
        // use popover segue instead of present modally(full screen)
        return UIModalPresentationStyle.None
    }
}
