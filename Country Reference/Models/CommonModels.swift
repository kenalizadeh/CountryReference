//
//  CommonModels.swift
//  Country Reference
//
//  Created by Kenan Alizadeh on 02.03.22.
//

import Foundation

enum Region: String, Codable, CaseIterable {
    case africa         = "Africa"
    case americas       = "Americas"
    case asia           = "Asia"
    case europe         = "Europe"
    case northAmerica   = "North America"
    case oceania        = "Oceania"
    case southAmerica   = "South America"
}

enum RegionalBloc: String, Codable, CaseIterable {
    /// European Union
    case eu         = "EU"
    /// European Free Trade Association
    case efta       = "EFTA"
    /// Caribbean Community
    case caricom    = "CARICOM"
    /// Pacific Alliance
    case pa         = "PA"
    /// African Union
    case au         = "AU"
    /// Union of South American Nations
    case usan       = "USAN"
    /// Eurasian Economic Union
    case eeu        = "EEU"
    /// Arab League
    case al         = "AL"
    /// Association of Southeast Asian Nations
    case asean      = "ASEAN"
    /// Central American Integration System
    case cais       = "CAIS"
    /// Central European Free Trade Agreement
    case cafta      = "CEFTA"
    /// North American Free Trade Agreement
    case nafta      = "NAFTA"
    /// South Asian Association for Regional Cooperation
    case saarc      = "SAARC"

    var title: String {
        switch self {
        case .eu:
            return "European Union"
        case .efta:
            return "European Free Trade Association"
        case .caricom:
            return "Caribbean Community"
        case .pa:
            return "Pacific Alliance"
        case .au:
            return "African Union"
        case .usan:
            return "Union of South American Nations"
        case .eeu:
            return "Eurasian Economic Union"
        case .al:
            return "Arab League"
        case .asean:
            return "Association of Southeast Asian Nations"
        case .cais:
            return "Central American Integration System"
        case .cafta:
            return "Central European Free Trade Agreement"
        case .nafta:
            return "North American Free Trade Agreement"
        case .saarc:
            return "South Asian Association for Regional Cooperation"
        }
    }
}
