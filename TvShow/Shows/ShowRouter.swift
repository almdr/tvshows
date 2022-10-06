//
//  ShowRouter.swift
//  TvShow
//
//  Created by Alfonso Lino Muñoz Del Rio on 12/04/22.
//

import UIKit

public class ShowsRouter {
    public weak var viewController: UIViewController?
    
    public required init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public func routeToDetail(show: Show) {
        let viewController = ShowDetailBuilder(show: show).build()
        self.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
