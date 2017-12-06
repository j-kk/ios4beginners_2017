//
//  PokemonListViewController.swift
//  Pokedex
//
//  Created by Kajetan Dąbrowski on 26/11/2017.
//  Copyright © 2017 DaftMobile. All rights reserved.
//

import UIKit

class PokemonListViewController: UIViewController {

	// MARK: - Dependencies
	let loader = PokemonLoader()
	var model: [Pokemon] = [] { didSet { collectionView?.reloadData() } }

	// MARK: - Outlets
	@IBOutlet weak var collectionView: UICollectionView!

	// MARK: - Private properties
	fileprivate let elementPadding: CGFloat = 5
	fileprivate let elementsPerRow: Int = 3
	fileprivate var collectionViewLayout: UICollectionViewFlowLayout! { return collectionView?.collectionViewLayout as? UICollectionViewFlowLayout}

	// MARK: - View Lifecycle

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		loader.load { [unowned self] (pokemon) in
			self.model = pokemon ?? []
		}
		recomputeLayout(viewSize: view.bounds.size)
	}

	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		recomputeLayout(viewSize: size)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)
		if segue.identifier == "SHOW_POKEMON_DETAIL" {
			guard let destination = segue.destination as? PokemonDetailsViewController else { return }
			guard let selected = (sender as? PokemonCollectionViewCell)?.representedPokemon else { return }
			guard let pokemon = model.first(where: { $0.number == selected }) else { return }
			destination.model = pokemon
		}
	}

	private func recomputeLayout(viewSize: CGSize) {
		let itemWidth = floor((viewSize.width - (CGFloat(elementsPerRow + 1) * elementPadding)) / CGFloat(elementsPerRow))
		collectionViewLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 30.0)
		collectionViewLayout.sectionInset = UIEdgeInsets(top: elementPadding, left: elementPadding, bottom: elementPadding, right: elementPadding)
		collectionViewLayout.minimumInteritemSpacing = elementPadding
		collectionViewLayout.invalidateLayout()
	}
}

extension PokemonListViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return model.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath) as? PokemonCollectionViewCell else {
			fatalError()
		}

		let pokemon = model[indexPath.item]
		cell.representedPokemon = pokemon.number
		cell.nameLabel.text = pokemon.name
		cell.colorBackgroundImageView.backgroundColor = pokemon.keyColor
		cell.nameLabel.textColor = pokemon.keyColor.darkenColor()

		loader.thumbnail(for: pokemon.number, completion: { [weak cell] (image) -> Void in
			guard let image = image else { return }
			guard cell?.representedPokemon == pokemon.number else { return }
			cell?.thumbnailImage.image = image
		})

		return cell
	}
}
