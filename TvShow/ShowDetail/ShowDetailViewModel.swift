//
//  ShowDetailViewModel.swift
//  TvShow
//
//  Created by Alfonso Lino Muñoz Del Rio on 13/04/22.
//

import Foundation
import ReactiveKit
import Bond

private struct Constants {
    static let minLengthSearchText = 3
}

class ShowDetailViewModel {
    public var bag = DisposeBag()
    let router: ShowDetailRouter
    let show: Show
    
    let imageURL = Observable("")
    let name = Observable("")
    let daysTime = Observable([])
    let genres = Observable([])
    let summary = Observable("")
    let seasonEpisodes = Observable([[]])
    let episodesProvider = EpisodesProvider()
    
    public init(router: ShowDetailRouter, show: Show) {
        self.router = router
        self.show = show
        configuration()
    }

    func configuration() {
        imageURL.value = show.image?.original ?? ""
        name.value = show.name
        daysTime.value = show.schedule.days + [show.schedule.time]
        genres.value = show.genres
        summary.value = show.summary ?? ""
        loadEpisodes()
    }
    
    func loadEpisodes() {
        episodesProvider.loadEpisodes(showId: show.id) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let episodes):
                let dict = Dictionary(grouping: episodes, by: { $0.season })
                var data: [[Episodes]] = []
                for key in dict.keys.sorted() {
                    data.append(dict[key]!)
                }
                self.seasonEpisodes.value = data
            case .failure(let error):
                self.seasonEpisodes.value = []
            }
        }
    }
    
    func goToEpisodeDetail(episode: Episodes) {
        router.goToEpisodeDetail(episode: episode)
    }
}

extension ShowDetailViewModel: DisposeBagProvider, BindingExecutionContextProvider {
    public var bindingExecutionContext: ExecutionContext {
        return .immediateOnMain
    }
}

