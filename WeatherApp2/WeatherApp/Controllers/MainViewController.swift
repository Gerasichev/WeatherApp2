//
//  ViewController.swift
//  WeatherApp
//
//  Created by Герасичев Сергей on 04.01.2024.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    var timer = Timer()
    
    let dataBase = AppDelegate.sharedAppDelegate.weatherCoreData
    
    lazy var weatherObject: WeatherEntity = {
        let dataBase = AppDelegate.sharedAppDelegate.weatherCoreData
        let weatherEntity = WeatherEntity(context: dataBase.managedObjectContext)
        return weatherEntity
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refreshControl
    }()
    
    let cities = [
        "New York", "Los Angeles", "Chicago", "Houston", "Phoenix", "Philadelphia", "San Antonio", "San Diego", "Dallas", "San Jose",
        "Austin", "Jacksonville", "San Francisco", "Indianapolis", "Columbus", "Fort Worth", "Charlotte", "Seattle", "Denver", "El Paso",
        "Detroit", "Washington", "Boston", "Memphis", "Nashville", "Portland", "Oklahoma City", "Las Vegas", "Baltimore", "Louisville",
        "Milwaukee", "Albuquerque", "Tucson", "Fresno", "Mesa", "Sacramento", "Atlanta", "Kansas City", "Colorado Springs", "Miami",
        "Raleigh", "Omaha", "Long Beach", "Virginia Beach", "Oakland", "Minneapolis", "Tampa", "Tulsa", "Arlington", "New Orleans",
        "Wichita", "Bakersfield", "Cleveland", "Aurora", "Anaheim", "Honolulu", "Santa Ana", "Riverside", "Corpus Christi", "Lexington",
        "Stockton", "Pittsburgh", "Saint Paul", "Anchorage", "Cincinnati", "Henderson", "Greensboro", "Plano", "Newark", "Toledo",
        "Lincoln", "Orlando", "Chula Vista", "Jersey City", "Chandler", "Fort Wayne", "Buffalo", "Durham", "St. Petersburg", "Irvine",
        "Laredo", "Lubbock", "Madison", "Gilbert", "Norfolk", "Reno", "Winston-Salem", "Glendale", "Hialeah", "Garland", "Scottsdale",
        // ... Can be continued
    ]
    
    var citiesIsEnable: [String : Bool] = [:]
    
    var weatherData: [String : WeatherModel] = [:]
    
    let networkManager = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        refreshData()
        
        saveContextByTimer()
    }
    
    func setupUI() {
        // Navigation Bar + Background
        title = "Cities 🏢"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        
        // Table
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CityCell")
        
        // Refresh
        tableView.addSubview(refreshControl)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: Weather
    func fetchWeatherDetails(for city: String, completion: @escaping () -> ()) {
        Task {
            do {
                let data = try await networkManager.fetchWeatherData(for: city)
                let weatherModel = try JSONDecoder().decode(WeatherModel.self, from: data)
                weatherData[city] = weatherModel
                
                guard (citiesIsEnable[city] != true) else {
                    return completion()
                }
                
                prepareContext(with: weatherModel)
                
                //                let newWeather: WeatherEntity = NSEntityDescription.insertNewObject(forEntityName: "WeatherEntity", into: dataBase.managedObjectContext) as! WeatherEntity
                //                let newLocation: LocationEntity = NSEntityDescription.insertNewObject(forEntityName: "LocationEntity", into: dataBase.managedObjectContext) as! LocationEntity
                //                let newCurrent: CurrentEntity = NSEntityDescription.insertNewObject(forEntityName: "CurrentEntity", into: dataBase.managedObjectContext) as! CurrentEntity
                //                let newCondition: ConditionEntity = NSEntityDescription.insertNewObject(forEntityName: "ConditionEntity", into: dataBase.managedObjectContext) as! ConditionEntity
                //
                //                newLocation.location = weatherModel.location
                //                newCondition.condition = weatherModel.current.condition
                //                newCurrent.current = weatherModel.current
                //                newCurrent.toCondition = newCondition
                //                newWeather.date = Date()
                //                newWeather.toCurrent = newCurrent
                //                newWeather.toLocation = newLocation
                
                dataBase.saveContext(managedObjectContext: dataBase.managedObjectContext)
                
                citiesIsEnable[city] = true
                
                completion()
            } catch {
                print("Error fetching or decoding weather data: \(error.localizedDescription)")
                completion()
            }
        }
    }
    
    func prepareContext(with weatherModel: WeatherModel){
        let newWeather: WeatherEntity = NSEntityDescription.insertNewObject(forEntityName: "WeatherEntity", into: dataBase.managedObjectContext) as! WeatherEntity
        let newLocation: LocationEntity = NSEntityDescription.insertNewObject(forEntityName: "LocationEntity", into: dataBase.managedObjectContext) as! LocationEntity
        let newCurrent: CurrentEntity = NSEntityDescription.insertNewObject(forEntityName: "CurrentEntity", into: dataBase.managedObjectContext) as! CurrentEntity
        let newCondition: ConditionEntity = NSEntityDescription.insertNewObject(forEntityName: "ConditionEntity", into: dataBase.managedObjectContext) as! ConditionEntity
        
        newLocation.location = weatherModel.location
        newCondition.condition = weatherModel.current.condition
        newCurrent.current = weatherModel.current
        newCurrent.toCondition = newCondition
        newWeather.date = Date()
        newWeather.toCurrent = newCurrent
        newWeather.toLocation = newLocation
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc func refreshData() {
        for city in cities {
            guard (citiesIsEnable[city] != true) else {
                return
            }
            
            fetchWeatherDetails(for: city) { [weak self] in
                if (self?.weatherData[city]) != nil {
                    self?.updateUI()
                }
            }
        }
        
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
    }
}

// MARK: - TableView Delegates
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = WeatherTableViewCell(style: .default, reuseIdentifier: "WeatherCell")
        
        let city = cities[indexPath.row]
        
        if let currentWeather = weatherData[city] {
            
            let regionName = currentWeather.location.name
            let temperature = currentWeather.current.tempC
            let conditionIconURL = "https:" + currentWeather.current.condition.icon
            
            cell.regionLabel.text = regionName
            cell.temperatureLabel.text = "\(temperature)°C"
            
            if let url = URL(string: conditionIconURL) {
                Task {
                    do {
                        let (data, _) = try await URLSession.shared.data(from: url)
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                cell.conditionIconImageView.image = image
                            }
                        }
                    } catch {
                        print("Error downloading icon image: \(error.localizedDescription)")
                    }
                }
            }
        } else {
            cell.regionLabel.text = "Loading..."
            cell.temperatureLabel.text = ""
            cell.conditionIconImageView.image = nil
            if cities.count >= indexPath.row + 1 {
                refreshData()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = cities[indexPath.row]
        if let weather = weatherData[selectedCity] {
            navigationController?.pushViewController(DetailsViewController(weatherModel: weather), animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MainViewController{
    
    func saveContextByTimer() {
        timer.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: 15.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @objc func timerAction(){
        let fileManager = FileManager.default
        citiesIsEnable = [:]
        let documentsPathURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let documentsPath: String = documentsPathURL!.absoluteString
        let dataBaseFile = "\(documentsPath)\(dataBase.modelName)"+".sqlite"
        
        if fileManager.fileExists(atPath: dataBaseFile){
            do {
                try FileManager.default.removeItem(at: documentsPathURL!)
            } catch let error as NSError {
                print("Error delete WeatherEntity: \(error.localizedDescription)")
            }
            saveContextAsync()
        }
    }
    
    func saveContextAsync(){
        refreshData()
    }
    
}
