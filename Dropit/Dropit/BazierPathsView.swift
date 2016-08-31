//
//  BazierPathsView.swift
//  Dropit
//
//  Created by CAOYE on 8/30/16.
//  Copyright © 2016 CAOYE. All rights reserved.
//

import UIKit

class BazierPathsView: UIView {

    // Dictionary
    private var bezierPaths = [String:UIBezierPath]()
    
    func setPath(path: UIBezierPath?, named name: String) {
        bezierPaths[name] = path
        setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        for (_, path) in bezierPaths {
            path.stroke()
        }
    }

}
