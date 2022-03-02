//
//  MainTabBarController.swift
//  Country Reference
//
//  Created by Kenan Alizadeh on 01.03.22.
//

import UIKit

final class MainTabBarController: UITabBarController {
    private lazy var regionsListNavigationController: UINavigationController = {
        let vc = RegionListViewController()

        let navC = UINavigationController(rootViewController: vc)
        navC.tabBarItem.title = "Regions"
        navC.tabBarItem.image = UIImage(systemName: "globe.europe.africa")

        return navC
    }()

    private lazy var countrySearchNavigationController: UINavigationController = {
        let vc = CountrySearchViewController()

        let navC = UINavigationController(rootViewController: vc)
        navC.tabBarItem.title = "Search"
        navC.tabBarItem.image = UIImage(systemName: "magnifyingglass.circle")

        return navC
    }()
}

// MARK: - Lifecycle
extension MainTabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }
}

// MARK: - UI EXT
private extension MainTabBarController {
    func setupUI() {
        self.view.backgroundColor = .systemBackground

        self.viewControllers = [
            self.regionsListNavigationController,
            self.countrySearchNavigationController
        ]
    }
}
