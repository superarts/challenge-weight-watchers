//
//  ViewController.swift
//  WW-Exercise-01
//
//  Created by Paul Newman on 7/13/16.
//  Copyright © 2016 Weight Watchers. All rights reserved.
//

import UIKit
import AlamofireImage

class ViewController: UIViewController {
	
	public var viewModel: ViewModel!
	
	private var cuisineTableManager: CuisineTableManager!
    private var label = UILabel()
    private var imageView = UIImageView()
	private var cuisineTableView = UITableView()
	private var isConstraintsSet = false

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.white
		
        createSubviews()
		setupTableManager()
		setupViewModel()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Private methods
	
	private func setupTableManager() {
		cuisineTableManager = CuisineTableManager(tableView: cuisineTableView)
		cuisineTableManager.selectHandler = { index in
			let cuisine = self.viewModel.cuisines.value[index]
			print(cuisine)
			
			let alert = UIAlertController(title: "Cuisine Selected", message: cuisine.title, preferredStyle: UIAlertControllerStyle.alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	private func setupViewModel() {
		viewModel.cuisines.producer.startWithValues { cuisines in
			guard !cuisines.isEmpty else {
				return
			}
			DispatchQueue.main.async {
				self.cuisineTableManager.reload(cuisines: cuisines)
			}
		}
		viewModel.reload()
	}
	
    private func createSubviews() {
	
		view.addSubview(cuisineTableView)
		
		//	The follow contents can be found in tableView, don't think I should move them to the header section of cuisineTableView
		/*
        label.text = "Summer Grilling"
        label.textAlignment = .center
        view.addSubview(label)
        
        let imageUrl = URL(string: "http://www.weightwatchers.com/images/1033/dynamic/foodandrecipes/2015/07/TANDORI_GRILLED_SHRIMP_1053_800x800.jpg")
        imageView.contentMode = .scaleAspectFit
		if let imageUrl = imageUrl {
    		imageView.af_setImage(withURL: imageUrl)
		}
        view.addSubview(imageView)
		*/
        
        view.setNeedsUpdateConstraints()
        view.updateConstraintsIfNeeded()
    }
    
    // MARK: - Auto layout
    
    override func updateViewConstraints() {
	
		if !isConstraintsSet {
			isConstraintsSet = true
    		cuisineTableView.translatesAutoresizingMaskIntoConstraints = false
    		cuisineTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    		cuisineTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    		cuisineTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    		cuisineTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		}
		
        super.updateViewConstraints()
    }
}
