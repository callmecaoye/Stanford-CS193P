//
//  EditWaypointViewController.swift
//  Trax
//
//  Created by CS193p Instructor.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit
import MobileCoreServices

class EditWaypointViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    // MARK: - Public API, Modal

    var waypointToEdit: EditableWaypoint? { didSet { updateUI() } }
    
    // MARK: - UI
    
    // TextField
    @IBOutlet private weak var infoTextField: UITextField! { didSet { infoTextField.delegate = self } }
    @IBOutlet private weak var nameTextField: UITextField! { didSet { nameTextField.delegate = self } }
    
    // Image
    var imageView = UIImageView()
    @IBOutlet weak var imageViewContainer: UIView! {
        didSet {
            imageViewContainer.addSubview(imageView)
        }
    }
    
    @IBAction func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let picker = UIImagePickerController()
            picker.sourceType =  .Camera
            // if we were looking for video, we'd check availableMediaTypes
            picker.mediaTypes = [String(kUTTypeImage as NSString)]
            picker.delegate = self
            picker.allowsEditing = true
            presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    // ImagePickerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var image = info[UIImagePickerControllerEditedImage] as? UIImage
        if image == nil {
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        imageView.image = image
        makeRoomForImage()
        saveImageInWaypoint()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction private func done(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // write to file system
    func saveImageInWaypoint()
    {
        if let image = imageView.image {
            // NSData
            if let imageData = UIImageJPEGRepresentation(image, 1.0) {
                let fileManager = NSFileManager()
                // NSURL
                if let docsDir = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first {
                    let unique = NSDate.timeIntervalSinceReferenceDate()
                    let url = docsDir.URLByAppendingPathComponent("\(unique).jpg")
                    let path = url.absoluteString
                    if imageData.writeToURL(url, atomically: true) {
                        waypointToEdit?.links = [GPX.Link(href: path)]
                    }
                }
            }
            
        }
    }
    
    private func updateUI() {
        nameTextField?.text = waypointToEdit?.name
        infoTextField?.text = waypointToEdit?.info
        updateImage()
    }
    
    // MARK: - TextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // hide keyboard after input
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Notification
    
    // cookie
    private var ntfObserver: NSObjectProtocol?
    private var itfObserver: NSObjectProtocol?
    
    private func startObservingTextFields()
    {
        let center = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        ntfObserver = center.addObserverForName(UITextFieldTextDidChangeNotification, object: nameTextField, queue: queue) { notification in
            if let waypoint = self.waypointToEdit {
                waypoint.name = self.nameTextField.text
            }
        }
        itfObserver = center.addObserverForName(UITextFieldTextDidChangeNotification, object: infoTextField, queue: queue) { notification in
            if let waypoint = self.waypointToEdit {
                waypoint.info = self.infoTextField.text
            }
        }
    }
    
    private func stopObservingTextFields()
    {
        if let observer = ntfObserver {
            NSNotificationCenter.defaultCenter().removeObserver(observer)
        }
        if let observer = itfObserver {
            NSNotificationCenter.defaultCenter().removeObserver(observer)
        }
    }
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // show keyboard when view loaded
        nameTextField.becomeFirstResponder()
        updateUI()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        startObservingTextFields()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        stopObservingTextFields()
    }
}

extension EditWaypointViewController
{
    func updateImage() {
        if let url = waypointToEdit?.imageURL {
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0)) { [weak self] in
                if let imageData = NSData(contentsOfURL: url) {
                    if url == self?.waypointToEdit?.imageURL {
                        if let image = UIImage(data: imageData) {
                            dispatch_async(dispatch_get_main_queue()) {
                                self?.imageView.image = image
                                self?.makeRoomForImage()
                            }
                        }
                    }
                }
            }
        }
    }
    
    // adjust our preferredContentSize
    func makeRoomForImage() {
        var extraHeight: CGFloat = 0
        if imageView.image?.aspectRatio > 0 {
            if let width = imageView.superview?.frame.size.width {
                let height = width / imageView.image!.aspectRatio
                extraHeight = height - imageView.frame.height
                imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            }
        } else {
            extraHeight = -imageView.frame.height
            imageView.frame = CGRectZero
        }
        preferredContentSize = CGSize(width: preferredContentSize.width, height: preferredContentSize.height + extraHeight)
    }
}

extension UIImage {
    var aspectRatio: CGFloat {
        return size.height != 0 ? size.width / size.height : 0
    }
}
