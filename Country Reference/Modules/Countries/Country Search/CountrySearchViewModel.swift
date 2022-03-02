//
//  CountrySearchViewModel.swift
//  Country Reference
//
//  Created by Kenan Alizadeh on 02.03.22.
//

import UIKit
import Combine

class CountrySearchViewModel: NSObject {
    @Published
    private(set) var state: CountrySearchViewState = .loaded

    @Published
    var queryText: String = ""

    private var data: [CountryDetail] = []

    private let service: NetworkService<[CountryForRegionalBlocDTO]> = .init()

    private var cancellables: [AnyCancellable] = []

    override init() {
        super.init()

        setupCombine()
    }
}

// MARK: - Combine EXT
private extension CountrySearchViewModel {
    func setupCombine() {
        service
            .$responseDTO
            .replaceNil(with: [])
            .receive(on: DispatchQueue.main)
            .compactMap({ $0 })
            .sink { data in
                let data = data.map { CountryDetail.mapped(from: $0) }
                self.data = data
                self.state = .needsReload
            }
            .store(in: &cancellables)

        $queryText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .map {
                if $0.isEmpty {
                    self.data = []
                    self.state = .needsReload
                    return nil
                } else {
                    return $0
                }
            }
            .receive(on: DispatchQueue.main)
            .compactMap({ $0 })
            .sink { [weak self] queryString in
                self?.queryCountries(queryString)
            }
            .store(in: &cancellables)
    }

    func queryCountries(_ queryString: String) {
        service.execute(for: CountryEndpoints.queryCountries(queryString))
    }
}

// MARK: - UITableViewDelegate conformance
extension CountrySearchViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }

        let country = self.data[indexPath.row]
        self.state = .selectedCountry(country)
    }
}

// MARK: - UITableViewDataSource conformance
extension CountrySearchViewModel: UITableViewDataSource {
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
