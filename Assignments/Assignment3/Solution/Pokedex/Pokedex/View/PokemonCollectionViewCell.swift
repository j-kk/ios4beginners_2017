//
//  PokemonCollectionViewCell.swift
//  Pokedex
//
//  Created by Kajetan Dąbrowski on 26/11/2017.
//  Copyright © 2017 DaftMobile. All rights reserved.
//

import UIKit

class PokemonCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak var colorBackgroundView: UIView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var thumbnailImage: UIImageView!
	var representedPokemon: Int? = nil

	@IBOutlet weak var colorBackgroundImageView: UIView!

	override func prepareForReuse() {
		super.prepareForReuse()
		representedPokemon = nil
		thumbnailImage.image = nil
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		thumbnailImage.image = nil
		colorBackgroundImageView.layer.cornerRadius = 5.0
		colorBackgroundImageView.layer.shadowOffset = CGSize(width: 0, height: 2)
		colorBackgroundImageView.layer.shadowRadius = 2.0
		colorBackgroundImageView.layer.shadowOpacity = 0.2
		colorBackgroundImageView.layer.shadowColor = UIColor.black.cgColor
		colorBackgroundImageView.layer.cornerRadius = 2.0
	}
}
