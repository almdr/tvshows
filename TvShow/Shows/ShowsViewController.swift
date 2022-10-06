//
//  ShowsViewController.swift
//  TvShow
//
//  Created by Alfonso Lino Muñoz Del Rio on 11/04/22.
//

import Foundation
import UIKit
import Bond

class ShowViewController: UIViewController {
    
    @IBOutlet weak private var tlbShow: UITableView!
    @IBOutlet weak private var scrShow: UISearchBar!

    lazy private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.pullToRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    lazy private var listAdapter: ListShowAdapterProtocol = ListShowAdapter(controller: self)    
    private var viewModel: ShowsViewModel!

    public func configure(with viewModel: ShowsViewModel) {
        self.viewModel = viewModel
    }
}


extension ShowViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listAdapter.setTableView(self.tlbShow)
        self.setupBinds()
    }
    
    @objc private func pullToRefresh(_ sender: UIRefreshControl) {

    }
    
    func setupBinds() {
        self.viewModel.showLoading.bind(to: refreshControl)
        self.viewModel.shows.observeNext { shows in
            self.listAdapter.dataSource = shows
            self.tlbShow.reloadData()
        }
    }
}


extension ShowViewController: ListShowViewControllerProtocol {
    
    func goToShowDetail(_ show: Show) {
        viewModel.goToDetail(show: show)
    }
    
    func loadMore() {
        viewModel.loadMore()
    }
}

extension ShowViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.search.value = searchText
    }
}
