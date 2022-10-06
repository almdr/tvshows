//
//  ShowDetailViewController.swift
//  TvShow
//
//  Created by Alfonso Lino Muñoz Del Rio on 13/04/22.
//

import Foundation
import UIKit
import ReactiveKit
import Bond
import Kingfisher

class ShowDetailViewController: UIViewController {
    
    @IBOutlet weak private var posterImage: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var daysTimeStack: UIStackView!
    @IBOutlet weak private var genresStack: UIStackView!
    @IBOutlet weak private var summaryLabel: UILabel!
    @IBOutlet weak private var tlbEpisodes: UITableView!
    
    lazy private var listAdapter: ListEpisodeAdapterProtocol = ListEpisodesAdapter(controller: self)
    private var viewModel: ShowDetailViewModel!

    public func configure(with viewModel: ShowDetailViewModel) {
        self.viewModel = viewModel
    }
}


extension ShowDetailViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listAdapter.setTableView(self.tlbEpisodes)
        self.setupBinds()
    }
    
    func setupBinds() {
        viewModel.name.bind(to: nameLabel.reactive.text)
        _ = viewModel.imageURL.observeNext{ [weak self] stringURL in
            guard let self = self else { return }
            guard let url =  URL(string: stringURL) else { return }
            self.posterImage.kf.setImage(with: ImageResource(downloadURL: url, cacheKey: nil),
                                        placeholder: UIImage(named: "placeholder"))
        }
        _ = viewModel.genres.observeNext { [weak self] items in
            guard let self = self else { return }
            for item in items {
                let genre = UILabel()
                genre.text = item as? String
                genre.textColor = .black
                self.genresStack.addArrangedSubview(genre)
            }
        }
        _ = viewModel.daysTime.observeNext { [weak self] items in
            guard let self = self else { return }
            for item in items {
                let dayTimeLabel = UILabel()
                dayTimeLabel.text = item as? String
                dayTimeLabel.textColor = .black
                dayTimeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
                self.daysTimeStack.addArrangedSubview(dayTimeLabel)
            }
        }
        _ = viewModel.summary.observeNext { [weak self] html in
            guard let self = self else { return }
            do {
                let attributedString: NSAttributedString = try NSAttributedString(data: html.data(using: .utf8)!,
                                                                                  options: [.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
                self.summaryLabel.attributedText = attributedString
            } catch {
                self.summaryLabel.text = html
            }
        }
        _ = self.viewModel.seasonEpisodes.observeNext { [weak self] data in
            guard let self = self else { return }
            self.listAdapter.dataSource = data
            self.tlbEpisodes.reloadData()
        }
    }
}

extension ShowDetailViewController: ListEpisodesViewControllerProtocol {
    
    func goToEpisodeDetail(_ episode: Episodes) {
        viewModel.goToEpisodeDetail(episode: episode)
    }
}
