//
//  ShowDetailRouter.swift
//  TvShow
//
//  Created by Alfonso Lino Muñoz Del Rio on 13/04/22.
//

import UIKit

public class ShowDetailRouter {
    public weak var viewController: UIViewController?
    
    public required init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func goToEpisodeDetail(episode: Episodes) {
        let viewController = EpisodesBuilder(episode: episode).build()
        self.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }
}
