//
//  CharacterListCell.swift
//  HackerNews
//
//  Created by Alexander Ge on 28/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import UIKit

protocol CharacterListCellDelegate: class {
    func favoritesButtonTapped(character: Character, indexPath: IndexPath)
}

final class ItemListCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var authorLabel: UILabel?
    @IBOutlet private weak var descriptionLabel: UILabel?
    @IBOutlet private weak var scoreLabel: UILabel?
    
    weak var delegate: CharacterListCellDelegate?
    
    func bind(item: Item) {
        titleLabel?.text = item.title
        authorLabel?.text = item.user
        descriptionLabel?.text = item.description
        scoreLabel?.text = String(item.score)
    }
}
