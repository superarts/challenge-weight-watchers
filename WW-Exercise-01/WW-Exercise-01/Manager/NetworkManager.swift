import Moya
import ReactiveSwift

/**
 * Protocol: networking is required
 */
protocol RequiresNetworking: RequiresDependency {
	var networkManager: NetworkManager! { get }
}

extension RequiresNetworking {
	var networkManager: NetworkManager! {
		return dependencyManager.networkManager()
	}
}

/**
 * API endpoints definition: powered by [Moya](https://github.com/Moya/Moya/tree/master/docs/Examples)
 */
enum CuisineTarget {
	case getCuisines
}

extension CuisineTarget: TargetType {
	var baseURL: URL { return URL(string: "https://www.weightwatchers.com/assets/")! }
	var path: String {
		switch self {
			case .getCuisines: return "cmx/us/messages/collections.json"
		}
	}
	var method: Moya.Method {
		return .get
	}
	var parameters: [String: Any]? {
		return nil
	}
	var headers: [String: String]? {
		return nil
	}
	var sampleData: Data {
		return "{}".data(using: .utf8)!
	}
	var parameterEncoding: ParameterEncoding {
		return JSONEncoding.default
	}
	var task: Task {
		return .requestPlain
	}
}

/**
 * A singleton networking client. Authentication, caching etc. will be handled here in future.
 * Instead of using Singleton Pattern, protocol `RequiresNetworking` should be utilized.
 */
protocol NetworkManager {
	static var shared: NetworkManager { get }
	
	var cuisines: MutableProperty<[CuisineModel]> { get }
	var error: MutableProperty<Error?> { get }
	
	func requestCuisines()
}

/// Moya + manual deserialization, it only covers selected fields but runs faster
class MoyaNetworkManager: NetworkManager {
	public static var shared: NetworkManager = MoyaNetworkManager()
	
	public var cuisines = MutableProperty([CuisineModel]())
	public var error = MutableProperty<Error?>(nil)
	
	private let cuisineProvider = MoyaProvider<CuisineTarget>(callbackQueue: DispatchQueue.global(qos: .utility))
	
	//	TODO: add FetchSchoolPolicy and FetchScorePolicy to indicate when to request data.
	//	Currently the policy is "RequestOnce" + "RequestWhenNeed". Should also provide "RequestUntilSuccess", "RequestWhenViewReload", etc.
	public func requestCuisines() {
		cuisineProvider.request(.getCuisines) { result in
			switch result {
			case let .success(moyaResponse):
				let statusCode = moyaResponse.statusCode
				guard statusCode == 200 else {
					self.error.value = NSError(domain: "NYCSchools", code: statusCode, userInfo: ["message": "Network failed: Schools"])
					return
				}
				let data = moyaResponse.data
				guard let json = try? JSONSerialization.jsonObject(with: data) as? [[String: String]] else {
					self.error.value = NSError(domain: "NYCSchools", code: statusCode, userInfo: ["message": "Schools deserialization failed"])
					return
				}
				guard let array = json else {
					self.error.value = NSError(domain: "NYCSchools", code: statusCode, userInfo: ["message": "Emply Schools"])
					return
				}
				var cuisines = [CuisineModel]()
				for dict in array {
					let cuisine = CuisineModel()
					cuisine.title = dict["title"]
					cuisine.image = dict["image"]
					cuisine.filter = dict["filter"]
					cuisines.append(cuisine)
				}
				self.cuisines.value = cuisines
			case let .failure(error):
				self.error.value = error
			}
		}
	}
}

/// A reflection based implementation, slow for complex deserialization
class ReflectionNetworkManager: NetworkManager {
	public static var shared: NetworkManager = ReflectionNetworkManager()
	
	public var cuisines = MutableProperty([CuisineModel]())
	public var error = MutableProperty<Error?>(nil)
	
	private let cuisineProvider = MoyaProvider<CuisineTarget>()
	
	//	TODO: add FetchSchoolPolicy and FetchScorePolicy to indicate when to request data.
	//	Currently the policy is "RequestOnce" + "RequestWhenNeed". Should also provide "RequestUntilSuccess", "RequestWhenViewReload", etc.
	public func requestCuisines() {
		cuisineProvider.reactive.request(.getCuisines)
			.observe(on: QueueScheduler(qos: .utility))
			.map(toArray: CuisineModel.self)
			.on(value: { cuisines in
				self.cuisines.value = cuisines
			})
			.on(failed: { error in
				// TODO: error handling based on business requirement, e.g. retry, notification, etc.
				self.error.value = error
			})
			.start()
	}
}
