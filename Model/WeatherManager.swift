//
//  WeatherManager.swift
//  Clima
//
//  Created by administrator on 04/05/2024.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation
protocol WeatherManagerDelegate {
    func updateWeather(_ weatherManager: WeatherManager, weather: weatherModel)
    func didFailWithError(error: Error)
}
struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=71b470e7bdf63fadef56a2f4383bd91d&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
//https://api.openweathermap.org/data/2.5/weather?&appid=71b470e7bdf63fadef56a2f4383bd91d&units=metric&lat=51&lon=-0.1
    
    func performRequest(with urlString: String){
        //1. Create a URl (get and copy the url)
        if let url = URL(string: urlString) {
            //2. Ceate a URL sesssion (Open the browwser)
            let session = URLSession(configuration: .default)
            //3. Give a sesseion task (past the URL to the browwser to fetch the data)
            let task = session.dataTask(with: url) { (data, repsonse, error) in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJason(safeData) {
                        self.delegate?.updateWeather(self, weather: weather)
                    }
                }
            }
            //4. Start the task (click enter)
            task.resume()
        }
    }
    
    func parseJason(_ weatherData: Data) -> weatherModel?{
        let decoder = JSONDecoder()
        do {
            let docodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = docodedData.weather[0].id
            let name = docodedData.name
            let temp = docodedData.main.temp
            let weather = weatherModel(conditionId: id, cityName: name, temprature: temp)
            //print(weather.temprature)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
  
    
}
