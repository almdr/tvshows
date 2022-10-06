//
//  TvShowTests.swift
//  TvShowTests
//
//  Created by Alfonso Lino Muñoz Del Rio on 11/04/22.
//

import XCTest
@testable import TvShow

class TvShowTests: XCTestCase {

    func testCodables() throws {
        let bundle = Bundle(for: Self.self)
        let jsonData = try Data(contentsOf: bundle.url(forResource: "shows", withExtension: "json")!)
        let shows = try? JSONDecoder().decode([Show].self, from: jsonData)
        XCTAssertNotNil(shows)
        XCTAssert(shows!.count == 240)
        XCTAssert(shows![0].id == 1)
    }
    
    func testEpisodesCodable() throws {
        let bundle = Bundle(for: Self.self)
        let jsonData = try Data(contentsOf: bundle.url(forResource: "episodes", withExtension: "json")!)
        let shows = try? JSONDecoder().decode([Episodes].self, from: jsonData)
        XCTAssertNotNil(shows)
        XCTAssert(shows!.count == 39)
        XCTAssert(shows![0].id == 1)
        XCTAssert(shows![0].number == 1)
        XCTAssert(shows![0].season == 1)
    }
}
