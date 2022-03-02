//
//  RegionsViewState.swift
//  Country Reference
//
//  Created by Kenan Alizadeh on 01.03.22.
//

import Foundation

enum CountrySearchSubject {
    case region(Region)
    case regionalBloc(RegionalBloc)
}

enum RegionListViewState {
    case loaded
    case countrySelected(CountrySearchSubject)
}
