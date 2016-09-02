//
//  imageViewController.swift
//  Cassini
//
//  Created by CAOYE on 8/26/16.
//  Copyright © 2016 CAOYE. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    // Model
    var imageURL: NSURL? {
        didSet {
            image = nil
            if view.window != nil { // on screen
                fetchImage()
            }
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // Network operation
    private func fetchImage() {
        if let url = imageURL {
            spinner?.startAnimating()
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
                let imageData = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue(), {
                    if url == self.imageURL {
                        if (imageData != nil) {
                            self.image = UIImage(data: imageData!)
                        } else {
                            self.image = nil
                        }
                    }
                })
            }
        } else { image = UIImage(named: "welcome") }
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 1
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    // Create view programingly
    private var imageView = UIImageView()
    
    private var image: UIImage? {
        get { return imageView.image }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            spinner?.stopAnimating()
        }
    }
    
    // outlet already set
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil { fetchImage() } // just before on screen
    }
}
