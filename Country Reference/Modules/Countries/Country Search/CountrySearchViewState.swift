//
//  CountrySearchViewState.swift
//  Country Reference
//
//  Created by Kenan Alizadeh on 02.03.22.
//

import Foundation

enum CountrySearchViewState {
    case loaded
    case needsReload
    case selectedCountry(CountryDetail)
}
