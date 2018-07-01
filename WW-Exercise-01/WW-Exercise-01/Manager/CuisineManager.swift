import ReactiveSwift

/**
* Protocol: Cuisine data are required
*/
protocol RequiresCuisineData: RequiresDependency {
	var cuisineManager: CuisineManager! { get }
}

extension RequiresCuisineData {
	var cuisineManager: CuisineManager! {
		return dependencyManager.cuisineManager()
	}
}

/**
* Handling cuisines data
* TODO: add interface
*/
class CuisineManager: RequiresNetworking {
	
	public static let shared = CuisineManager()
	
	public var cuisines: MutableProperty<[CuisineModel]>!
	public var error: MutableProperty<Error?>!
	
	init() {
		cuisines = networkManager.cuisines
		error = networkManager.error
	}
	
	public func request() {
		networkManager.requestCuisines()
	}
}
