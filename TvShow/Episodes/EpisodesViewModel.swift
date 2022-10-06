//
//  EpisodesViewModel.swift
//  TvShow
//
//  Created by Alfonso Muñoz del Río (Contractor) on 5/10/22.
//

import Foundation
import ReactiveKit
import Bond

class EpisodesViewModel {
    public var bag = DisposeBag()
    
    let episode: Episodes
    
    let name = Observable("")
    let number = Observable("")
    let season = Observable("")
    let summary = Observable("")
    let imageURL = Observable("")
    
    public init(episode: Episodes) {
        self.episode = episode
        configuration()
    }

    func configuration() {
        name.value = episode.name
        number.value = String(episode.number)
        season.value = String(episode.season)
        summary.value = episode.summary ?? ""
        imageURL.value = episode.image?.medium ?? ""
    }
}
