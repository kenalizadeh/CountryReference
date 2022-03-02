//
//  CountryListViewController.swift
//  Country Reference
//
//  Created by Kenan Alizadeh on 01.03.22.
//

import UIKit
import Combine

class CountryListViewController: UIViewController {
    private lazy var tableView: UITableView = .build(makeTableView)

    private var stateSubscription: AnyCancellable?

    private let viewModel: CountryListViewModel

    private let searchSubject: CountrySearchSubject

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    init(searchSubject: CountrySearchSubject) {
        self.searchSubject = searchSubject
        self.viewModel = CountryListViewModel(searchSubject: searchSubject)

        super.init(nibName: nil, bundle: nil)
    }
}

// MARK: - Lifecycle
extension CountryListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupCombine()

        viewModel.load()
    }
}

// MARK: - UI EXT
private extension CountryListViewController {
    func setupUI() {
        self.view.backgroundColor = .systemBackground

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
        v.rowHeight = 55
        v.register(CountryCell.self, forCellReuseIdentifier: "Cell")
    }
}

// MARK: - Combine EXT
private extension CountryListViewController {
    func setupCombine() {
        stateSubscription = viewModel
            .$state
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: handleStateChange)
    }

    func handleStateChange(_ state: CountryListViewState) {
        switch state {
        case .loaded:
            self.tableView.reloadData()

        case .selectedCountry(let country):
            let vc = CountryDetailViewController(dataSourceType: .static(country: country))
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
