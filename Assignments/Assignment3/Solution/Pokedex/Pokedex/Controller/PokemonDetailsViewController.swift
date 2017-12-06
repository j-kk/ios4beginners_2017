//
//  PokemonDetailsViewController.swift
//  Pokedex
//
//  Created by Kajetan Dąbrowski on 26/11/2017.
//  Copyright © 2017 DaftMobile. All rights reserved.
//

import UIKit

class PokemonDetailsViewController: UIViewController {

	var model: Pokemon?
	let loader = PokemonLoader()

	@IBOutlet weak var previewImage: UIImageView!
	@IBOutlet weak var imageContainerView: UIView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var patternView: UIView!

	private let explosionLayer = ExplosionLayer(animationDuration: 4.0)
	private let animationDuration = 4.0

	override func viewDidLoad() {
		super.viewDidLoad()
		imageContainerView.layer.cornerRadius = 6.0
		imageContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
		imageContainerView.layer.shadowRadius = 2.0
		imageContainerView.layer.shadowOpacity = 0.2
		imageContainerView.layer.shadowColor = UIColor.black.cgColor
		imageContainerView.layer.cornerRadius = 2.0


		let effectGroup = UIMotionEffectGroup()
		let leftRight = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
		let upDown = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
		effectGroup.motionEffects = [leftRight, upDown]
		leftRight.minimumRelativeValue = -15
		leftRight.maximumRelativeValue = 15
		upDown.minimumRelativeValue = -15
		upDown.maximumRelativeValue = 15

		previewImage.addMotionEffect(effectGroup)
		patternView.backgroundColor = UIColor(patternImage: UIImage(named: "pattern")!)
		imageContainerView.layer.insertSublayer(explosionLayer, above: previewImage.layer)
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		explosionLayer.position = CGPoint(x: imageContainerView.bounds.midX, y: imageContainerView.bounds.midY)
	}

	private func setCatch(inProgress: Bool) {
		view.isUserInteractionEnabled = !inProgress
	}

	@IBAction func catchButtonPressed(_ sender: Any) {
		guard let model = model else { return }
		setCatch(inProgress: true)
		loader.catchPokemon(number: model.number) { [weak self] pokemon in
			self?.catchPokemon(pokemon, animated: true)
		}
	}

	private func catchPokemon(_ pokemon: Pokemon?, animated: Bool) {
		guard let pokemon = pokemon else { return }
		loader.image(for: pokemon.number) { [weak self] image in
			guard let image = image else { return }
			self?.animate(to: pokemon, image: image)
		}
	}

	private func animate(to pokemon: Pokemon, image: UIImage) {
		explosionLayer.animate(color: pokemon.keyColor)
		CATransaction.begin()
		let animationGroup = createImageAnimation(to: image, duration: animationDuration)
		let backgroundAnimation = createBackgroundAnimation(to: pokemon.keyColor, duration: animationDuration)
		CATransaction.setCompletionBlock { [weak self] in
			guard let `self` = self else { return }
			self.model = pokemon
			self.refreshContent()
			self.setCatch(inProgress: false)
		}
		previewImage.layer.add(animationGroup, forKey: nil)
		imageContainerView.layer.add(backgroundAnimation, forKey: nil)
		CATransaction.commit()

		previewImage.image = image
		imageContainerView.backgroundColor = pokemon.keyColor
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		previewImage.image = nil
		refreshContent()
	}

	private func refreshContent() {
		guard let model = model else { return }
		title = model.name
		titleLabel.text = model.name
		imageContainerView.backgroundColor = model.keyColor
		titleLabel.textColor = model.keyColor.darkenColor()
		loader.image(for: model.number) { [weak self] image in
			self?.previewImage.image = image
		}
	}

	private func createImageAnimation(to image: UIImage, duration: TimeInterval) -> CAAnimation {
		let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
		rotationAnimation.fromValue = 0
		rotationAnimation.toValue = 20.0 * Double.pi * 2.0
		rotationAnimation.duration = duration
		rotationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)

		let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
		scaleAnimation.fromValue = 1
		scaleAnimation.toValue = 0.3
		scaleAnimation.duration = duration * 0.5
		scaleAnimation.autoreverses = true

		let changeImageAnimation = CABasicAnimation(keyPath: "contents")
		changeImageAnimation.fromValue = previewImage.image?.cgImage
		changeImageAnimation.toValue = image.cgImage
		changeImageAnimation.duration = duration

		let animationGroup = CAAnimationGroup()
		animationGroup.duration = duration
		animationGroup.animations = [rotationAnimation, scaleAnimation, changeImageAnimation]
		return animationGroup
	}

	private func createBackgroundAnimation(to color: UIColor, duration: TimeInterval) -> CAAnimation {
		let changeBackground = CAKeyframeAnimation(keyPath: "backgroundColor")
		changeBackground.keyTimes = [0.0, 0.8, 1.0].map { $0 as NSNumber }
		changeBackground.values = [imageContainerView.backgroundColor, imageContainerView.backgroundColor, color]
			.map { $0 ?? UIColor.white }
			.map { $0.cgColor }
		changeBackground.duration = duration
		return changeBackground
	}
}

