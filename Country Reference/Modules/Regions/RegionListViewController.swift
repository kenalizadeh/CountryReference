//
//  RegionListViewController.swift
//  Country Reference
//
//  Created by Kenan Alizadeh on 01.03.22.
//

import UIKit
import Combine

class RegionListViewController: UIViewController {
    private lazy var tableView: UITableView = UITableView(frame: .zero, style: .grouped).update(makeTableView)

    private var stateSubscription: AnyCancellable?

    private let viewModel: RegionListViewModel = .init()
}

// MARK: - Lifecycle
extension RegionListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.setupCombine()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - UI EXT
private extension RegionListViewController {
    func setupUI() {
        _ = self.tableView
    }

    func makeTableView(_ v: inout UITableView) {
        v.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(v)
        [
            v.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            v.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            v.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ].activate()

        v.delegate = viewModel
        v.dataSource = viewModel
        v.rowHeight = 35
        v.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
}

// MARK: - Combine EXT
private extension RegionListViewController {
    func setupCombine() {
        stateSubscription = viewModel
            .$state
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: handeStateChange)
    }

    func handeStateChange(_ state: RegionListViewState) {
        switch state {
        case .loaded:
            self.tableView.reloadData()

        case .countrySelected(let subject):
            let vc = CountryListViewController(searchSubject: subject)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
