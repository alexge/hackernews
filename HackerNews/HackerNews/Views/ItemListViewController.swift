//
//  ItemListViewController.swift
//  HackerNews
//
//  Created by Alexander Ge on 28/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import UIKit

protocol ItemListViewControllerDelegate: class {
    func didSelectItem(_ character: Item)
    func didReachBottom()
    func didSelectScore()
    func didSelectTitle()
    func didSelectAuthor()
}

final class ItemListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView? {
        didSet {
            tableView?.delegate = self
            tableView?.dataSource = self
        }
    }
    
    var items = [Item]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView?.reloadData()
                self.tableView?.tableFooterView?.isHidden = true
            }
        }
    }
    
    weak var delegate: ItemListViewControllerDelegate?
    var moreResults: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Top Stories"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView?.reloadData()
    }
    
    @IBAction func didTapScore(_ sender: Any) {
        delegate?.didSelectScore()
    }
    
    @IBAction func didTapTitle(_ sender: Any) {
        delegate?.didSelectTitle()
    }
    
    @IBAction func didTapAuthor(_ sender: Any) {
        delegate?.didSelectAuthor()
    }
}

extension ItemListViewController: UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectItem(items[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ItemListViewController: UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemListCell") else { return UITableViewCell() }
        guard let listCell = cell as? ItemListCell else { return cell }
        
        listCell.bind(item: items[indexPath.row])
        
        return listCell
    }
    
    internal func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == items.count - 1 {
            if moreResults {
                tableView.tableFooterView?.isHidden = false
                delegate?.didReachBottom()
            }
        }
    }
}
