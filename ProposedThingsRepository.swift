//
//  ProposedThingsRepository.swift
//
//  Created by Sergey Blazhko on 8/9/18.
//  Copyright © 2018 Sergey Blazhko. All rights reserved.
//

import UIKit

class ProposedThingsRepository: SingleSectionTableDataSource<Thing>, ProposedThingsScene.Repository {
    
    var canLoadMore: Bool = true
    var isEmpty: Bool { return items.isEmpty }
    
    var api: ThingsApiRouter { return ApiManager.shared }
    
    lazy var emptyStateProvider: ProposedThingsScene.EmptyStateProvider = {
        return ProposedThingsEmptyStateProvide()
    }()
    
    override func set(tableView: UITableView?) {
        super.set(tableView: tableView)
        emptyStateProvider.set(table: tableView)
    }
    
    func loadMore(_ completion: @escaping LoadingCompletion) {
        load(refreshing: false, completion: completion)
    }
    
    func refresh(_ completion: @escaping LoadingCompletion) {
        load(refreshing: true, completion: completion)
    }
    
    private func load(refreshing: Bool, completion: @escaping LoadingCompletion) {
        let offset = refreshing ? 0 : items.count
        
        emptyStateProvider.loadingStarted()
        api.load(offset: offset) {[weak self] (result) in
            defer {
                let state = result.loadedState
                self?.emptyStateProvider.loadingFinished(state: state)
                completion(state)
            }
            
            guard case .success(let data) = result,
                let items = data?.items
                else { return }
            
            self?.canLoadMore = data?.nextPageAvailable ?? false
            
            if refreshing { self?.set(items) }
                else { self?.append(items) }
        }
    }
    
    func itemAt(_ indexPath: IndexPath) -> ThingModel? {
        return super.itemAt(indexPath)
    }

}
