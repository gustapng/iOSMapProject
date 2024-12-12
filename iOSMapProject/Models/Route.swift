//
//  Route.swift
//  iOSMapProject
//
//  Created by Gustavo Ferreira dos Santos on 07/12/24.
//

struct Route: Codable {
    let legs: [Leg]
    let description: String
    let warnings: [String]?
}
