//
//  ViewController.swift
//  WW-Exercise-01
//
//  Created by Paul Newman on 7/13/16.
//  Copyright © 2016 Weight Watchers. All rights reserved.
//

import UIKit
import PureLayout
import AlamofireImage

class ViewController: UIViewController {
    
    var didSetupContrainsts = false
    var label = UILabel().configureForAutoLayout()
    var imageView = UIImageView().configureForAutoLayout()
    var statusbar = UIView().configureForAutoLayout()
    
    // MARK:- View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.greenColor()
        createSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK:- Private methods
    
    private func createSubviews() {
        
        statusbar.backgroundColor = UIColor.darkGrayColor()
        view.addSubview(statusbar)
        
        label.text = "Exercise #1"
        label.textAlignment = .Center
        view.addSubview(label)
        
        imageView.contentMode = .ScaleAspectFit
        
        let placeholderImage = UIImage(named:"placeholder")
        if let imageUrl = NSURL(string: "http://i.imgur.com/A8eQsll.jpg") {
            imageView.af_setImageWithURL(imageUrl, placeholderImage: placeholderImage, filter: nil, progress: nil, progressQueue: dispatch_get_main_queue(), imageTransition: .None, runImageTransitionIfCached: false, completion: nil)
        }
        
        let  tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.imageTapAction(_:)))
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        view.addSubview(imageView)
        
        view.setNeedsUpdateConstraints()
        view.updateConstraintsIfNeeded()
    }
    
    // MARK:- Auto layout
    
    override func updateViewConstraints() {
        if !didSetupContrainsts {
            
            statusbar.autoSetDimension(ALDimension.Height, toSize: 20)
            statusbar.autoPinEdgeToSuperviewEdge(.Leading)
            statusbar.autoPinEdgeToSuperviewEdge(.Trailing)
            statusbar.autoAlignAxisToSuperviewAxis(.Vertical)
            
            label.autoSetDimensionsToSize(CGSize(width: 100, height: 20))
            label.autoPinToTopLayoutGuideOfViewController(self, withInset: 50)
            label.autoAlignAxisToSuperviewAxis(.Vertical)
            
            imageView.autoPinEdge(.Top, toEdge: .Bottom, ofView: label, withOffset: 20)
            imageView.autoPinToTopLayoutGuideOfViewController(self, withInset: 70)
            imageView.autoSetDimension(.Height, toSize: 200)
            imageView.autoAlignAxisToSuperviewAxis(.Vertical)
            
            didSetupContrainsts = true
        }
        
        super.updateViewConstraints()
    }
    
    // Mark:- Gesture recognizer function
    func imageTapAction(img: AnyObject)
    {
        let alert = UIAlertController(title: "Congrats", message: "You touched the image", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}

