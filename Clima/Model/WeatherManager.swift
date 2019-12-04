//
//  WeatherManager.swift
//  Clima
//
//  Created by Yi Ting Lu on 2019/11/26.
//  Copyright © 2019 App Brewery. All rights reserved.
//  Practice swift project by Yiting 2019/11/30


import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManagaer: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let webURL = "https://api.openweathermap.org/data/2.5/weather?APPID=3670d740906965ffc1bbb7f0c012ca49&units=metric"
    
    var delegate: WeatherManagerDelegate?

    
    func fetchWeather (cityName: String) {
        let urlString = "\(webURL)&q=\(cityName)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func fetchWeather (_ lat: CLLocationDegrees, _ lon: CLLocationDegrees) {
        let urlString = "\(webURL)&lat=\(lat)&lon=\(lon)"
        print(urlString)

        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        //1. Create URL
        if let url = URL(string: urlString) {
            
            //2. Create URLSession
            let session = URLSession(configuration: .default)
    
            //3. Give URLSession a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                //want to check what data we got
                if let safeData = data {
                    if let weather = self.parseJSON(safeData){
                        // send it back to view contronller
                        self.delegate?.didUpdateWeather(self, weather: weather)
                          }
                      
                }
            }
            //4. Start the task
            task.resume()
            
        }
        
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(WeatherData.self, from: weatherData) //self means the datatype
            let id = decodeData.weather[0].id
            let name = decodeData.name
            let temp = decodeData.main.temp
            let weather = WeatherModel(conditionId: id, cityName: name, temp: temp)

           
            
            return weather
            
        } catch {
            
            self.delegate?.didFailWithError(error: error)
            
            return nil
        }
    }

    
  
}


