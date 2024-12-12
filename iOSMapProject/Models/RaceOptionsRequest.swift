//
//  RaceOptionsRequest.swift
//  iOSMapProject
//
//  Created by Gustavo Ferreira dos Santos on 07/12/24.
//

struct RaceOptionsRequest: Encodable {
    let customer_id: String
    let origin: String
    let destination: String
}
