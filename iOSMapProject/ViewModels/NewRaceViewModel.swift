//
//  NewRaceViewModel.swift
//  iOSMapProject
//
//  Created by Gustavo Ferreira dos Santos on 06/12/24.
//

import Foundation
import UIKit
import Combine

class NewRaceViewModel {
    // MARK: - Properties
    @Published var customerId: String?
    @Published var raceOptions: [RaceOption] = []
    @Published var raceOptionsRoute: [Route] = []
    @Published var isSuccess: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var inputOriginText: String = ""
    @Published var inputUserText: String = ""
    @Published var inputDestinationText: String = ""
    private var cancellables = Set<AnyCancellable>()
    private let service: NewRaceService

    init(service: NewRaceService = NewRaceService()) {
        self.service = service
    }

    // MARK: - Loading Control
    func startLoading() {
        isLoading = true
    }

    func stopLoading() {
        isLoading = false
    }

    // MARK: - User UITextField
    func updateInputUserText(_ text: String) {
        inputUserText = text
    }

    func getUserIDIcon() -> UIImage? {
        return UIImage(systemName: "person.circle")
    }

    // MARK: - Origin UITextField
    func updateInputOriginText(_ text: String) {
        inputOriginText = text
    }

    func getOriginIcon() -> UIImage? {
        return UIImage(systemName: "location.circle")
    }

    // MARK: - Destination UITextField
    func updateInputDestinationText(_ text: String) {
        inputDestinationText = text
    }

    func getDestionationIcon() -> UIImage? {
        return UIImage(systemName: "location.circle")
    }

    // MARK: - Validate Fields
    func validateFields() -> Bool {
        if inputUserText.isEmpty || inputOriginText.isEmpty || inputDestinationText.isEmpty {
            errorMessage = "Por favor, preencha todos os campos."
            return false
        }
        return true
    }

    func clearAllInputs() {
        inputUserText = ""
        inputOriginText = ""
        inputDestinationText = ""
    }

    // MARK: - API Request
    func fetchRacesOptions(customerId: String, origin: String, destination: String) {
        let trimmedCustomerId = customerId.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedOrigin = origin.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDestination = destination.trimmingCharacters(in: .whitespacesAndNewlines)

        startLoading()
        errorMessage = nil

        service.fetchRacesOptions(customerId: trimmedCustomerId, origin: trimmedOrigin, destination: trimmedDestination)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.errorDescription
                    self?.isSuccess = false
                    self?.stopLoading()
                case .finished:
                    self?.isSuccess = true
                    self?.stopLoading()
                }
            } receiveValue: { [weak self] response in
                if self?.isResponseInvalid(response) == true {
                    self?.errorMessage = "Não encontramos informações para essa rota. Verifique os endereços e tente novamente."
                    self?.isSuccess = false
                } else {
                    self?.clearAllInputs()
                    self?.customerId = customerId
                    self?.raceOptions = response.options
                    self?.raceOptionsRoute = response.routeResponse.routes ?? []
                    self?.isSuccess = true
                }
                self?.stopLoading()
            }
            .store(in: &cancellables)
   }
    
    private func isResponseInvalid(_ response: RaceOptionsResponse) -> Bool {
        return (response.origin.latitude == 0.0 && response.origin.longitude == 0.0) ||
               (response.destination.latitude == 0.0 && response.destination.longitude == 0.0) ||
               response.options.isEmpty ||
               response.distance == 0 ||
               response.duration == 0
    }
}
