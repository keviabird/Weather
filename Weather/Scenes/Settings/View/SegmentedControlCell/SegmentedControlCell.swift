
import UIKit

class SegmentedControlCell: UITableViewCell {
    
    static let identifier = "SegmentedControlCell"
    var presenter: SettingsPresenterInput? 
    
    var model: SegmentedControlCellModel?
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.segmentedControl.oldstylish()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func itemSelected() {
        presenter?.unitSelected((model?.values[segmentedControl.selectedSegmentIndex]) ?? Units.metric)
    }
    
    func configure(_ model: SegmentedControlCellModel) {
        self.model = model
        segmentedControl.removeAllSegments()
        for (number, title) in model.titles.enumerated() {
            segmentedControl.insertSegment(withTitle: title, at: number, animated: false)
        }
        segmentedControl.addTarget(self, action: #selector(itemSelected), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = model.selected
    }
    
    
    
}
