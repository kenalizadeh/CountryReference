//
//  CountryDetailViewController.swift
//  Country Reference
//
//  Created by Kenan Alizadeh on 01.03.22.
//

import UIKit
import Combine

class CountryDetailViewController: UIViewController {
    private lazy var tableView: UITableView = .init(frame: .zero, style: .grouped).update(makeTableView)

    private var stateSubscription: AnyCancellable?

    private let viewModel: CountryDetailViewModel

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    init(dataSourceType: CountryDetailViewModel.DataSourceType) {
        self.viewModel = CountryDetailViewModel(dataSourceType: dataSourceType)
        super.init(nibName: nil, bundle: nil)
    }
}

// MARK: - Lifecycle
extension CountryDetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupCombine()

        viewModel.load()
    }
}

// MARK: - UI EXT
private extension CountryDetailViewController {
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
        v.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        v.register(CountryMapCell.self, forCellReuseIdentifier: "CountryMapCell")
        v.register(FlagCell.self, forCellReuseIdentifier: "FlagCell")
    }
}

// MARK: - Combine EXT
private extension CountryDetailViewController {
    func setupCombine() {
        stateSubscription = viewModel
            .$state
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: handeStateChange)
    }

    func handeStateChange(_ state: CountryDetailViewState) {
        switch state {
        case .loaded:
            self.tableView.reloadData()

        case .selectedNeighborCountry(let countryCode):
            let vc = CountryDetailViewController(dataSourceType: .remote(code: countryCode))
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
