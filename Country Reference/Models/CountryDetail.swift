//
//  CountryDetail.swift
//  Country Reference
//
//  Created by Kenan Alizadeh on 02.03.22.
//

import Foundation
import CoreLocation

struct CountryGeographicDetails {
    let coordinates: CLLocationCoordinate2D
    let area: Double
}

struct CountryDetail {
    let name: String
    let nativeName: String
    let flagURLString: String
    let currencies: [Currency]
    let languages: [String]
    let geographicDetails: CountryGeographicDetails
    let neighborCountryCodes: [String]
}

extension CountryDetail {
    static func mapped(from data: CountryForRegionDTO) -> CountryDetail {
        .init(
            name: data.name.common,
            nativeName: data.name.nativeName.first?.value.common ?? "",
            flagURLString: data.flags.png ?? "",
            currencies: data.currencies.map(\.value),
            languages: data.languages.map(\.value),
            geographicDetails: CountryGeographicDetails(
                coordinates: CLLocationCoordinate2D(
                    latitude: data.latlng.first ?? 0.0,
                    longitude: data.latlng.last ?? 0.0
                ),
                area: data.area
            ),
            neighborCountryCodes: data.borders ?? []
        )
    }

    static func mapped(from data: CountryForRegionalBlocDTO) -> CountryDetail {
        .init(
            name: data.name,
            nativeName: data.nativeName ?? "",
            flagURLString: data.flags.png ?? "",
            currencies: data.currencies,
            languages: data.languages.map(\.name),
            geographicDetails: CountryGeographicDetails(
                coordinates: CLLocationCoordinate2D(
                    latitude: data.latlng.first ?? 0.0,
                    longitude: data.latlng.last ?? 0.0
                ),
                area: data.area ?? 5_000_000
            ),
            neighborCountryCodes: data.borders ?? []
        )
    }
}
