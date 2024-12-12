//
//  HistoricViewModel.swift
//  iOSMapProject
//
//  Created by Gustavo Ferreira dos Santos on 06/12/24.
//

import Foundation
import UIKit
import Combine

class HistoricViewModel {
    // MARK: - Properties
    @Published var races: [Ride] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    private var cancellables = Set<AnyCancellable>()
    private let raceHistoryService: RaceHistoryService
    private let coordinator: AppCoordinator

    init(raceHistoryService: RaceHistoryService = RaceHistoryService(), coordinator: AppCoordinator) {
        self.raceHistoryService = raceHistoryService
        self.coordinator = coordinator
    }

    // MARK: - Loading Control
    func startLoading() {
        isLoading = true
    }

    func stopLoading() {
        isLoading = false
    }

    // MARK: - Info UILabel
    var infoLabelText: String = "*Arraste o item do histórico para a esquerda para ver os seus detalhes"

    // MARK: - User UITextField
    var inputUserText: String = ""

    func updateInputUserText(_ text: String) {
        inputUserText = text
    }

    func getUserIDIcon() -> UIImage? {
        return UIImage(systemName: "person.circle")
    }

    // MARK: - Driver UIPicker
    var inputDriverText: String = ""

    func updateDriverText(_ text: String) {
        inputDriverText = text
    }

    func getCarIcon() -> UIImage? {
        return UIImage(systemName: "car.circle")
    }

    var options: [String] = ["Motorista 1 (ID 1)", "Motorista 2 (ID 2)", "Motorista 3 (ID 3)", "Todos"]

    private(set) var selectedOption: String = ""

    func updateSelectedOption(_ option: String) {
        if option == "Todos" {
            selectedOption = "all"
        } else if let id = option.components(separatedBy: "ID ").last?.dropLast() {
            selectedOption = String(id)
        }
    }

    // MARK: - Validate Fields
    func validateFields() -> Bool {
        if inputUserText.isEmpty || selectedOption.isEmpty {
            errorMessage = "Por favor, preencha todos os campos."
            return false
        }
        return true
    }

    // MARK: - Button Title
    var filterButtonTitle: String {
        return "Filtrar"
    }

    func filterButtonAction() -> String? {
        if !validateFields() {
            return errorMessage
        }

        fetchRaces(userId: inputUserText, driverId: selectedOption)
        return nil
    }

    // MARK: - Open Modal With Ride Details
    func didTapDetails(ride: Ride) {
        coordinator.showRideDetails(ride: ride)
    }

    // MARK: - API Request
    func fetchRaces(userId: String, driverId: String) {
        let trimmedUserId = userId.trimmingCharacters(in: .whitespacesAndNewlines)

        startLoading()
        errorMessage = nil

        raceHistoryService.fetchRacesHistory(userId: trimmedUserId, driverId: driverId)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let apiError):
                    self?.races = []
                    self?.errorMessage = apiError.errorDescription
                    self?.stopLoading()
                case .finished:
                    self?.stopLoading()
                }
            } receiveValue: { customerRides in
                self.races = customerRides.rides
                self.stopLoading()
            }
            .store(in: &cancellables)
    }
}
