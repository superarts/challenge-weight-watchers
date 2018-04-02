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

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.white
        
        createSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private methods
    
    private func createSubviews() {
        
        label.text = "Summer Grilling"
        label.textAlignment = .center
        view.addSubview(label)
        
        let imageUrl = URL(string: "http://www.weightwatchers.com/images/1033/dynamic/foodandrecipes/2015/07/TANDORI_GRILLED_SHRIMP_1053_800x800.jpg")
        imageView.contentMode = .scaleAspectFit
        imageView.af_setImage(withURL: imageUrl)
        view.addSubview(imageView)
        
        view.setNeedsUpdateConstraints()
        view.updateConstraintsIfNeeded()
    }
    
    // MARK: - Auto layout
    
    override func updateViewConstraints() {
        if !didSetupContrainsts {
            
            label.autoSetDimensions(to: CGSize(width: 100, height: 20))
            label.autoPin(toTopLayoutGuideOf: self, withInset: 50)
            label.autoAlignAxis(toSuperviewAxis: .vertical)
            
            imageView.autoPinEdge(.top, to: .bottom, of: label, withOffset: 20)
            imageView.autoPin(toTopLayoutGuideOf: self, withInset: 70)
            imageView.autoSetDimension(.height, toSize: 200)
            imageView.autoAlignAxis(toSuperviewAxis: .vertical)
            
            didSetupContrainsts = true
        }
        
        super.updateViewConstraints()
    }

}
