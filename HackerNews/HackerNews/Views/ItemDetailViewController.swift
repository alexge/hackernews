//
//  ItemDetailViewController.swift
//  HackerNews
//
//  Created by Alexander Ge on 28/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import UIKit

final class ItemDetailViewController: UIViewController {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    
    @IBOutlet private weak var scrollview: UIScrollView!
    @IBOutlet private weak var comment1: UILabel!
    @IBOutlet private weak var comment2: UILabel!
    @IBOutlet private weak var comment3: UILabel!
    @IBOutlet private weak var comment4: UILabel!
    @IBOutlet private weak var comment5: UILabel!
    
    var item: Item? {
        didSet {
            if isViewLoaded {
                DispatchQueue.main.async {
                    self.configureSubviews()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        if item != nil {
            configureSubviews()
        }
    }
    
    private func configureSubviews() {
        guard let item = item else { return }
        
        titleLabel.text = item.title
        descriptionLabel.text = item.description
        scoreLabel.text = String(item.score)
        authorLabel.text = item.user
        
        guard !item.comments.isEmpty else { return }
        
        let labelArray: [UILabel] = [comment1, comment2, comment3, comment4, comment5]
        
        for index in 0 ..< item.comments.count {
            labelArray[index].text = item.comments[index].text
        }
        
        scrollview.contentSize = CGSize(width: view.bounds.width, height: scrollview.contentSize.height)
    }
}
