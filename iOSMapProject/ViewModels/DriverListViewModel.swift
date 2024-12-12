//
//  DriverListViewModel.swift
//  iOSMapProject
//
//  Created by Gustavo Ferreira dos Santos on 08/12/24.
//

import Foundation
import Combine

class DriversListViewModel {
    // MARK: - Properties
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var successMessage: String? = nil
    private var cancellables = Set<AnyCancellable>()
    var drivers: [RaceOption]
    var selectedDriver: RaceOption?
    var route: [Route]
    var customerId: String
    private let raceConfirmationService = RaceConfirmationService()
    private let coordinator: AppCoordinator

    init(drivers: [RaceOption], route: [Route], customerId: String, coordinator: AppCoordinator) {
        self.drivers = drivers
        self.route = route
        self.customerId = customerId
        self.coordinator = coordinator
    }
    
    // MARK: - Loading Control
    func startLoading() {
        isLoading = true
    }

    func stopLoading() {
        isLoading = false
    }

    // MARK: - Sheet Label
    var sheetLabelText: String {
        return "Toque para selecionar"
    }

    // MARK: - Button Confirm Title
    var confirmButtonTitle: String {
        return "Confirmar motorista"
    }
    
    // MARK: - Button Title
    var cancelButtonTitle: String {
        return "Cancelar corrida"
    }

    // MARK: - Claer Map View
    func clearMapView() {
        self.coordinator.clearMapView()
    }

    // MARK: - Navigate to Historic View
    func navigateToHistoric() {
        self.coordinator.navigateToHistoric()
    }

    func createRequestBody(selectedDriver: RaceOption) -> [String: Any]? {
        guard let firstLeg = route.first?.legs.first else {
            return nil
        }

        let origin = firstLeg.startLocation.latLng
        let destination = firstLeg.endLocation.latLng
        let distance = firstLeg.distanceMeters
        let duration = firstLeg.duration

        let driver = [
            "id": selectedDriver.id,
            "name": selectedDriver.name
        ] as [String : Any]

        let requestBody: [String: Any] = [
            "customer_id": customerId,
            "origin": [
                "latitude": origin.latitude,
                "longitude": origin.longitude
            ],
            "destination": [
                "latitude": destination.latitude,
                "longitude": destination.longitude
            ],
            "distance": distance,
            "duration": duration,
            "driver": driver,
            "value": selectedDriver.value
        ]

        return requestBody
    }

    // MARK: - API Request
    func confirmButtonAction() {
        guard let selectedDriver = self.selectedDriver else {
            self.errorMessage = "Por favor selecione um motorista."
            return
        }

        self.startLoading()

        guard let requestBody = createRequestBody(selectedDriver: selectedDriver) else {
            self.errorMessage = "Erro ao montar os dados da requisição."
            self.stopLoading()
            return
        }

        let origin = "\(requestBody["origin"] ?? [:])"
        let destination = "\(requestBody["destination"] ?? [:])"
        let distance = "\(requestBody["distance"] ?? "0")"
        let duration = "\(requestBody["duration"] ?? "")"
        let value = "\(requestBody["value"] ?? "0")"

        raceConfirmationService.confirmRace(
            customerId: customerId,
            origin: origin,
            destination: destination,
            distance: distance,
            duration: duration,
            driver: selectedDriver,
            value: value
        )
        .sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .failure(let error):
                self?.errorMessage = error.errorDescription
                self?.stopLoading()
            case .finished:
                self?.stopLoading()
            }
        }, receiveValue: { [weak self] response in
            self?.stopLoading()
            self?.successMessage = "Corrida confirmada!"
        })
        .store(in: &cancellables)
    }
}
