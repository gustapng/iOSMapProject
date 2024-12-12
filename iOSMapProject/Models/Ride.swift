//
//  Ride.swift
//  iOSMapProject
//
//  Created by Gustavo Ferreira dos Santos on 07/12/24.
//

struct Ride: Decodable {
    let id: Int
    let date: String
    let origin: String
    let destination: String
    let distance: Double
    let duration: String
    let driver: Driver
    let value: Double
}
