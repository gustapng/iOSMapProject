//
//  RaceHistoryService.swift
//  iOSMapProject
//
//  Created by Gustavo Ferreira dos Santos on 07/12/24.
//

import Foundation
import Combine

class RaceHistoryService: BaseService {
    func fetchRacesHistory(userId: String, driverId: String) -> AnyPublisher<CustomerRides, APIError> {
        var endpoint = "\(APIConstants.baseURL)/ride/\(userId)"

        if driverId != "all" {
            endpoint += "?driver_id=\(driverId)"
        }

        return request(endpoint: endpoint)
    }
}
