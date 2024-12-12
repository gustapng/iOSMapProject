//
//  RaceOptionsRequest.swift
//  iOSMapProject
//
//  Created by Gustavo Ferreira dos Santos on 07/12/24.
//

struct RaceOptionsResponse: Codable {
    let origin: Location
    let destination: Location
    let distance: Int
    let duration: Int
    let options: [RaceOption]
    let routeResponse: RouteResponse
}
