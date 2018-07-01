//
//  WW_Exercise_01Tests.swift
//  WW-Exercise-01Tests
//
//  Created by Paul Newman on 7/13/16.
//  Copyright © 2016 Weight Watchers. All rights reserved.
//

import XCTest
@testable import WW_Exercise_01

/// Dependencies should be resolved at runtime without crashing
class WWDependencyTests: XCTestCase, RequiresDependency {
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testManagers() {
		XCTAssertNotNil(dependencyManager.navigationManager(), "DependencyManager should not throw exception")
		XCTAssertNotNil(dependencyManager.networkManager(), "DependencyManager should not throw exception")
		XCTAssertNotNil(dependencyManager.cuisineManager(), "DependencyManager should not throw exception")
	}
	
	func testViewModels() {
		XCTAssertNotNil(dependencyManager.viewModel(), "DependencyManager should not throw exception")
		XCTAssertNotNil(dependencyManager.cuisineCellViewModel(), "DependencyManager should not throw exception")
	}
}

/// Networking should get results successfully with proper internet connection
class WWNetworkTests: XCTestCase, RequiresNetworking {
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	// TODO: properly ignore initial value of MutableProperties
	private let cuisinesExpectation = XCTestExpectation(description: "ww.test.networking.cuisines")
	private var isInitialCuisinesCall = true
	func testSchools() {
		networkManager.cuisines.producer.startWithValues { cuisines in
			if self.isInitialCuisinesCall {
				self.isInitialCuisinesCall = false
			} else {
				XCTAssertLessThan(0, cuisines.count, "Cuisines should not be empty")
				print("cuisines: \(cuisines.count)")
				self.cuisinesExpectation.fulfill()
			}
		}
		networkManager.requestCuisines()
		wait(for: [cuisinesExpectation], timeout: 20.0)
	}

	private let errorExpectation = XCTestExpectation(description: "nycschools.test.networking.error")
	private var errorTestCount = 0
	func testError() {
		networkManager.error.producer.startWithValues { error in
			XCTAssertNil(error, "Error should be nil unless network is down")
			self.errorTestCount += 1
			if self.errorTestCount > 0 {
				self.errorExpectation.fulfill()
			}
		}
		networkManager.requestCuisines()
		wait(for: [errorExpectation], timeout: 20.0)
	}
}

/// Test reflection-based networking manager, in theory it is slower but not really observaable. This test is to show run-time dependency switching.
class WWNetworkReflectionTests: WWNetworkTests {
	override func setUp() {
		super.setUp()
		dependencyManager.container.register { ReflectionNetworkManager.self as NetworkManager.Type }
	}
}

// TODO: more tests
