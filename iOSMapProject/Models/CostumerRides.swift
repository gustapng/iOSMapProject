//
//  CostumerRides.swift
//  iOSMapProject
//
//  Created by Gustavo Ferreira dos Santos on 06/12/24.
//

struct CustomerRides: Decodable {
    let customerId: String
    let rides: [Ride]

    enum CodingKeys: String, CodingKey {
        case customerId = "customer_id"
        case rides
    }
}
