//
//  Show.swift
//  TvShow
//
//  Created by Alfonso Lino Muñoz Del Rio on 11/04/22.
//

public struct Show: Codable {
    let id: Int
    let url: String
    let name: String
    let genres: [String]
    let schedule: Schedule
    let image: Image?
    let summary: String?

    enum CodingKeys: String, CodingKey {
        case id, url, name, genres, schedule, image, summary
    }
}
