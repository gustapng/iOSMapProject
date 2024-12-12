//
//  GeocodingResults.swift
//  iOSMapProject
//
//  Created by Gustavo Ferreira dos Santos on 07/12/24.
//

struct GeocodingResults: Decodable {
    let origin: GeocodingResult
    let destination: GeocodingResult
}
