//
//  ExplosionView.swift
//  Pokedex
//
//  Created by Kajetan Dąbrowski on 05/12/2017.
//  Copyright © 2017 DaftMobile. All rights reserved.
//

import UIKit

class ExplosionLayer: CALayer {
	let animationDuration: TimeInterval

	private let explosionCell = CAEmitterCell()
	private let explosionLayer = CAEmitterLayer()
	private let chargeCell = CAEmitterCell()
	private let chargeLayer = CAEmitterLayer()

	init(animationDuration: TimeInterval) {
		self.animationDuration = animationDuration
		super.init()
		setupExplosion()
	}

	override init(layer: Any) {
		animationDuration = (layer as? ExplosionLayer)?.animationDuration ?? 4.0
		super.init(layer: layer)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}

	private func setupExplosion() {
		explosionCell.name = "explosion"
		explosionCell.alphaRange = 0.20
		explosionCell.alphaSpeed = -1.0

		explosionCell.lifetime = 0.7
		explosionCell.lifetimeRange = 0.3
		explosionCell.birthRate = 0
		explosionCell.velocity = 300.00
		explosionCell.velocityRange = 80.00
		explosionCell.contents = #imageLiteral(resourceName: "Oval").cgImage
		explosionCell.yAcceleration = -300
		explosionCell.color = UIColor.init(red: 0.8, green: 0.4, blue: 0.2, alpha: 0.6).cgColor

		explosionLayer.name = "emitterLayer"
		explosionLayer.emitterShape = kCAEmitterLayerCircle
		explosionLayer.emitterMode = kCAEmitterLayerOutline
		explosionLayer.emitterSize = CGSize(width: 25, height: 0)
		explosionLayer.emitterCells = [explosionCell]
		explosionLayer.renderMode = kCAEmitterLayerAdditive
		explosionLayer.masksToBounds = false
		explosionLayer.seed = 1000000
		explosionLayer.zPosition = 10.0
		addSublayer(explosionLayer)

		chargeCell.name = "charge"
		chargeCell.alphaRange = 0.20
		chargeCell.alphaSpeed = -1.0

		chargeCell.lifetime = 0.3
		chargeCell.lifetimeRange = 0.1
		chargeCell.birthRate = 0
		chargeCell.velocity = -40.0
		chargeCell.velocityRange = 100.00
		chargeCell.contents = #imageLiteral(resourceName: "Oval").cgImage
		chargeCell.color = UIColor.init(red: 0.2, green: 0.4, blue: 0.8, alpha: 0.20).cgColor

		chargeLayer.name = "emitterLayer"
		chargeLayer.emitterShape = kCAEmitterLayerCircle
		chargeLayer.emitterMode = kCAEmitterLayerOutline
		chargeLayer.emitterSize = CGSize(width: 70, height: 70)
		chargeLayer.emitterCells = [chargeCell]
		chargeLayer.renderMode = kCAEmitterLayerAdditive
		chargeLayer.masksToBounds = false
		chargeLayer.seed = 1366128504
		chargeLayer.zPosition = 15.0
		addSublayer(chargeLayer)
	}

	override func layoutSublayers() {
		super.layoutSublayers()
		self.chargeLayer.emitterPosition = CGPoint(x: bounds.midX, y: bounds.midY)
		self.explosionLayer.emitterPosition = CGPoint(x: bounds.midX, y: bounds.midY)
	}

	func animate(color: UIColor) {
		chargeCell.color = color.withAlphaComponent(0.7).cgColor
		explosionCell.color = color.withAlphaComponent(0.5).cgColor

		chargeLayer.beginTime = CACurrentMediaTime()
		chargeLayer.setValue(300, forKeyPath: "emitterCells.charge.birthRate")
		DispatchQueue
			.main
			.asyncAfter(
				deadline: DispatchTime(
					uptimeNanoseconds: DispatchTime.now().uptimeNanoseconds
						+ UInt64(animationDuration * 0.5 * Double(NSEC_PER_SEC))
				)
			) { [weak self] in
			self?.explode()
		}
	}

	private func explode() {
		chargeLayer.setValue(0, forKeyPath: "emitterCells.charge.birthRate")
		explosionLayer.beginTime = CACurrentMediaTime()
		explosionLayer.setValue(500, forKeyPath: "emitterCells.explosion.birthRate")
		DispatchQueue
			.main
			.asyncAfter(
				deadline: DispatchTime(uptimeNanoseconds: DispatchTime.now().uptimeNanoseconds
					+ UInt64(animationDuration * 0.5 * Double(NSEC_PER_SEC)))
			) { [weak self] in
			self?.stop()
		}
	}

	private func stop() {
		chargeLayer.setValue(0, forKeyPath: "emitterCells.charge.birthRate")
		explosionLayer.setValue(0, forKeyPath: "emitterCells.explosion.birthRate")
	}
}
