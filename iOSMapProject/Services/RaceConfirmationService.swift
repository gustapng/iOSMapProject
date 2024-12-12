//
//  RaceConfirmationService.swift
//  iOSMapProject
//
//  Created by Gustavo Ferreira dos Santos on 08/12/24.
//

import Foundation
import Combine

class RaceConfirmationService: BaseService {
    func confirmRace(customerId: String,
                     origin: String,
                     destination: String,
                     distance: String,
                     duration: String,
                     driver: RaceOption,
                     value: String) -> AnyPublisher<[String: Any], APIError> {

        let body: [String: Any] = [
            "customer_id": customerId,
            "origin": origin,
            "destination": destination,
            "distance": distance,
            "duration": duration,
            "driver": ["id": driver.id, "name": driver.name],
            "value": value
        ]

        let endpoint = "\(APIConstants.baseURL)/ride/confirm"

        return requestJSON(endpoint: endpoint, method: "PATCH", body: body)
    }
}
