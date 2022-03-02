//
//  CountryDetailViewModel.swift
//  Country Reference
//
//  Created by Kenan Alizadeh on 01.03.22.
//

import UIKit
import Combine

class CountryDetailViewModel: NSObject {
    @Published
    private(set) var state: CountryDetailViewState = .loaded

    private var country: CountryDetail?

    private let dataSourceType: DataSourceType

    private var serviceSubscription: AnyCancellable?

    init(dataSourceType: DataSourceType) {
        self.dataSourceType = dataSourceType
        super.init()
    }
}

// MARK: - Lifecycle
extension CountryDetailViewModel {
    func load() {
        switch dataSourceType {
        case .remote(let countryCode):
            let service = NetworkService<CountryForRegionalBlocDTO>()

            serviceSubscription = service
                .$responseDTO
                .receive(on: DispatchQueue.main)
                .compactMap { $0 }
                .sink { data in
                    self.country = .mapped(from: data)
                    self.state = .loaded
                }

            service.execute(for: CountryEndpoints.getCountryDetails(countryCode))

        case .static(let country):
            self.country = country
            self.state = .loaded
        }
    }
}

// MARK: - DataSourceType
extension CountryDetailViewModel {
    enum DataSourceType {
        case remote(code: String)
        case `static`(country: CountryDetail)
    }
}

// MARK: - UITableViewDelegate conformance
extension CountryDetailViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }

        guard
            let section = Sections(rawValue: indexPath.section),
            section == .neighbors,
            let country = self.country
        else { return }

        let neighborCountryCode = country.neighborCountryCodes[indexPath.row]
        self.state = .selectedNeighborCountry(code: neighborCountryCode)
    }
}

// MARK: - UITableViewDataSource conformance
extension CountryDetailViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        Sections.allCases.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        Sections.allCases[section].title
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard
            let section = Sections(rawValue: section),
            let country = self.country
        else { return 0 }

        switch section {
        case .flag:
            return 1
        case .currencies:
            return country.currencies.count
        case .languages:
            return country.languages.count
        case .map:
            return 1
        case .neighbors:
            return country.neighborCountryCodes.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let section = Sections(rawValue: indexPath.section),
            let country = self.country
        else { return UITableViewCell() }

        switch section {
        case .flag:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FlagCell", for: indexPath) as? FlagCell else {
                return UITableViewCell()
            }

            cell.imageURLString = country.flagURLString

            return cell

        case .currencies:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

            var config = cell.defaultContentConfiguration()
            config.text = country.currencies[indexPath.row].name

            cell.contentConfiguration = config

            return cell

        case .languages:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

            var config = cell.defaultContentConfiguration()
            config.text = country.languages[indexPath.row]

            cell.contentConfiguration = config

            return cell

        case .map:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryMapCell", for: indexPath) as? CountryMapCell else {
                return UITableViewCell()
            }

            cell.geographicDetails = country.geographicDetails

            return cell

        case .neighbors:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

            var config = cell.defaultContentConfiguration()
            config.text = country.neighborCountryCodes[indexPath.row]

            cell.contentConfiguration = config

            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = Sections(rawValue: indexPath.section) else { return 0 }

        return [.map, .flag].contains(section) ? (tableView.bounds.width / 2) : 40
    }
}

// MARK: - Sections EXT
private extension CountryDetailViewModel {
    enum Sections: Int, CaseIterable {
        case flag
        case currencies
        case languages
        case map
        case neighbors

        var title: String {
            switch self {
            case .flag:
                return "Flag"
            case .currencies:
                return "Currencies"
            case .languages:
                return "National Languages"
            case .map:
                return "Map"
            case .neighbors:
                return "Neighbors"
            }
        }
    }
}
