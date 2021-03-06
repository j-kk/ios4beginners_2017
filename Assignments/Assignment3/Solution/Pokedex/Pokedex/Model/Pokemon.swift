//
//  Pokemon.swift
//  Pokedex
//
//  Created by Kajetan Dąbrowski on 26/11/2017.
//  Copyright © 2017 DaftMobile. All rights reserved.
//

import Foundation
import UIKit

struct Pokemon: Codable {
	let color: Int
	let name: String
	let number: Int
}

extension Pokemon {
	var keyColor: UIColor {
		return UIColor(hex: color)
	}
}

extension Pokemon: CustomDebugStringConvertible {
	var debugDescription: String {
		return "[\(number): \(name)]"
	}
}
