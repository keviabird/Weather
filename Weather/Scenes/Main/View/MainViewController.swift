
import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var sunrise: UILabel!
    @IBOutlet weak var susnset: UILabel!
    @IBOutlet weak var visibility: UILabel!
    @IBOutlet weak var wind: UILabel!
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weatherText: UILabel!
    
    var presenter: MainPresenterInput?
    
    // TODO: cells model
    var weather: Weather?
    var forecasts: [DayForecast] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Settings".localized(), style: .plain, target: self, action: #selector(settingsButtonPressed))
        self.tableView.register(UINib.init(nibName: ForecastCell.identifier, bundle: nil), forCellReuseIdentifier: ForecastCell.identifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        presenter?.viewDidLoad()
        // Do any additional setup after loading the view.

    }
    
    @objc func settingsButtonPressed () {
        presenter?.settingsDidTapped()
    }
    
    func configureCurrent(weather: Weather) {
        sunrise.text = weather.sunrise
        susnset.text = weather.sunset
        visibility.text = weather.visibility
        wind.text = weather.wind
        weatherImage.image = UIImage(named: weather.weatherIcon)
        temperature.text = weather.temperature
        weatherText.text = weather.weatherName
    }

}

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return forecasts[section].day
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts[section].weather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ForecastCell.identifier, for: indexPath) as? ForecastCell {
            cell.configure(weather: forecasts[indexPath.section].weather[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 38
    }
}

extension MainViewController: MainPresenterOutput {
    
    func getNavigationController() -> UINavigationController? {
        return self.navigationController
    }
    
    func update(weather: Weather) {
        self.weather = weather
        self.configureCurrent(weather: weather)
    }
    
    func update(forecasts: [DayForecast]) {
        self.forecasts = forecasts
        self.tableView.reloadData()
    }
    
    func updateCity(_ city: String) {
        self.navigationItem.title = city
    }
    
    func localize() {
        self.navigationItem.rightBarButtonItem?.title = "Settings".localized()
    }
    
}
