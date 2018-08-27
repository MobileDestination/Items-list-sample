//
//  ProposedThingsViewController.swift
//
//  Created by Sergey Blazhko on 8/8/18.
//  Copyright © 2018 Sergey Blazhko. All rights reserved.
//

import UIKit

import UIScrollView_InfiniteScroll

class ProposedThingsViewController: UIViewController, ProposedThingsScene.View {
    
    @IBOutlet var tableView: UITableView!
    
    lazy var presenter: ProposedThingsScene.Presenter! = {
        return ProposedThingsPresenter(self,
                                       repository: ProposedThingsRepository()) } ()
    
    lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refresh(sender:)) , for: .valueChanged)
        control.alpha = 0
        return control
    }()
    
    lazy var stickyHeader: ProposedThingsStickyHeaderView = {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: 79)
        return ProposedThingsStickyHeaderView(frame: frame)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTable()
        presenter.start()
    }

    func setupUI() {
        view.backgroundColor = .white
        
        tableView.backgroundColor = .background
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func setupTable() {
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        tableView.infiniteScrollTriggerOffset = 20
        tableView.addInfiniteScroll {[weak self] _ in
            self?.presenter.loadMoreData()
        }
        tableView.setShouldShowInfiniteScrollHandler { [weak self] _ in
            self?.presenter.canLoadMore ?? false
        }

        presenter.repository.addConfiguration(ProposedThingsTableViewCell.self) { [weak self] (cell, indexPath) in
            guard let sSelf = self else { return }
            cell.selectionStyle = .none
            sSelf.presenter.present(cell, forRowAt: indexPath)
            cell.interestedHandler = {(cell) in
                if let ip = sSelf.tableView.indexPath(for: (cell)) {
                    sSelf.selectItem(at: ip)
                }
            }
        }
        
        presenter.repository.set(tableView: tableView)
        
        if #available(iOS 11.0, *) { tableView.contentInsetAdjustmentBehavior = .never }
        
        tableView.addSubview(stickyHeader)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        stickyHeader.refreshingStarted()
        presenter.refreshData()
    }
    
    func endRefreshing() {
        stickyHeader.refreshingFinished()
        refreshControl.endRefreshing()
    }
    
    //MARK: - Segue
    
    func selectItem(at indexPath: IndexPath) {
        guard let item = presenter.repository.itemAt(indexPath) else { return }
        performSegue(withIdentifier: "toInterested", sender: item)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let interestedVC = segue.destination as? ThingInterestedViewController,
            let thing = sender as? Thing {
            interestedVC.thing = thing
        }
    }
}
