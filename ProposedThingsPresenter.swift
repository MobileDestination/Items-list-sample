//
//  ProposedThingsPresenter.swift
//
//  Created by Sergey Blazhko on 8/9/18.
//  Copyright © 2018 Sergey Blazhko. All rights reserved.
//

import Foundation

class ProposedThingsPresenter: ProposedThingsScene.Presenter {
    weak var view: ProposedThingsScene.View?
    var repository: ProposedThingsScene.Repository

    var canLoadMore: Bool { return repository.canLoadMore }
    
    init(_ view: ProposedThingsScene.View, repository: ProposedThingsScene.Repository) {
        self.view = view
        self.repository = repository
        
        self.repository.emptyStateProvider.setDidTapViewHandler { [weak self] (_, _) in
            self?.refreshData()
        }
        
        self.repository.emptyStateProvider.setDidTapButtonHandler { [weak self] (_, _) in
            self?.refreshData()
        }
    }
    
    func start() {
        loadMoreData()
    }
    
    func loadMoreData() {
        repository.loadMore {[weak self] (result) in
            self?.view?.hideInfiniteLoading()
            self?.handle(response: result)
        }
    }
    
    func refreshData() {
        repository.refresh { [weak self] (result) in
            self?.view?.endRefreshing()
            self?.handle(response: result)
        }
    }
    
    private func handle(response: LoadedState) {
        //If repository isEmpty - EmptyStateProvider will show error info
        guard case .failed(let error) = response,
            repository.isEmpty == false else { return }
        
        //If some data already exist - view should show error info
        let description = error?.description ?? "Ooopss.. something went wrong"
        view?.show(message: description)
    }
    
    func present(_ view: ThingItemView, forRowAt indexPath: IndexPath) {
        if let item = repository.itemAt(indexPath) {
            view.show(item)
        }
    }
}
