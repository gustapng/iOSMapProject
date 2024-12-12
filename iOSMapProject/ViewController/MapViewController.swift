//
//  ItemListViewController.swift
//  iOSMapProject
//
//  Created by Gustavo Ferreira dos Santos on 06/12/24.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    // MARK: - Properties
    private let mapView = MKMapView()
    private var viewModel: MapViewModel
    private let coordinator: AppCoordinator

    // MARK: - UI Components
    let driverButton = StandardButton()
    let cancelButton = CancelButton()

    init(viewModel: MapViewModel, coordinator: AppCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewCode()
        mapView.delegate = self
        setupMapView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateViewModel(_ newViewModel: MapViewModel) {
        self.viewModel = newViewModel
        setupMapView()
        displayPolylines()
        setupButton()
    }

    // MARK: - MapView
    private func setupMapView() {
        mapView.setRegion(viewModel.coordinateRegion, animated: true)

        let annotations = viewModel.getAnnotations()
        mapView.addAnnotations(annotations)

        let originAndDestinationAnnotations = viewModel.getOriginAndDestinationAnnotations()
        mapView.addAnnotations(originAndDestinationAnnotations)

        if let firstRoute = viewModel.raceOptionsRoute?.first,
           let firstLeg = firstRoute.legs.first {
            let originCoordinate = CLLocationCoordinate2D(latitude: firstLeg.startLocation.latLng.latitude,
                                                          longitude: firstLeg.startLocation.latLng.longitude)
            let region = MKCoordinateRegion(center: originCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            mapView.setRegion(region, animated: true)
        }
    }

    private func displayPolylines() {
        mapView.removeOverlays(mapView.overlays)

        let polylines = viewModel.getPolylines()
        polylines.forEach { mapView.addOverlay($0) }
    }

    func clearMapView() {
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        driverButton.isHidden = true
        cancelButton.isHidden = true
    }

    // MARK: - DriverButton
    private func setupButton() {
        if driverButton.superview == nil {
            driverButton.configure(title: "Ver motoristas disponíveis") { [weak self] in
                self?.buttonTapped()
            }

            cancelButton.configure() { [weak self] in
                self?.clearMapView()
            }

            view.addSubview(driverButton)
            view.addSubview(cancelButton)

            driverButton.translatesAutoresizingMaskIntoConstraints = false
            cancelButton.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                driverButton.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor),
                driverButton.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -20),
                driverButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                driverButton.heightAnchor.constraint(equalToConstant: 50),
                driverButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),

                cancelButton.centerYAnchor.constraint(equalTo: driverButton.centerYAnchor),
                cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
                cancelButton.widthAnchor.constraint(equalToConstant: 50),
                cancelButton.heightAnchor.constraint(equalToConstant: 50),
            ])
        }
        driverButton.isHidden = false
        cancelButton.isHidden = false
    }

    @objc private func buttonTapped() {
        coordinator.showDriversSheet(raceOptions: viewModel.raceOptions ?? [],
                                     raceOptionsRoute: viewModel.raceOptionsRoute ?? [],
                                     customerId: viewModel.customerId ?? "")
    }
}

extension MapViewController: ViewCodeProtocol {
    func setupViewCode() {
        view.backgroundColor = .white

        navigationController?.navigationBar.adjustTitlePosition(verticalOffset: -10, color: UIColor(named: "GreenLight"))

        setupAddSubview()
        setupConstraint()
    }

    func setupAddSubview() {
        view.addSubview(mapView)
    }

    func setupConstraint() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = UIColor(named: "GreenLight")
            renderer.lineWidth = 4.0
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        let identifier = "CustomPin"

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }

        annotationView?.markerTintColor = UIColor(named: "GreenLight")
        annotationView?.glyphImage = UIImage(named: "pinIcon")

        return annotationView
    }
}
