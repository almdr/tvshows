//
//  EpisodesViewController.swift
//  TvShow
//
//  Created by Alfonso Muñoz del Río (Contractor) on 5/10/22.
//

import Foundation
import UIKit
import ReactiveKit
import Bond
import Kingfisher

class EpisodesViewController: UIViewController {
    
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var number: UILabel!
    @IBOutlet weak private var season: UILabel!
    @IBOutlet weak private var summary: UILabel!
    @IBOutlet weak private var image: UIImageView!

    private var viewModel: EpisodesViewModel!

    public func configure(with viewModel: EpisodesViewModel) {
        self.viewModel = viewModel
    }
}

extension EpisodesViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBinds()
    }
    
    func setupBinds() {
        viewModel.name.bind(to: nameLabel.reactive.text)
        _ = viewModel.imageURL.observeNext{ [weak self] stringURL in
            guard let self = self else { return }
            guard let url =  URL(string: stringURL) else { return }
            self.image.kf.setImage(with: ImageResource(downloadURL: url, cacheKey: nil),
                                        placeholder: UIImage(named: "placeholder"))
        }
        
        viewModel.number.bind(to: number.reactive.text)
        viewModel.season.bind(to: season.reactive.text)
        _ = viewModel.summary.observeNext { [weak self] html in
            guard let self = self else { return }
            do {
                let attributedString: NSAttributedString = try NSAttributedString(data: html.data(using: .utf8)!,
                                                                                  options: [.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
                self.summary.attributedText = attributedString
            } catch {
                self.summary.text = html
            }
        }
    }
}
