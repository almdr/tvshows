//
//  UIViewControllerExtension.swift
//  TvShow
//
//  Created by Alfonso Lino Muñoz Del Rio on 12/04/22.
//

import UIKit

public extension UIViewController {

    static var storyboard: UIStoryboard {
        UIStoryboard(name: String(describing: self), bundle: nil)
    }

    static func instantiate() -> Self {
        storyboard.instantiateInitialViewController() as! Self
    }
    
}
