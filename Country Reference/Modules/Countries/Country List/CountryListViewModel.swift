//
//  CountryListViewModel.swift
//  Country Reference
//
//  Created by Kenan Alizadeh on 01.03.22.
//

import UIKit
import Combine

class CountryListViewModel: NSObject {
    @Published
    private(set) var state: CountryListViewState = .loaded

    private let searchSubject: CountrySearchSubject

    private var data: [CountryDetail] = []

    private let countryForRegionService: NetworkService<[CountryForRegionDTO]> = .init()

    private let countryForRegionalBlocService: NetworkService<[CountryForRegionalBlocDTO]> = .init()

    private var serviceSubscription: AnyCancellable?

    init(searchSubject: CountrySearchSubject) {
        self.searchSubject = searchSubject
    }
}

// MARK: - Lifecycle
extension CountryListViewModel {
    func load() {
        serviceSubscription?.cancel()

        switch searchSubject {
        case .region(let region):
            serviceSubscription = countryForRegionService
                .$responseDTO
                .receive(on: DispatchQueue.main)
                .compactMap({ $0 })
                .sink { data in
                    let data = data.map { CountryDetail.mapped(from: $0) }
                    self.data = data
                    self.state = .loaded
                }

            countryForRegionService.execute(for: CountryEndpoints.getCountriesForSearchSubject(.region(region)))

        case .regionalBloc(let regionalBloc):
            serviceSubscription = countryForRegionalBlocService
                .$responseDTO
                .receive(on: DispatchQueue.main)
                .compactMap({ $0 })
                .sink { data in
                    let data = data.map { CountryDetail.mapped(from: $0) }
                    self.data = data
                    self.state = .loaded
                }

            countryForRegionalBlocService.execute(for: CountryEndpoints.getCountriesForSearchSubject(.regionalBloc(regionalBloc)))
        }
    }
}

// MARK: - UITableViewDelegate conformance
extension CountryListViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        let country = self.data[indexPath.row]
        self.state = .selectedCountry(country)
    }
}

// MARK: - UITableViewDataSource conformance
extension CountryListViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CountryCell

        let country = self.data[indexPath.row]

        cell.name = country.name
        cell.nativeName = country.nativeName
        cell.flagImageURLString = country.flagURLString

        return cell
    }
}
