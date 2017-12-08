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
import Alamofire

class ViewController: UIViewController {

    var didSetupContrainsts = false
    var label = UILabel().configureForAutoLayout()
    var imageView = UIImageView().configureForAutoLayout()
    var statusbar = UIView().configureForAutoLayout() // added this variable to be able to update statusbar for rotation
    var scrollView = UIScrollView().configureForAutoLayout() // added for displaying exercise 2

    // MARK:- View lifecycle

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

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }

    // lets status bar remain visible on rotation
    override var prefersStatusBarHidden: Bool {
        return false
    }

    // MARK:- Private methods

    func createSubviews() {

        label.text = "Exercise #1"
        label.textAlignment = .center
        view.addSubview(label)

        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)

        if let imageUrl = URL(string: "http://i.imgur.com/A8eQsll.jpg") { // unwraps optional
            let placeholder = UIImage.from(color: .lightGray) // will show if image not found
            imageView.af_setImage(withURL: imageUrl,
                                  placeholderImage: placeholder)
        }

        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self,
                                                                   action: #selector(handleImageTap(_:))))

        // setup scrollView for exercise 2
        scrollView.backgroundColor = UIColor.init(white: 1, alpha: 0.9)
        view.addSubview(scrollView)
        scrollView.isHidden = true
        scrollView.addGestureRecognizer(UITapGestureRecognizer.init(target: self,
                                                                    action: #selector(handleScrollViewTap(_:))))

        statusbar.backgroundColor = UIColor.darkGray
        view.addSubview(statusbar)

        view.setNeedsUpdateConstraints()
        view.updateConstraintsIfNeeded()
    }

    func handleScrollViewTap(_ tap: UITapGestureRecognizer) { // removes scrollView for exercise 2
        scrollView.isHidden = true
        for subview in scrollView.subviews {
            if subview.tag == 666 {
                subview.removeFromSuperview()
            }
        }
    }

    func renderScrollViewContent(items: [[String: String]]) { // displays content for exercise 2
        self.scrollView.isHidden = false
        self.scrollView.contentInset.top = self.statusbar.frame.size.height
        self.scrollView.contentInset.bottom = self.scrollView.contentInset.top
        var views = [UIView]()

        for item in items {
            if let image = item["image"],
                let title = item["title"] {
                var yPos = CGFloat(0)
                if let prevView = views.last {
                    yPos = prevView.frame.maxY
                }
                let container = UIView.init()
                container.frame.origin.y = yPos
                views.append(container)

                let margin = 11
                let imageSize = 66

                let imageView = UIImageView.init(frame: CGRect(x: margin, y: margin, width: imageSize, height: imageSize))
                if let imageUrl = URL(string: "https://www.weightwatchers.com" + image) {
                    imageView.af_setImage(withURL: imageUrl)
                }

                let label = UILabel.init()
                label.text = title
                label.sizeToFit()
                label.frame.origin.x = imageView.frame.maxX + imageView.frame.origin.x
                label.center.y = imageView.center.y
                container.addSubview(label)

                container.frame.size.height = imageView.frame.size.height + imageView.frame.origin.y
                container.addSubview(imageView)
                container.tag = 666

                self.scrollView.addSubview(container)
                self.scrollView.contentSize.height = container.frame.maxY
            }
        }
    }

    func fetchJSON() { // get data for exercise 2
        if let url = URL(string: "https://www.weightwatchers.com/assets/cmx/us/messages/collections.json") {
            Alamofire.request(url, method: .get).responseJSON { (dataResponse) in

                if let data = dataResponse.data {
                    let items = self.decodeJSON(data: data)
                    self.renderScrollViewContent(items: items)
                }
            }
        }
    }

    func decodeJSON(data: Data) -> [[String: String]] {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])

            if let object = json as? [[String: String]] {
                return object
            }
        } catch {
            // do nothing
        }

        return [[:]]
    }

    func handleImageTap(_ tap: UITapGestureRecognizer) { // displays dialog, link from exercise 1 to exercise 2
        let alertController = UIAlertController.init(title: "Show Dishes",
                                                     message: nil,
                                                     preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction.init(title: "OK",
                                    style: UIAlertActionStyle.default) { (action) in
                                        self.fetchJSON()
        }
        let cancel = UIAlertAction.init(title: "Cancel",
                                        style: UIAlertActionStyle.cancel)
        alertController.addAction(cancel)
        alertController.addAction(ok)
        self.present(alertController,
                     animated: true,
                     completion: nil)
    }

    // MARK:- Auto layout

    override func updateViewConstraints() {
        if !didSetupContrainsts {

            scrollView.autoPinEdge(.left, to: .left, of: view)
            scrollView.autoPinEdge(.right, to: .right, of: view)
            scrollView.autoPinEdge(.top, to: .top, of: view)
            scrollView.autoPinEdge(.bottom, to: .bottom, of: view)

            statusbar.autoPinEdge(.left, to: .left, of: view)
            statusbar.autoPinEdge(.right, to: .right, of: view)
            statusbar.autoSetDimension(.height, toSize: 20)

            label.autoSetDimensions(to: CGSize(width: 100, height: 20))
            label.autoPin(toTopLayoutGuideOf: self, withInset: 50)
            label.autoAlignAxis(toSuperviewAxis: .vertical)

            imageView.autoPinEdge(.top, to: .bottom, of: label, withOffset: 20)
            /*  removed this line to fix layout constraints
             imageView.autoPin(toTopLayoutGuideOf: self, withInset: 70)
             */
            imageView.autoSetDimension(.height, toSize: 200)
            imageView.autoAlignAxis(toSuperviewAxis: .vertical)

            didSetupContrainsts = true
        }

        super.updateViewConstraints()
    }

}

// generates placeholder image
extension UIImage {
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1111, height: 1111)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
