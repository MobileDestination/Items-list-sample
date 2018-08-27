//
//
//  ProposedThingsEmptyStateProvider.swift
//
//  Created by Sergey Blazhko on 8/10/18.
//  Copyright © 2018 Sergey Blazhko. All rights reserved.
//

import UIKit

class ProposedThingsEmptyStateProvide: TableViewEmptyStateProvider, ProposedThingsScene.EmptyStateProvider {
    override init() {
        super.init()
        dataSource = self
    }
}

extension ProposedThingsEmptyStateProvide: EmptyStateProviderDataSource {
    func description(for scrollView: UIScrollView, state: LoadingState) -> NSAttributedString? {
        guard case .loaded(.failed(let reason)) = state,
            let errorDescription = reason?.description else { return nil }
        
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.lightGray,
                          NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 17.0)]
        return NSAttributedString(string: errorDescription, attributes: attributes)
    }
    
    func image(for scrollView: UIScrollView, state: LoadingState) -> UIImage? {
        switch state {
            case .none, .loading: return nil
            case .loaded(.success): return #imageLiteral(resourceName: "EmptyStateNoData")
            case .loaded(.failed(_)): return #imageLiteral(resourceName: "EmptyStateSmthWentWrong")
        }
    }
    
    func buttonTitle(for scrollView: UIScrollView, for controlState: UIControlState, state: LoadingState) -> NSAttributedString? {
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.lightGray,
                          NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 13.0)]
        return NSAttributedString(string: "Try again", attributes: attributes)
    }
}
