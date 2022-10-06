//
//  ShowsViewModel.swift
//  TvShow
//
//  Created by Alfonso Lino Muñoz Del Rio on 11/04/22.
//

import Foundation
import ReactiveKit
import Bond

private struct Constants {
    static let minLengthSearchText = 3
}

class ShowsViewModel {
    public var bag = DisposeBag()
    let router: ShowsRouter
    let page = Observable<Int>(0)
    let shows = Observable<[Show]>([])
    let search = Observable<String?>(nil)
    let errorMessage = Observable<String>("")
    let showProvider = ShowProvider()
    let searchProvider = SearchProvider()
    let showLoading = Observable(false)
    
    public init(router: ShowsRouter) {
        self.router = router
        configuration()
    }

    func configuration() {
        page.bind(to: self) { (me, page) in
            me.load(page: page)
        }
        search.bind(to: self) { (me, text) in
            guard let searchText = text else {
                return
            }
            if searchText == "" {
                self.load(page: 0)
            } else {
                me.search(text: searchText)
            }
        }
    }
    
    func load(page: Int = 0) {
        showLoading.value = true
        showProvider.loadShow(page: page) { [weak self] (result) in
            guard let self = self else { return }
            self.showLoading.value = false
            switch result {
            case .success(let showsResult):
                if page == 0 {
                    self.shows.value = showsResult
                } else {
                    self.shows.value = self.shows.value + showsResult
                }
            case .failure(let error):
                self.errorMessage.value = error.localizedDescription
            }
        }
    }
    
    func loadMore() {
        page.value += 1
    }
    
    func search(text: String) {
        searchProvider.loadSearch(query: text) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                self.shows.value = result.map({ $0.show })
            case .failure(let error):
                self.errorMessage.value = error.localizedDescription
            }
        }
    }
    
    func goToDetail(show: Show) {
        router.routeToDetail(show: show)
    }
}

extension ShowsViewModel: DisposeBagProvider, BindingExecutionContextProvider {
    public var bindingExecutionContext: ExecutionContext {
        return .immediateOnMain
    }
}

