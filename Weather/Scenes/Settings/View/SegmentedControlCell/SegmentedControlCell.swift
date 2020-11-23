
import UIKit

class SegmentedControlCell: UITableViewCell {
    
    static let identifier = "SegmentedControlCell"
    var presenter: SettingsPresenterInput? {
        didSet {
            model = presenter?.getSegmentedControlCellModel()
            if let model = model {
                segmentedControl.removeAllSegments()
                for (number, title) in model.titles.enumerated() {
                    segmentedControl.insertSegment(withTitle: title, at: number, animated: false)
                }
                segmentedControl.addTarget(self, action: #selector(itemSelected), for: .valueChanged)
                segmentedControl.selectedSegmentIndex = model.selected
            }
        }
    }
    
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
    
    
    
}
