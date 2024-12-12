//
//  RaceOption.swift
//  iOSMapProject
//
//  Created by Gustavo Ferreira dos Santos on 07/12/24.
//

struct RaceOption: Codable {
    let id: Int
    let name: String
    let description: String
    let vehicle: String
    let review: Review
    let value: Double
}
