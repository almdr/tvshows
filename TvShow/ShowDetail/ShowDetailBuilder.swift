//
//  ShowDetailBuilder.swift
//  TvShow
//
//  Created by Alfonso Lino Muñoz Del Rio on 13/04/22.
//

import UIKit

public class ShowDetailBuilder {
    private let show: Show
    
    public init(show: Show) {
        self.show = show
    }
    
    public func build() -> UIViewController {
        let viewController = ShowDetailViewController.instantiate()
        let router = ShowDetailRouter(viewController: viewController)
        let viewModel = ShowDetailViewModel(router: router, show: show)
        viewController.configure(with: viewModel)
        return viewController
    }
}


