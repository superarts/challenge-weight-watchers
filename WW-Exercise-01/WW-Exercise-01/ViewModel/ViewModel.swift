import ReactiveSwift

protocol ViewModel {
	var cuisines: MutableProperty<[CuisineModel]>! { get }
	func reload()
}

class DummyViewModel: ViewModel {
	public var cuisines: MutableProperty<[CuisineModel]>! = MutableProperty([CuisineModel]())
	func reload() {
	}
}

class NetworkViewModel: ViewModel, RequiresCuisineData {
	public var cuisines: MutableProperty<[CuisineModel]>!

	init() {
		cuisines = cuisineManager.cuisines
		cuisineManager.cuisines.producer.startWithValues { cuisines in
			guard !cuisines.isEmpty else {
				return
			}
		}
		cuisineManager.error.producer.startWithValues { error in
			if error != nil {
				print("Failed")
			}
		}
	}
	func reload() {
		// TODO: add checking to prevent unnecessary repeated reloading
		cuisineManager.request()
	}
}
