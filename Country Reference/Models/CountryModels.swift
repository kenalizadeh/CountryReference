//
//  CountryModels.swift
//  Country Reference
//
//  Created by Kenan Alizadeh on 02.03.22.
//

import Foundation

struct CountryForRegionDTO: Decodable {
    let name: Name
    let languages: [String: String]
    let latlng: [Double]
    let area: Double
    let currencies: [String: Currency]
    let flags: Flag
    let borders: [String]?
}

struct CountryForRegionalBlocDTO: Decodable {
    let name: String
    let nativeName: String?
    let languages: [Language]
    let latlng: [Double]
    let area: Double?
    let currencies: [Currency]
    let flags: Flag
    let borders: [String]?
}

struct Language: Decodable {
    let name: String
    let nativeName: String
}

struct Flag: Decodable {
    let png: String?
    let svg: String?
}

struct Currency: Decodable {
    let code: String?
    let name: String
    let symbol: String?
}

struct Name: Decodable {
    let common: String
    let official: String
    let nativeName: [String: Translation]
}

struct Translation: Decodable {
    let official: String
    let common: String
}
