//
//  ItemListController.swift
//  HackerNews
//
//  Created by Alexander Ge on 28/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import UIKit

class ItemListController: NSObject {
    
    private let navController: UINavigationController
    private let listViewController: ItemListViewController

    private let storyboard: UIStoryboard = UIStoryboard(name: "ItemList", bundle: .main)
    
    private var isLoading: Bool = false
    private var offset: Int = 0
    private let pageCount = 20
    private var moreResults: Bool = true {
        didSet {
            listViewController.moreResults = moreResults
        }
    }
    
    private var itemsList = [Int]()
    private var items = [Item]() {
        didSet {
            self.listViewController.items = self.items
        }
    }
    
    private var partialItems = [Item]()
    
    init(navigationController: UINavigationController) {
        navController = navigationController
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ItemListViewController") as? ItemListViewController else {
            listViewController = ItemListViewController()
            super.init()
            return
        }
        listViewController = viewController
        
        super.init()
        
        navController.setViewControllers([listViewController], animated: false)
        listViewController.delegate = self
        
        isLoading = true
        loadItemList { [weak self] in
            self?.loadNextPage()
        }
    }
    
    private func loadItemList(completion: (() -> Void)? = nil) {
        isLoading = true
        DispatchQueue.global(qos: .background).async { [weak self] in
            requestPerformer?.fetchTopItemIds { itemIDs in
                guard let strongSelf = self else { return }
                strongSelf.itemsList = itemIDs
                strongSelf.isLoading = false
                completion?()
            }
        }
    }
    
    private func loadNextPage(completion: (() -> Void)? = nil) {
        guard !isLoading, offset < itemsList.count else { return }
        isLoading = true
        partialItems = []
        
        let itemsToLoad: Int
        if itemsList.count - offset > pageCount {
            itemsToLoad = pageCount
        } else {
            itemsToLoad = itemsList.count - offset
            moreResults = false
        }
        
        for index in offset ..< offset + itemsToLoad {
            DispatchQueue.global(qos: .background).async { [weak self] in
                guard let strongSelf = self else { return }
                requestPerformer?.fetchItemDetail(itemID: String(strongSelf.itemsList[index])) { item in
                    if let item = item {
                        strongSelf.partialItems.append(item)
                        if strongSelf.partialItems.count == itemsToLoad {
                            strongSelf.isLoading = false
                            strongSelf.offset += itemsToLoad
                            strongSelf.items.append(contentsOf: strongSelf.partialItems)
                        }
                    }
                }
            }
        }
    }
}

extension ItemListController: ItemListViewControllerDelegate {
    internal func didSelectItem(_ item: Item) {
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "ItemDetailViewController") as? ItemDetailViewController else {
            return
        }
        detailVC.item = item
        navController.pushViewController(detailVC, animated: true)
    }
    
    internal func didReachBottom() {
        guard !isLoading else { return }
        loadNextPage()
    }
}

//extension ItemListController: UIViewControllerTransitioningDelegate {
//    internal func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        if let _ = presented as? CharacterDetailViewController {
//            return CharacterAnimationController(type: .fadeIn)
//        } else {
//            return nil
//        }
//    }
//
//    internal func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        if let _ = dismissed as? CharacterDetailViewController {
//            return CharacterAnimationController(type: .fadeOut)
//        } else {
//            return nil
//        }
//    }
//}
//
//extension ItemListController: CharacterDetailViewControllerDelegate {
//    internal func favoriteButtonTapped(character: Character) {
//        toggleFavorite(character: character)
//    }
//}
