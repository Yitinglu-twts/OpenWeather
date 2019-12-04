//
//  WeatherData.swift
//  Clima
//
//  Created by Yi Ting Lu on 2019/11/29.
//  Copyright © 2019 App Brewery. All rights reserved.
//  Practice swift project by Yiting 2019/11/30


import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather] //because in API, weahther holds array
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}
