//
//  ListShowAdapter.swift
//  TvShow
//
//  Created by Alfonso Lino Muñoz Del Rio on 12/04/22.
//

import UIKit

protocol ListShowViewControllerProtocol: NSObjectProtocol {
    func goToShowDetail(_ student: Show)
    func loadMore()
}

protocol ListShowAdapterProtocol {
    var dataSource: [Any] { get set }
    func setTableView(_ tableView: UITableView)
}

class ListShowAdapter: NSObject, ListShowAdapterProtocol {
    
    private unowned let controller: ListShowViewControllerProtocol
    var dataSource = [Any]()
    
    init(controller: ListShowViewControllerProtocol) {
        self.controller = controller
    }
    
    func setTableView(_ tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ListShowAdapter: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let show = self.dataSource[indexPath.row] as? Show {
            return ShowTableViewCell.buildInTableView(tableView, indexPath: indexPath, show: show)
        } else if let errorMessage = self.dataSource[indexPath.row] as? String {
            let cell = tableView.dequeueReusableCell(withIdentifier: "errorCell", for: indexPath)
            cell.textLabel?.text = errorMessage
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension ListShowAdapter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let student = self.dataSource[indexPath.row] as? Show else { return }
        self.controller.goToShowDetail(student)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.dataSource[indexPath.row] {
            case is Show: return UITableView.automaticDimension
            case is String: return tableView.frame.height
            default: return 0
        }
    }
}


extension ListShowAdapter: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.frame.size.height + 1 >= scrollView.contentSize.height {
            self.controller.loadMore()
        }
    }
}
