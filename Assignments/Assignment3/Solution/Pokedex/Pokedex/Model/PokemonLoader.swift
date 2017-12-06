//
//  PokemonLoader.swift
//  Pokedex
//
//  Created by Kajetan Dąbrowski on 26/11/2017.
//  Copyright © 2017 DaftMobile. All rights reserved.
//

import Foundation
import UIKit


class PokemonLoader {

	private let session: URLSession = URLSession(configuration: .ephemeral)

	let baseUrlString = "https://switter.int.daftcode.pl/api/"
//	let baseUrlString = "http://0.0.0.0:8085/api/"

	private func request(for url: URL, method: String = "GET") -> URLRequest {
		var request = URLRequest(url: url)
		request.addValue(UIDevice.current.identifierForVendor!.uuidString, forHTTPHeaderField: "x-device-uuid")
		request.httpMethod = method
		return request
	}

	private func request(for endpoint: String, method: String = "GET") -> URLRequest {
		let url = URL(string: baseUrlString + endpoint)!
		return request(for: url, method: method)
	}

	func load(completion: @escaping ([Pokemon]?) -> Void) {
		session.dataTask(with: request(for: "pokemon")) { (data, response, error) in
			guard let data = data else {
				DispatchQueue.main.async { completion(nil) }
				return
			}
			let pokemon = try? JSONDecoder().decode([Pokemon].self, from: data)
			DispatchQueue.main.async { completion(pokemon) }
		}.resume()
	}

	func catchPokemon(number: Int, completion: @escaping (Pokemon?) -> Void) {
		session.dataTask(with: request(for: "pokemon/\(number)/catch", method: "POST")) { (data, response, error) in
			guard let data = data else {
				DispatchQueue.main.async { completion(nil) }
				return
			}
			let pokemon = try? JSONDecoder().decode(Pokemon.self, from: data)
			DispatchQueue.main.async { completion(pokemon) }
			}.resume()
	}

	func thumbnail(for id: Int, completion: @escaping (UIImage?) -> Void) {
		session.dataTask(with: request(for: "pokemon/\(id)/thumbnail")) { (data, response, error) in
			guard let data = data else {
				DispatchQueue.main.async { completion(nil) }
				return
			}
			DispatchQueue.main.async {
				completion(UIImage.init(data: data))
			}
		}.resume()
	}

	func image(for id: Int, completion: @escaping (UIImage?) -> Void) {
		session.dataTask(with: request(for: "pokemon/\(id)/image")) { (data, response, error) in
			guard let data = data else {
				DispatchQueue.main.async { completion(nil) }
				return
			}
			DispatchQueue.main.async {
				completion(UIImage.init(data: data))
			}
			}.resume()
	}
}
