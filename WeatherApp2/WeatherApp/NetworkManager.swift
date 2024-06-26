//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Герасичев Сергей on 04.01.2024.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private init() { }
    
    // MARK: Configurations
    let apiKey = "5c799014d49c42eea9e115231240601"
    let baseUrl = "https://api.weatherapi.com/v1"
    
    // MARK: Methods
    func fetchData(from url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
    
    func fetchWeatherData(for city: String) async throws -> Data {
        guard let url = URL(string: "\(baseUrl)/current.json?key=\(apiKey)&q=\(city)") else { throw NetworkManagerErrors.wrongUrl }
        return try await fetchData(from: url)
    }
    
    func fetchForecastData(for city: String) async throws -> Data {
        guard let url = URL(string: "\(baseUrl)/forecast.json?key=\(apiKey)&q=\(city)&days=3&aqi=no&alerts=no") else { throw NetworkManagerErrors.wrongUrl }
        return try await fetchData(from: url)
    }
}

enum NetworkManagerErrors: Error {
    case wrongUrl
}
