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
    
    private var isLoading: Bool = false {
        didSet {
            if !isLoading {
                DispatchQueue.main.async {
                    self.listViewController.items = self.items
                }
            }
        }
    }
    private var offset: Int = 0
    private let pageCount = 20
    private var moreResults: Bool = true {
        didSet {
            listViewController.moreResults = moreResults
        }
    }
    
    private var itemsList = [Int]()
    private var items = [Item]()
    
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
        listViewController.title = "Heroes"
        fetchItemList()
    }
    
    private func fetchItemList(completion: (() -> Void)? = nil) {
        isLoading = true
        DispatchQueue.global(qos: .background).async { [weak self] in
            requestPerformer?.fetchTopItemIds { itemIDs in
                guard let strongSelf = self else { return }
                strongSelf.itemsList = itemIDs
                if strongSelf.pageCount > itemIDs.count {
                    for index in 0 ..< strongSelf.pageCount {
                        requestPerformer?.fetchItemDetail(itemID: String(itemIDs[index])) { item in
                            if let item = item {
                                strongSelf.items.append(item)
                                if strongSelf.items.count == strongSelf.pageCount {
                                    strongSelf.isLoading = false
                                    strongSelf.offset = strongSelf.pageCount - 1
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func fetchNextPage(completion: (() -> Void)? = nil) {
        guard !isLoading, offset < items.count - 1 else { return }
        isLoading = true
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let strongSelf = self else { return }
            for index in strongSelf.offset ..< strongSelf.pageCount + strongSelf.offset {
                requestPerformer?.fetchItemDetail(itemID: String(itemIDs[index])) { item in
                    if let item = item {
                        strongSelf.items.append(item)
                        if strongSelf.items.count == strongSelf.pageCount {
                            strongSelf.isLoading = false
                            strongSelf.offset = strongSelf.pageCount - 1
                        }
                    }
                }
            }
        }
    }
}

extension ItemListController: ItemListViewControllerDelegate {
    internal func didSelectItem(_ character: Character) {
//        let detailVC = CharacterDetailViewController(character: character)
//        detailVC.transitioningDelegate = self
//        detailVC.delegate = self
//        listViewController.present(detailVC, animated: true)
    }
    
    internal func didReachBottom() {
        guard !isLoading else { return }
        fetchCharacters(pageLoad: true)
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
