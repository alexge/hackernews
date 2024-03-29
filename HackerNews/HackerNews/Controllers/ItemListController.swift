//
//  ItemListController.swift
//  HackerNews
//
//  Created by Alexander Ge on 28/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import UIKit

final class ItemListController: NSObject {
    
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
    
    private var cacheManager = CacheManager()
    
    private var requestPerformer: RequestPerformable
    
    init(navigationController: UINavigationController, requestPerformer: RequestPerformable = RequestPerformer()) {
        navController = navigationController
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ItemListViewController") as? ItemListViewController else {
            listViewController = ItemListViewController()
            self.requestPerformer = requestPerformer
            super.init()
            return
        }
        listViewController = viewController
        self.requestPerformer = requestPerformer
        
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
            self?.requestPerformer.fetchTopItemIds { itemIDs in
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
                strongSelf.requestPerformer.fetchItemDetail(itemID: String(strongSelf.itemsList[index])) { item in
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
        if let cachedItem = cacheManager.loadFromCache(itemID: String(item.id)) {
            detailVC.item = cachedItem
            navController.pushViewController(detailVC, animated: true)
            return
        } else {
            detailVC.item = item
            navController.pushViewController(detailVC, animated: true)
        }
        
        let commentNumber = item.commentList.count > 5 ? 5 : item.commentList.count
        DispatchQueue.global(qos: .background).async { [weak self] in
            var mutableItem = item
            for index in 0 ..< commentNumber {
                self?.requestPerformer.fetchComment(commentID: String(mutableItem.commentList[index])) { comment in
                    if let comment = comment {
                        mutableItem.comments.append(comment)
                    }
                    if mutableItem.comments.count == commentNumber {
                        detailVC.item = mutableItem
                        self?.cacheManager.saveToCache(item: mutableItem)
                    }
                }
            }
        }
    }
    
    internal func didReachBottom() {
        guard !isLoading else { return }
        loadNextPage()
    }
    
    internal func didSelectScore() {
        items = items.sorted(by: { $0.score > $1.score })
    }
    
    internal func didSelectTitle() {
        items = items.sorted(by: { $0.title < $1.title })
    }
    
    internal func didSelectAuthor() {
        items = items.sorted(by: { $0.user < $1.user })
    }
}
