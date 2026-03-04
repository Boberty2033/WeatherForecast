//
//  AppDelegate.swift
//  WeatherForecast
//
//  Created by Alexander Dolgikh on 21.01.2026.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    // Точка входа в приложение
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Настройка глобального вида (Appearance) если необходимо
        return true
    }

    // Маркировка жизненного цикла сессий
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
