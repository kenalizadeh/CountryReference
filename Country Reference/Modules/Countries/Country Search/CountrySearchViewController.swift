//
//  CountrySearchViewController.swift
//  Country Reference
//
//  Created by Kenan Alizadeh on 02.03.22.
//

import UIKit
import Combine

class CountrySearchViewController: UIViewController {
    private lazy var searchBar: UISearchBar = .build(makeSearchBar)

    private lazy var tableView: UITableView = .build(makeTableView)

    private var stateSubscription: AnyCancellable?

    private let viewModel: CountrySearchViewModel = .init()
}

// MARK: - Lifecycle
extension CountrySearchViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        uiSetup()
        combineSetup()
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
private extension CountrySearchViewController {
    func uiSetup() {
        self.view.backgroundColor = .systemBackground

        _ = self.tableView
    }

    func makeSearchBar(_ v: inout UISearchBar) {
        v.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(v)
        [
            v.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            v.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ].activate()

        v.delegate = self
    }

    func makeTableView(_ v: inout UITableView) {
        v.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(v)
        [
            v.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            v.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ].activate()

        v.delegate = viewModel
        v.dataSource = viewModel
        v.rowHeight = 55
        v.register(CountryCell.self, forCellReuseIdentifier: "Cell")
    }
}

// MARK: - Combine EXT
private extension CountrySearchViewController {
    func combineSetup() {
        stateSubscription = viewModel
            .$state
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: handleStateChange)
    }

    func handleStateChange(_ state: CountrySearchViewState) {
        switch state {
        case .loaded, .needsReload:
            self.tableView.reloadData()

        case .selectedCountry(let country):
            let vc = CountryDetailViewController(dataSourceType: .static(country: country))
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - UISearchBarDelegate conformance
extension CountrySearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.queryText = searchText
    }
}
