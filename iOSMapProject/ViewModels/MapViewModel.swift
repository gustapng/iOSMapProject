//
//  MapViewModel.swift
//  iOSMapProject
//
//  Created by Gustavo Ferreira dos Santos on 06/12/24.
//

import Foundation
import CoreLocation
import MapKit

class MapViewModel {
    // Shopper Coordinates
    let initialLocation = CLLocation(latitude: -23.523056, longitude: -46.673889)
    var raceOptions: [RaceOption]?
    var raceOptionsRoute: [Route]?
    var customerId: String?

    var coordinateRegion: MKCoordinateRegion {
        let _: CLLocationDistance = 1000
        return MKCoordinateRegion(
            center: initialLocation.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    }

    init(raceOptions: [RaceOption]? = nil, raceOptionsRoute: [Route]? = nil, customerId: String? = nil) {
        self.raceOptions = raceOptions
        self.raceOptionsRoute = raceOptionsRoute
        self.customerId = customerId
    }

    // MARK: Get Polyline(Race Route)
    func getPolylines() -> [MKPolyline] {
        guard let routes = raceOptionsRoute else { return [] }

        var polylines: [MKPolyline] = []

        for route in routes {
            for leg in route.legs {
                let coordinates = leg.polyline.decodePolyline()
                let mkPolyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
                polylines.append(mkPolyline)
            }
        }
        return polylines
    }

    func getOriginAndDestinationAnnotations() -> [MKPointAnnotation] {
        var annotations: [MKPointAnnotation] = []

        guard let routes = raceOptionsRoute else { return annotations }

        for route in routes {
            for leg in route.legs {
                let originAnnotation = MKPointAnnotation()
                originAnnotation.coordinate = CLLocationCoordinate2D(latitude: leg.startLocation.latLng.latitude,
                                                                     longitude: leg.startLocation.latLng.longitude)
                originAnnotation.title = "Ponto de Origem"
                annotations.append(originAnnotation)

                let destinationAnnotation = MKPointAnnotation()
                destinationAnnotation.coordinate = CLLocationCoordinate2D(latitude: leg.endLocation.latLng.latitude,
                                                                          longitude: leg.endLocation.latLng.longitude)
                destinationAnnotation.title = "Ponto de Destino"
                destinationAnnotation.subtitle = "Distância: \(leg.distanceMeters.formatDistanceToKM())"
                annotations.append(destinationAnnotation)
            }
        }
        return annotations
    }

    func getAnnotations() -> [MKPointAnnotation] {
        let annotation = MKPointAnnotation()
        return [annotation]
    }
}

extension Polyline {
    func decodePolyline() -> [CLLocationCoordinate2D] {
        var coordinates: [CLLocationCoordinate2D] = []
        var index = 0
        let polylineString = encodedPolyline

        var latitude = 0
        var longitude = 0

        while index < polylineString.count {
            var shift = 0
            var result = 0
            var byte: UInt8

            repeat {
                let char = polylineString[polylineString.index(polylineString.startIndex, offsetBy: index)]
                byte = UInt8(char.asciiValue! - 63)
                result |= (Int(byte) & 0x1F) << shift
                shift += 5
                index += 1
            } while byte >= 0x20

            let deltaLat = ((result & 1) == 1 ? ~(result >> 1) : (result >> 1))
            latitude += deltaLat

            shift = 0
            result = 0

            repeat {
                let char = polylineString[polylineString.index(polylineString.startIndex, offsetBy: index)]
                byte = UInt8(char.asciiValue! - 63)
                result |= (Int(byte) & 0x1F) << shift
                shift += 5
                index += 1
            } while byte >= 0x20

            let deltaLon = ((result & 1) == 1 ? ~(result >> 1) : (result >> 1))
            longitude += deltaLon

            let coordinate = CLLocationCoordinate2D(
                latitude: Double(latitude) * 1e-5,
                longitude: Double(longitude) * 1e-5
            )
            coordinates.append(coordinate)
        }
        return coordinates
    }
}
