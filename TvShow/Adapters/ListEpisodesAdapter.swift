//
//  ListEpisodesAdapter.swift
//  TvShow
//
//  Created by Alfonso Lino Muñoz Del Rio on 13/04/22.
//

import Foundation
import UIKit

protocol ListEpisodesViewControllerProtocol: NSObjectProtocol {
    func goToEpisodeDetail(_ episode: Episodes)
}

protocol ListEpisodeAdapterProtocol {
    var dataSource: [[Any]] { get set }
    func setTableView(_ tableView: UITableView)
}

class ListEpisodesAdapter: NSObject, ListEpisodeAdapterProtocol {

    private unowned let controller: ListEpisodesViewControllerProtocol
    var dataSource = [[Any]]()
    
    init(controller: ListEpisodesViewControllerProtocol) {
        self.controller = controller
    }
    
    func setTableView(_ tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ListEpisodesAdapter: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard self.dataSource.count > 0 && self.dataSource.first!.count > 0  else { return "" }
        return String("Season \((self.dataSource[section] as! [Episodes]).first!.season)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard self.dataSource[indexPath.section].count > 0 else { return UITableViewCell() }
        let episodes = self.dataSource[indexPath.section] as! [Episodes]
        let episode: Episodes = episodes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "episodeCell", for: indexPath)
        cell.textLabel?.text = "Episode \(episode.number)"
        return cell
    }
}

extension ListEpisodesAdapter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //guard let student = self.dataSource[indexPath.row] as? Show else { return }
        //self.controller.goToEpisodeDetail(<#T##student: Show##Show#>)
    }
    /*
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.dataSource[indexPath.row] {
            case is Show: return UITableView.automaticDimension
            case is String: return tableView.frame.height
            default: return 0
        }
    }*/
}
