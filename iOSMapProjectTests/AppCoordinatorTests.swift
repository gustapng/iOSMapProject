//
//  AppCoordinatorTests.swift
//  iOSMapProjectTests
//
//  Created by Gustavo Ferreira dos Santos on 10/12/24.
//

import XCTest
@testable import iOSMapProject

final class AppCoordinatorTests: XCTestCase {
    var navigationController: UINavigationController!
    var appCoordinator: AppCoordinator!

    override func setUp() {
        super.setUp()
        navigationController = UINavigationController()
        appCoordinator = AppCoordinator(navigationController: navigationController)
    }

    override func tearDown() {
        appCoordinator = nil
        navigationController = nil
        super.tearDown()
    }

    func testStartShouldSetUpTabBarController() {
        appCoordinator.start()

        let tabBarController = navigationController.viewControllers.first as? UITabBarController

        XCTAssertNotNil(tabBarController)
        XCTAssertEqual(tabBarController?.viewControllers?.count, 3)

        let mapTab = tabBarController?.viewControllers?[0] as? UINavigationController
        let newRaceTab = tabBarController?.viewControllers?[1] as? UINavigationController
        let historicTab = tabBarController?.viewControllers?[2] as? UINavigationController

        XCTAssertNotNil(mapTab)
        XCTAssertNotNil(newRaceTab)
        XCTAssertNotNil(historicTab)
    }

    func testNavigateToHistoricTestShouldChangeTabToHistoric() {
        appCoordinator.start()

        appCoordinator.navigateToHistoric()

        let tabBarController = navigationController.viewControllers.first as? UITabBarController
        XCTAssertEqual(tabBarController?.selectedIndex, 2)
    }
}

