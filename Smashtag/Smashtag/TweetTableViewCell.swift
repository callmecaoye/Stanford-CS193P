//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by CAOYE on 8/29/16.
//  Copyright © 2016 CAOYE. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    // public API
    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    func updateUI() {
        tweetProfileImageView?.image = nil
        tweetScreenNameLabel?.text = nil
        //tweetCreatedLabel?.text = nil
        tweetTextLabel?.attributedText = nil
        
        if let tweet = self.tweet {
            //tweetTextLabel?.attributedText = tweet.attributedText
            tweetTextLabel.text = tweet.text
            
            tweetScreenNameLabel?.text = "\(tweet.user)"
            
            if let url = tweet.user.profileImageURL {
                let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
                dispatch_async(dispatch_get_global_queue(qos, 0)) {
                    let imageData = NSData(contentsOfURL: url)
                    dispatch_async(dispatch_get_main_queue()) {
                        if url == tweet.user.profileImageURL {
                            if imageData != nil {
                                self.tweetProfileImageView?.image = UIImage(data: imageData!)
                            } else {
                                self.tweetProfileImageView?.image = nil
                            }
                        }
                    }
                }
            }
            
            /*
            let formatter = NSDateFormatter()
            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            } else {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
             */
        }
        
    }
    
    
}
