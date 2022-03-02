//
//  CountryEndpoints.swift
//  Country Reference
//
//  Created by Kenan Alizadeh on 01.03.22.
//

import Foundation
import Combine

enum CountryEndpoints {
    case getCountriesForSearchSubject(CountrySearchSubject)
    case getCountryDetails(String)
    case queryCountries(String)
}

extension CountryEndpoints: Endpoint {
    var path: String {
        switch self {
        case .getCountriesForSearchSubject(let subject):
            switch subject {
            case .region(let region):
                return "v3.1/region/\(region.rawValue)"
            case .regionalBloc(let regionalBloc):
                return "v2/regionalbloc/\(regionalBloc.rawValue)"
            }

        case .getCountryDetails(let countryName):
            return "v2/alpha/\(countryName)"

        case .queryCountries(let countryName):
            return "v2/name/\(countryName)"
        }
    }
}
