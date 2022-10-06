//
//  Episodes.swift
//  TvShow
//
//  Created by Alfonso Lino Muñoz Del Rio on 13/04/22.
//

public struct Episodes: Codable {
    let id: Int
    let name: String
    let image: Image?
    let number: Int
    let season: Int
    let summary: String?

    enum CodingKeys: String, CodingKey {
        case id, name, image, number, season, summary
    }
}
