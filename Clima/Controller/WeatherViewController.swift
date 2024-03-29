//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//  Practice swift project by Yiting 2019/11/30


import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        locationManager.delegate = self

        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        
        searchTextField.delegate = self
        // Keyword here what this line of code is saying is the text field should report back to our view controller.
    }

   
    @IBAction func currentLocation(_ sender: UIButton) {
        
        locationManager.requestLocation()

        
    }
    
   
}

//MARK: - UITextFieldDelegate


extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
           searchTextField.endEditing(true)
           print(searchTextField.text!)
       }
       
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           searchTextField.endEditing(true)
           print(searchTextField.text!)
           return true
       }
       
       func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
           if textField.text != ""  {
               return true
           } else {
               
               textField.placeholder = "Type Somthing"
               return false
           }
       }
       
       func textFieldDidEndEditing(_ textField: UITextField) {
           
           if let city = searchTextField.text {
               weatherManager.fetchWeather(cityName: city)
           }
           
           searchTextField.text = ""
       }
    
    
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate{
    
    func didUpdateWeather(_ weatherManagaer: WeatherManager, weather: WeatherModel) {
          
           DispatchQueue.main.async {
               self.temperatureLabel.text = weather.tempString
               self.conditionImageView.image = UIImage(systemName: weather.conditonName)
               self.cityLabel.text = weather.cityName
           }
       }
       
       func didFailWithError(error: Error) {
           print(error)
       }
       
}

//MARK: - LocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.last {
         
            locationManager.stopUpdatingLocation() // once found a location, stop updating
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            print(lat,lon)
            
            weatherManager.fetchWeather(lat,lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
