//
//  APIError.swift
//  iOSMapProject
//
//  Created by Gustavo Ferreira dos Santos on 07/12/24.
//

import Foundation

struct APIError: Error, Decodable {
    let errorCode: String
    let errorDescription: String

    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case errorDescription = "error_description"
    }
}
