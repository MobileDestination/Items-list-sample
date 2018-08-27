//
//  ProposedThingsScene.swift
//
//  Created by Sergey Blazhko on 8/9/18.
//  Copyright © 2018 Sergey Blazhko. All rights reserved.
//

import Foundation

enum ProposedThingsScene {
    typealias View = ProposedThingsViewProtocol
    typealias Presenter = ProposedThingsPresenterProtocol
    
    typealias Repository = ProposedThingsRepositoryProtocol
    typealias EmptyStateProvider = ProposedThingsEmptyStateProviderProtocol
}

protocol ProposedThingsViewProtocol: class, TableViewController, InfiniteLoadingCollection, Refreshable, ToastMessageView {
    var presenter: ProposedThingsScene.Presenter! { get }
}

protocol ProposedThingsPresenterProtocol: Presentable, ItemViewPresenterProtocol {
    var view: ProposedThingsScene.View? { get }
    var repository: ProposedThingsScene.Repository { get }
    
    var canLoadMore: Bool { get }
    func loadMoreData()
    func refreshData()
    
    func present(_ view: ThingItemView, forRowAt indexPath: IndexPath)
}

protocol ProposedThingsRepositoryProtocol: TableDataSource, InfiniteLoadingRepository {
    var emptyStateProvider: ProposedThingsScene.EmptyStateProvider { get }
    
    func loadMore(_ completion: @escaping LoadingCompletion)
    func refresh(_ completion: @escaping LoadingCompletion)
    
    func itemAt(_ indexPath: IndexPath) -> ThingModel?
}

protocol ProposedThingsEmptyStateProviderProtocol: TableViewEmptyStateProviderProtocol, DelegateLessEmptyStateProviderProtocol {}

extension ProposedThingsPresenterProtocol {
    func present(_ view: ItemViewProtocol, forRowAt indexPath: IndexPath) {
        if let menuvItemView = view as? ProposedThingsTableViewCell {
            present(menuvItemView, forRowAt: indexPath)
        }
    }
}
