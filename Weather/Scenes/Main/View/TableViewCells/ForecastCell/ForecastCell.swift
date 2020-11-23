
import UIKit

class ForecastCell: UITableViewCell {
    
    static let identifier = "ForecastCell"
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var time: UILabel!
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
        time.text = weather.time
        weatherImage.image = UIImage(named: weather.weatherIcon)
        weatherText.text = weather.weatherName
    }
    
}
