//
//  WaypointImageViewController.swift
//  Trax
//
//  Created by CAOYE on 9/2/16.
//  Copyright © 2016 CAOYE. All rights reserved.
//

import UIKit

class WaypointImageViewController: ImageViewController {

    var waypoint: GPX.Waypoint? {
        didSet {
            imageURL = waypoint?.imageURL
            title = waypoint?.name
            updateEmbeddeMap()
        }
    }
    
    var smvc: SimpleMapViewController?
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Embed Map" {
            smvc = segue.destinationViewController as? SimpleMapViewController
            updateEmbeddeMap()
        }
    }
    
    func updateEmbeddeMap() {
        if let mapView = smvc?.mapView {
            mapView.mapType = .Hybrid
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotation(waypoint!)
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
    }
}
