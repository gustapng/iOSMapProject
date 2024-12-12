//
//  NewRaceService.swift
//  iOSMapProject
//
//  Created by Gustavo Ferreira dos Santos on 07/12/24.
//

import Foundation
import Combine

class NewRaceService: BaseService {
    func fetchRacesOptions(customerId: String, origin: String, destination: String) -> AnyPublisher<RaceOptionsResponse, APIError> {

        let body: [String: Any] = [
            "customer_id": customerId,
            "origin": origin,
            "destination": destination
        ]

        let endpoint = "\(APIConstants.baseURL)/ride/estimate"

        return request(endpoint: endpoint, method: "POST", body: body)
    }
}
