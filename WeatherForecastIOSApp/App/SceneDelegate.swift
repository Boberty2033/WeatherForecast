//
//  SceneDelegate.swift
//  WeatherForecastIOSApp
//
//  Created by Alexander Dolgikh on 21.02.2026.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        
        let window = UIWindow(windowScene: windowScene)
        let mainVC = WeatherPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        let navController = UINavigationController(rootViewController: mainVC)
        
        window.rootViewController = navController
        self.window = window
        window.makeKeyAndVisible()
    }
}
