//
//  ViewController.swift
//  HelloAutoLayout
//
//  Created by Kajetan Dąbrowski on 06/11/2017.
//  Copyright © 2017 DaftMobile. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	@IBOutlet weak var textField: UITextField!

	@IBAction func printAction(_ sender: Any) {
		switch textField.text {
		case .none, .some(""):
			print("No text found!")
		case .some(let text):
			print(text)
		}
	}
}
