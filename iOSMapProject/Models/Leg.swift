//
//  Leg.swift
//  iOSMapProject
//
//  Created by Gustavo Ferreira dos Santos on 07/12/24.
//

struct Leg: Codable {
    let distanceMeters: Int
    let duration: String
    let polyline: Polyline
    let startLocation: RouteLocation
    let endLocation: RouteLocation
}
