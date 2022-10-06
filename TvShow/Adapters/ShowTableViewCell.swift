//
//  ShowTableViewCell.swift
//  TvShow
//
//  Created by Alfonso Lino Muñoz Del Rio on 12/04/22.
//

import Foundation
import UIKit
import Kingfisher

class ShowTableViewCell: UITableViewCell {
    
    var show: Show! {
        didSet { self.updateData() }
    }
    
    private func updateData() {
        self.textLabel?.text = self.show.name
        guard let url =  URL(string: self.show.image?.medium ?? "") else { return }
        self.imageView?.kf.setImage(with: ImageResource(downloadURL: url, cacheKey: nil),
                                    placeholder: UIImage(named: "placeholder"))
    }
    
    override func prepareForReuse() {
        self.textLabel?.text = ""
        self.imageView?.kf.cancelDownloadTask()
        self.imageView?.image = nil
    }
    
    class func buildInTableView(_ tableView: UITableView, indexPath: IndexPath, show: Show) -> ShowTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showCell", for: indexPath) as? ShowTableViewCell
        cell?.show = show
        return cell ?? ShowTableViewCell()
    }
}
