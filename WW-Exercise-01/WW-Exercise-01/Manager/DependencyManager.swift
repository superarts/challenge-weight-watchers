import Dip

/**
 * Protocol: dependency resolving is required
 */
protocol RequiresDependency {
	var dependencyManager: DependencyManager! { get }
}

extension RequiresDependency {
	var dependencyManager: DependencyManager! {
		return DependencyManager.shared
	}
}

/**
 * A dependency manager powered by Dip
 * TODO: create interface
 */

// swiftlint:disable force_try
// Dependency checking is performed in WWDependencyTests.
// It doesn't make sense to catch exceptions here,
// as broken dependencies will definitely crash the app and should always be fixed before merging to master/develop branch.

class DependencyManager {
	public static var shared = DependencyManager()
	
	let container = DependencyContainer.setup()

	// Resolving singleton instance
	func networkManager() -> NetworkManager {
		let type = try! container.resolve() as NetworkManager.Type
		return type.shared
	}
	func navigationManager() -> NavigationManager {
		let type = try! container.resolve() as NavigationManager.Type
		return type.shared
	}
	func cuisineManager() -> CuisineManager {
		let type = try! container.resolve() as CuisineManager.Type
		return type.shared
	}
	
	// Resolving new class instance
	func viewModel() -> ViewModel {
		return try! container.resolve() as ViewModel
	}
	func cuisineCellViewModel() -> CuisineCellViewModel {
		return try! container.resolve() as CuisineCellViewModel
	}
}

/// Actual dependencies
extension DependencyContainer {
	static func setup() -> DependencyContainer {
		return DependencyContainer { container in
			unowned let container = container
			
			//container.register { DummyViewModel() as ViewModel }
			container.register { NetworkViewModel() as ViewModel }
			container.register { StandardCuisineCellViewModel() as CuisineCellViewModel }

			container.register { MoyaNetworkManager.self as NetworkManager.Type }
			//container.register { ReflectionNetworkManager.self as NetworkManager.Type }
			container.register { NavigationManager.self as NavigationManager.Type }
			container.register { CuisineManager.self as CuisineManager.Type }
    	}
	}
}
