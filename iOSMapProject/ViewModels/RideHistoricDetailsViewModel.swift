//
//  RideHistoricDetailsViewModel.swift
//  iOSMapProject
//
//  Created by Gustavo Ferreira dos Santos on 11/12/24.
//

class RideHistoricDetailsViewModel {
    // MARK: - Properties
    let ride: Ride

    init(ride: Ride) {
        self.ride = ride
    }

    // MARK: - Origin Value
    var origin: String {
        return "Origem: \(ride.origin)"
    }

    // MARK: - Destination Value
    var destination: String {
        return "Destino: \(ride.destination)"
    }

    // MARK: - Distance Value
    var distance: String {
        return "Distância: \(ride.distance.formatDistance()) km"
    }

    // MARK: - Duration Value
    var duration: String {
        return "Duração: \(ride.duration.formatTimeToMin()) min"
    }
}
