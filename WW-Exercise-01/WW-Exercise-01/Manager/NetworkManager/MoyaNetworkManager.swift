//
//  MoyaNetworkManager.swift
//  WW-Exercise-01
//
//  Created by Leo on 7/4/18.
//  Copyright © 2018 Weight Watchers. All rights reserved.
//

import Moya
import ReactiveSwift

/// Moya + manual deserialization, it only covers selected fields but runs faster
class MoyaNetworkManager: NetworkManager {
	public static var shared: NetworkManager = MoyaNetworkManager()
	
	public var cuisines = MutableProperty([CuisineModel]())
	public var error = MutableProperty<Error?>(nil)
	
	private let cuisineProvider = MoyaProvider<CuisineTarget>(callbackQueue: DispatchQueue.global(qos: .utility))
	
	//	Currently the policy is "RequestOnce" + "RequestWhenNeed". Should also provide "RequestUntilSuccess", "RequestWhenViewReload", etc.
	public func requestCuisines() {
		cuisineProvider.request(.getCuisines) { result in
			switch result {
			case let .success(moyaResponse):
				let statusCode = moyaResponse.statusCode
				guard statusCode == 200 else {
					self.error.value = NSError(domain: "WW", code: statusCode, userInfo: ["message": "Network failed: cuisines"])
					return
				}
				let data = moyaResponse.data
				guard let json = try? JSONSerialization.jsonObject(with: data) as? [[String: String]] else {
					self.error.value = NSError(domain: "WW", code: statusCode, userInfo: ["message": "Cuisines deserialization failed"])
					return
				}
				guard let array = json else {
					self.error.value = NSError(domain: "WW", code: statusCode, userInfo: ["message": "Emply Cuisines"])
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
