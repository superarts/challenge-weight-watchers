import UIKit
import ReactiveSwift
import ReactiveCocoa

class CuisineTableCell: UITableViewCell {
	
	var titleLabel = UILabel()
	var cuisineImage = UIImageView()
	
	public var viewModel: CuisineCellViewModel! {
		// Bind UI elements with ViewModel once it's set
		didSet {
			if let textLabel = textLabel {
    			textLabel.reactive.text <~ viewModel.title
			}

			if let imageView = imageView, let url = URL(string: viewModel.imageURLString.value) {
				imageView.image = UIImage(named: "placeholder")
				imageView.af_setImage(withURL: url)
			}
		}
	}
}
