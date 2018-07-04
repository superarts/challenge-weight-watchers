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

// swiftlint:disable force_unwrapping
// Hard-coded force_unwrapping will never fail

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
