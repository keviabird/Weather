
import UIKit

class CurrentWeatherCell: UITableViewCell {
    
    static let identifier = "CurrentWeatherCell"
    
    @IBOutlet weak var sunrise: UILabel!
    @IBOutlet weak var susnset: UILabel!
    @IBOutlet weak var visibility: UILabel!
    @IBOutlet weak var wind: UILabel!
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weatherText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(weather: Weather) {
        sunrise.text = weather.sunrise
        susnset.text = weather.sunset
        visibility.text = weather.visibility
        wind.text = weather.wind
        weatherImage.image = UIImage(named: weather.weatherIcon)
        temperature.text = weather.temperature
        weatherText.text = weather.weatherName
    }
    
}
