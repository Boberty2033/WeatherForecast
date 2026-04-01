//
//  CoreDataManager.swift
//  WeatherForecastIOSApp
//
//  Created by Alexander Dolgikh on 01.04.2026.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WeatherBase")
        container.loadPersistentStores { _, error in
            if let error = error { fatalError("Ошибка Core Data: \(error)") }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveWeather(city: String, data: Data) {
        let fetchRequest: NSFetchRequest<CityEntity> = CityEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", city)

        do {
            let results = try context.fetch(fetchRequest)
            if let existingCity = results.first {
                existingCity.weatherJSON = data
                existingCity.lastUpdate = Date()
                try context.save()
            }
        } catch {
            print("Ошибка обновления кэша: \(error)")
        }
    }

    func getCachedWeather(for city: String) -> Data? {
        let fetchRequest: NSFetchRequest<CityEntity> = CityEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", city)
        
        let results = try? context.fetch(fetchRequest)
        return results?.first?.weatherJSON
    }

    func fetchSavedCityNames() -> [String] {
        let fetchRequest: NSFetchRequest<CityEntity> = CityEntity.fetchRequest()
        let results = try? context.fetch(fetchRequest)
        let names = results?.compactMap { $0.name } ?? []
        return names.isEmpty ? ["Moscow"] : names
    }
    
    func deleteCity(name: String) {
        let fetchRequest: NSFetchRequest<CityEntity> = CityEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)

        do {
            let results = try context.fetch(fetchRequest)
            if let cityToDelete = results.first {
                context.delete(cityToDelete)
                try context.save()
                print("Город \(name) удален из Core Data")
            }
        } catch {
            print("Ошибка удаления: \(error)")
        }
    }
    
    func ensureCityExists(name: String) {
        let fetchRequest: NSFetchRequest<CityEntity> = CityEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)

        do {
            let results = try context.fetch(fetchRequest)
            if results.isEmpty {
                let newCity = CityEntity(context: context)
                newCity.name = name
                newCity.lastUpdate = Date()
                try context.save()
                print("Город \(name) создан в базе")
            }
        } catch {
            print("Ошибка проверки города: \(error)")
        }
    }
}
