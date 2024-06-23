//
//  WeatherData.swift
//  Clima
//
//  Created by administrator on 05/05/2024.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double

}

struct Weather: Codable {
    let description: String
    let id: Int
}
