//
//  SceneDelegate.swift
//  WeatherForecast
//
//  Created by Alexander Dolgikh on 21.01.2026.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Программная настройка главного экрана приложения
        let window = UIWindow(windowScene: windowScene)
        let mainVC = WeatherViewController()
        let navController = UINavigationController(rootViewController: mainVC)
        
        window.rootViewController = navController
        self.window = window
        window.makeKeyAndVisible()
    }
}
