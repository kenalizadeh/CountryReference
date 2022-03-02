//
//  RegionListViewModel.swift
//  Country Reference
//
//  Created by Kenan Alizadeh on 01.03.22.
//

import Foundation
import UIKit

class RegionListViewModel: NSObject {
    @Published
    private(set) var state: RegionListViewState = .loaded

    private let regions: [Region] = Region.allCases
    private let regionalBlocs: [RegionalBloc] = RegionalBloc.allCases

    private var data: [[String]] {
        [
            regions.map(\.rawValue),
            regionalBlocs.map(\.rawValue)
        ]
    }

    override init() {
        super.init()

        self.state = .loaded
    }
}

// MARK: - UITableViewDelegate conformance
extension RegionListViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }

        let searchSubject: CountrySearchSubject = indexPath.section == 0 ?
            .region(regions[indexPath.row]) :
            .regionalBloc(regionalBlocs[indexPath.row])

        self.state = .countrySelected(searchSubject)
    }
}

// MARK: - UITableViewDataSource conformance
extension RegionListViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        data.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data[section].count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "Region" : "Regional Bloc"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        var config = cell.defaultContentConfiguration()
        config.text = data[indexPath.section][indexPath.row]

        cell.contentConfiguration = config

        return cell
    }
}
