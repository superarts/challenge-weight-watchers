//
//  ReflectionNetworkManager.swift
//  WW-Exercise-01
//
//  Created by Leo on 7/4/18.
//  Copyright © 2018 Weight Watchers. All rights reserved.
//

import Moya
import ReactiveSwift

/// A reflection based implementation, slow for complex deserialization
class ReflectionNetworkManager: NetworkManager {
	public static var shared: NetworkManager = ReflectionNetworkManager()
	
	public var cuisines = MutableProperty([CuisineModel]())
	public var error = MutableProperty<Error?>(nil)
	
	private let cuisineProvider = MoyaProvider<CuisineTarget>()
	
	//	Currently the policy is "RequestOnce" + "RequestWhenNeed". Should also provide "RequestUntilSuccess", "RequestWhenViewReload", etc.
	public func requestCuisines() {
		cuisineProvider.reactive.request(.getCuisines)
			.observe(on: QueueScheduler(qos: .utility))
			.map(toArray: CuisineModel.self)
			.on(value: { cuisines in
				self.cuisines.value = cuisines
			})
			.on(failed: { error in
				self.error.value = error
			})
			.start()
	}
}
