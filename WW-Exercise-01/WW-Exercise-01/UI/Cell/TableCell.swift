import UIKit
import ReactiveSwift
import ReactiveCocoa

class CuisineTableCell: UITableViewCell {
	
	var titleLabel = UILabel()
	var cuisineImage = UIImageView()
	
	public var viewModel: CuisineCellViewModel! {
		// Bind UI elements with ViewModel once it's set
		didSet {
			//titleLabel.reactive.text <~ viewModel.title
			if let textLabel = textLabel {
    			textLabel.reactive.text <~ viewModel.title
			}

			if let imageView = imageView, let url = URL(string: viewModel.imageURLString.value) {
				imageView.image = UIImage(named: "placeholder")
				imageView.af_setImage(withURL: url)
			}
		}
	}
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		//	Add subviews and update constraints here
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		//	Other dynamic UI update here
	}
}
