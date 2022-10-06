//
//  ShowViewModelTest.swift
//  TvShowTests
//
//  Created by Alfonso Lino Muñoz Del Rio on 12/04/22.
//

import Foundation
import XCTest
@testable import TvShow
import OHHTTPStubs
import OHHTTPStubsSwift
import ReactiveKit
import Bond

class ShowsViewModelTests: XCTestCase {
    override func setUp() {
        showsStubs()
        searchStubs()
    }
    
    func showsStubs() {
        stub(condition: isScheme("https") &&
                        isMethodGET() &&
                        isHost("api.tvmaze.com") &&
                        isPath("/shows") &&
                        containsQueryParams(["page": "0"])) { _ in
          return HTTPStubsResponse(
            fileAtPath: OHPathForFile("shows.json", type(of: self))!,
            statusCode: 200,
            headers: ["Content-Type": "application/json"]
          )
        }
    }
    
    func searchStubs() {
        stub(condition: isScheme("https") &&
                        isMethodGET() &&
                        isHost("api.tvmaze.com") &&
                        isPath("/search/shows") &&
                        containsQueryParams(["q": "success"])) { _ in
          return HTTPStubsResponse(
            fileAtPath: OHPathForFile("success.json", type(of: self))!,
            statusCode: 200,
            headers: ["Content-Type": "application/json"]
          )
        }
    }
    
    func testLoadShows() throws {
        let router = ShowsRouter(viewController: UIViewController())
        let showsViewModel = ShowsViewModel(router: router)
        let expectation = self.expectation(description: "Request fetch shows expectation")
        showsViewModel.shows.bind(to: self) { (_, shows) in
            guard shows.count != 0 else { return }
            XCTAssert(shows.count == 240)
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 5)
    }
    
    func testSearchShows() throws {
        let router = ShowsRouter(viewController: UIViewController())
        let showsViewModel = ShowsViewModel(router: router)
        let expectation1 = self.expectation(description: "First value")
        let expectation2 = self.expectation(description: "First Load value")
        let expectation3 = self.expectation(description: "Request search shows")
        showsViewModel.search.value = "success"
        showsViewModel.shows.bind(to: self) { (_, shows) in
            if shows.count == 0 {
                expectation1.fulfill()
            } else if shows.count == 240 {
                expectation2.fulfill()
            } else {
                XCTAssert(shows.count == 10)
                expectation3.fulfill()
            }
        }
        self.wait(for: [expectation1], timeout: 5)
        self.wait(for: [expectation2], timeout: 5)
        self.wait(for: [expectation3], timeout: 5)
    }
}

extension ShowsViewModelTests: BindingExecutionContextProvider {
    public var bindingExecutionContext: ExecutionContext {
        return .immediateOnMain
    }
}
