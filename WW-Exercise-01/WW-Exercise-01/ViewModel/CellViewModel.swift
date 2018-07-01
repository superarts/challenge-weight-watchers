import ReactiveSwift

protocol CuisineCellViewModel {
	var cuisine: CuisineModel! { get set }
	var title: MutableProperty<String>! { get }
	var imageURLString: MutableProperty<String>! { get }
}

class StandardCuisineCellViewModel: CuisineCellViewModel {
	
	public var title: MutableProperty<String>! = MutableProperty("")
	public var imageURLString: MutableProperty<String>! = MutableProperty("")

	public var cuisine: CuisineModel! {
		//	Update MutableProperties when `cuisine` is set
		didSet {
			title.value = cuisine.title ?? ""
			//	TODO: based on different business requirements, the hard-coded URL below should be moved to CuisineModel or NetworkManager.
			imageURLString.value = "https://www.weightwatchers.com/" + (cuisine.image ?? "")
		}
	}
}
