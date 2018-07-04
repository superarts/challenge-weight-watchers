import UIKit

/**
* Protocol: navigation is required
*/
protocol RequiresNavigation: RequiresDependency {
	var navigationManager: NavigationManager! { get }
}

extension RequiresNavigation {
	var navigationManager: NavigationManager! {
		return dependencyManager.navigationManager()
	}
}

class NavigationManager: RequiresDependency {
	public static let shared = NavigationManager()
	
	public var rootViewController: UIViewController?

	public func setup(window: UIWindow) {
		self.window = window
	}
	
	/// App entry point
	public func setViewControllerAsRoot() {
		let controller = setupViewController()
		rootViewController = controller
	}
	
	private var window: UIWindow!
	
	init() {
	}
	
	private func setupViewController() -> ViewController {
		let controller = ViewController()
		controller.viewModel = self.dependencyManager.viewModel()
		//controller.viewModel.reload()
		return controller
	}
}
