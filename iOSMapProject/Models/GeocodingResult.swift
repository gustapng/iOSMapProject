//
//  GeocodingResult.swift
//  iOSMapProject
//
//  Created by Gustavo Ferreira dos Santos on 07/12/24.
//

struct GeocodingResult: Decodable {
    let geocoderStatus: [String: String]
    let type: [String]
    let placeId: String
}
