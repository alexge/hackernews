//
//  ItemDetailViewController.swift
//  HackerNews
//
//  Created by Alexander Ge on 28/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerDelegate: class {
    func favoriteButtonTapped(character: Character)
}

class ItemDetailViewController: UIViewController {
    
    private let character: Character
    
    private var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.isScrollEnabled = true
        sv.isUserInteractionEnabled = true
        return sv
    }()
    
    private var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var favoritesButton = FavoritesButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private var comicsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Most Recent Comics"
        return label
    }()
    
    private var comics: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()
    
    private var storiesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Most Recent Stories"
        return label
    }()
    
    private var stories: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()
    
    private var eventsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Most Recent Events"
        return label
    }()
    
    private var events: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()
    
    private var seriesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Most Recent Series"
        return label
    }()
    
    private var series: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()
    
    private var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    weak var delegate: ItemDetailViewControllerDelegate?
    
    init(character: Character) {
        self.character = character
        super.init(nibName: nil, bundle: nil)
        
        title = character.name
        view.backgroundColor = .white
        
        addSubviews()
        constrainSubviews()
        configureSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = containerView.intrinsicContentSize
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(favoritesButton)
        containerView.addSubview(nameLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(comicsLabel)
        containerView.addSubview(comics)
        containerView.addSubview(storiesLabel)
        containerView.addSubview(stories)
        containerView.addSubview(eventsLabel)
        containerView.addSubview(events)
        containerView.addSubview(seriesLabel)
        containerView.addSubview(series)
        containerView.addSubview(backButton)
    }
    
    private func constrainSubviews() {
        let interitemSpacing: CGFloat = 24
        
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        containerView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        favoritesButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
        favoritesButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: (-1)*interitemSpacing).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 40).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: interitemSpacing).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: interitemSpacing).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: interitemSpacing).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        comicsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: interitemSpacing).isActive = true
        comicsLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: interitemSpacing).isActive = true
        comics.topAnchor.constraint(equalTo: comicsLabel.bottomAnchor, constant: interitemSpacing).isActive = true
        comics.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: interitemSpacing).isActive = true
        comics.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        storiesLabel.topAnchor.constraint(equalTo: comics.bottomAnchor, constant: interitemSpacing).isActive = true
        storiesLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: interitemSpacing).isActive = true
        stories.topAnchor.constraint(equalTo: storiesLabel.bottomAnchor, constant: interitemSpacing).isActive = true
        stories.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: interitemSpacing).isActive = true
        stories.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        eventsLabel.topAnchor.constraint(equalTo: stories.bottomAnchor, constant: interitemSpacing).isActive = true
        eventsLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: interitemSpacing).isActive = true
        events.topAnchor.constraint(equalTo: eventsLabel.bottomAnchor, constant: interitemSpacing).isActive = true
        events.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: interitemSpacing).isActive = true
        events.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        seriesLabel.topAnchor.constraint(equalTo: events.bottomAnchor, constant: interitemSpacing).isActive = true
        seriesLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: interitemSpacing).isActive = true
        series.topAnchor.constraint(equalTo: seriesLabel.bottomAnchor, constant: interitemSpacing).isActive = true
        series.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: interitemSpacing).isActive = true
        series.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        backButton.topAnchor.constraint(equalTo: series.bottomAnchor, constant: 48).isActive = true
        backButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: interitemSpacing).isActive = true
        backButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: (-1)*interitemSpacing).isActive = true
    }
    
    private func configureSubviews() {
        favoritesButton.bind(character: character)
        favoritesButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        nameLabel.text = character.name
        descriptionLabel.text = character.description
        
        for index in 0...2 {
            if index + 1 < character.comics.count {
                let label = UILabel()
                let comic = character.comics[index]
                label.text = comic.name
                comics.addArrangedSubview(label)
            }
        
            if index + 1 < character.stories.count {
                let label = UILabel()
                let story = character.stories[index]
                label.text = story.name
                stories.addArrangedSubview(label)
            }
        
            if index + 1 < character.events.count {
                let label = UILabel()
                let event = character.events[index]
                label.text = event.name
                events.addArrangedSubview(label)
            }
            
            if index + 1 < character.series.count {
                let label = UILabel()
                let seriesItem = character.series[index]
                label.text = seriesItem.name
                series.addArrangedSubview(label)
            }
        }
        
        backButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true)
    }
    
    @objc private func buttonTapped() {
        delegate?.favoriteButtonTapped(character: character)
        favoritesButton.refresh()
    }
}
