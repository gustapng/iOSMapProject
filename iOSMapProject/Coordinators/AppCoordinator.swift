//
//  AppCoordinator.swift
//  iOSMapProject
//
//  Created by Gustavo Ferreira dos Santos on 06/12/24.
//

import UIKit
import CoreLocation

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController

    private var mapViewController: MapViewController!

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let mapViewModel = MapViewModel()
        mapViewController = MapViewController(viewModel: mapViewModel, coordinator: self)
        let mapNavigationController = UINavigationController(rootViewController: mapViewController)
        mapViewController.title = "Mapa"

        let newRaceViewModel = NewRaceViewModel()
        let newRaceViewController = NewRaceController(viewModel: newRaceViewModel, coordinator: self)
        let newRaceNavigationController = UINavigationController(rootViewController: newRaceViewController)
        newRaceViewController.title = "Corrida"

        let historicViewModel = HistoricViewModel(coordinator: self)
        let historicViewController = HistoricViewController(viewModel: historicViewModel)
        let historicNavigationController = UINavigationController(rootViewController: historicViewController)
        historicViewController.title = "Histórico"

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [mapNavigationController, newRaceNavigationController, historicNavigationController]

        let mapItem = UITabBarItem(title: "Mapa", image: UIImage(systemName: "map.fill"), tag: 0)
        let RaceItem = UITabBarItem(title: "Corrida", image: UIImage(systemName: "plus.circle"), tag: 1)
        let historicItem = UITabBarItem(title: "Histórico", image: UIImage(systemName: "note.text"), tag: 2)

        mapNavigationController.tabBarItem = mapItem
        newRaceNavigationController.tabBarItem = RaceItem
        historicNavigationController.tabBarItem = historicItem

        tabBarController.tabBar.tintColor = UIColor(named: "GreenLight")
        tabBarController.tabBar.barTintColor = .white
        tabBarController.tabBar.unselectedItemTintColor = .black
        tabBarController.tabBar.isTranslucent = false
        
        tabBarController.selectedIndex = 0
        navigationController.viewControllers = [tabBarController]
    }

    func navigateToMapView(raceOptions: [RaceOption], raceOptionsRoute: [Route], customerId: String) {
        let newViewModel = MapViewModel(raceOptions: raceOptions, raceOptionsRoute: raceOptionsRoute, customerId: customerId)
        mapViewController.updateViewModel(newViewModel)

        if let tabBarController = navigationController.viewControllers.first as? UITabBarController {
            tabBarController.selectedIndex = 0
        }
    }

    func showDriversSheet(raceOptions: [RaceOption], raceOptionsRoute: [Route], customerId: String) {
        let driverViewModel = DriversListViewModel(drivers: raceOptions, route: raceOptionsRoute, customerId: customerId, coordinator: self)
        let driverViewController = DriverListViewController(viewModel: driverViewModel)

        driverViewController.modalPresentationStyle = .pageSheet
        if let sheet = driverViewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }

        navigationController.present(driverViewController, animated: true, completion: nil)
    }

    func clearMapView() {
        mapViewController?.clearMapView()
    }

    func navigateToHistoric() {
        if let tabBarController = self.navigationController.viewControllers.first as? UITabBarController {
            tabBarController.selectedIndex = 2
        }
    }
    
    func showRideDetails(ride: Ride) {
        let detailsViewModel = RideHistoricDetailsViewModel(ride: ride)
        let detailsViewController = RideHistoricDetailsViewController(viewModel: detailsViewModel)

        detailsViewController.modalPresentationStyle = .overCurrentContext
        detailsViewController.modalTransitionStyle = .crossDissolve
        navigationController.present(detailsViewController, animated: true, completion: nil)
    }
}
