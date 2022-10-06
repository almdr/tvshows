//
//  ShowsBuilder.swift
//  TvShow
//
//  Created by Alfonso Lino Muñoz Del Rio on 11/04/22.
//

import UIKit

public class ShowBuilder {
    
    public func build() -> UIViewController {
        let viewController = ShowViewController.instantiate()
        let router = ShowsRouter(viewController: viewController)
        let viewModel = ShowsViewModel(router: router)
        viewController.configure(with: viewModel)
        return viewController
    }
}

