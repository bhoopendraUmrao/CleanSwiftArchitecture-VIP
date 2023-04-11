//
//  AppDelegate.swift
//  Itunes
//
//  Created by bhoopendra.umrao on 30/08/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initialize()
        return true
    }
}

// MARK: - Initialize
extension AppDelegate {
    private func initialize() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = SearchCriteriaViewController()
        let navigation = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }
}
