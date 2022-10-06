//
//  EpisodesBuilder.swift
//  TvShow
//
//  Created by Alfonso Muñoz del Río (Contractor) on 5/10/22.
//

import UIKit

public class EpisodesBuilder {
    private let episode: Episodes
    
    public init(episode: Episodes) {
        self.episode = episode
    }
    
    public func build() -> UIViewController {
        let viewController = EpisodesViewController.instantiate()
        let viewModel = EpisodesViewModel(episode: episode)
        viewController.configure(with: viewModel)
        return viewController
    }
}
