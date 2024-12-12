//
//  BaseService.swift
//  iOSMapProject
//
//  Created by Gustavo Ferreira dos Santos on 09/12/24.
//

import Combine
import Foundation
import UIKit

class BaseService {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    public func createURL(from endpoint: String) -> Result<URL, APIError> {
        guard let url = URL(string: endpoint), UIApplication.shared.canOpenURL(url) else {
            return .failure(APIError(errorCode: "invalid_url", errorDescription: "URL inválida"))
        }
        return .success(url)
    }

    public func serializeBody(_ body: [String: Any]?) -> Result<Data?, APIError> {
        guard let body = body else { return .success(nil) }

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body)
            return .success(jsonData)
        } catch {
            return .failure(APIError(errorCode: "serialization_error", errorDescription: "Erro ao serializar o corpo da requisição."))
        }
    }

    func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: [String: Any]? = nil,
        headers: [String: String] = ["Content-Type": "application/json"]
    ) -> AnyPublisher<T, APIError> {

        switch createURL(from: endpoint) {
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        case .success(let url):
            var request = URLRequest(url: url)
            request.httpMethod = method
            headers.forEach { request.addValue($1, forHTTPHeaderField: $0) }

            switch serializeBody(body) {
            case .failure(let error):
                return Fail(error: error).eraseToAnyPublisher()
            case .success(let jsonData):
                request.httpBody = jsonData
            }

            return session.dataTaskPublisher(for: request)
                .map { $0.data }
                .tryMap { data in
                    do {
                        return try JSONDecoder().decode(T.self, from: data)
                    } catch {
                        if let apiError = try? JSONDecoder().decode(APIError.self, from: data) {
                            throw apiError
                        } else {
                            throw APIError(errorCode: "parsing_error", errorDescription: "Erro ao processar a resposta.")
                        }
                    }
                }
                .mapError { error in
                    error as? APIError ?? APIError(errorCode: "unknown", errorDescription: error.localizedDescription)
                }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
    }

    func requestJSON(
        endpoint: String,
        method: String = "GET",
        body: [String: Any]? = nil,
        headers: [String: String] = ["Content-Type": "application/json"]
    ) -> AnyPublisher<[String: Any], APIError> {

        switch createURL(from: endpoint) {
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        case .success(let url):
            var request = URLRequest(url: url)
            request.httpMethod = method
            headers.forEach { request.addValue($1, forHTTPHeaderField: $0) }

            switch serializeBody(body) {
            case .failure(let error):
                return Fail(error: error).eraseToAnyPublisher()
            case .success(let jsonData):
                request.httpBody = jsonData
            }

            return session.dataTaskPublisher(for: request)
                .map { $0.data }
                .tryMap { data -> [String: Any] in
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                        throw APIError(errorCode: "parsing_error", errorDescription: "Resposta inválida.")
                    }
                    return json
                }
                .mapError { error in
                    error as? APIError ?? APIError(errorCode: "unknown", errorDescription: error.localizedDescription)
                }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
    }
}
