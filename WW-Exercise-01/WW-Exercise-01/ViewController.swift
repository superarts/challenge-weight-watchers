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
        
        let statusbar = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 20))
        statusbar.backgroundColor = UIColor.darkGrayColor()
        view.addSubview(statusbar)
        
        label.text = "Exercise #1"
        label.textAlignment = .Center
        view.addSubview(label)
        
        let imageUrl = NSURL(string: "http://i.imgur.com/A8eQsll.jpg")
        imageView.contentMode = .ScaleAspectFit
        imageView.af_setImageWithURL(imageUrl)
        view.addSubview(imageView)
        
        view.setNeedsUpdateConstraints()
        view.updateConstraintsIfNeeded()
    }
    
    // MARK:- Auto layout
    
    override func updateViewConstraints() {
        if !didSetupContrainsts {
            
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

}

