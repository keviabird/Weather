
import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var presenter: SettingsPresenterInput?
    
    var language: Language?
    var unit: Units?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.viewDidLoad()
        self.navigationItem.title = "Settings".localized()
        
        self.tableView.register(UINib.init(nibName: SegmentedControlCell.identifier, bundle: nil), forCellReuseIdentifier: SegmentedControlCell.identifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        // Do any additional setup after loading the view.
    }


}

extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "UNITS".localized()
        } else {
            return "LANGUAGE".localized()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: SegmentedControlCell.identifier, for: indexPath) as? SegmentedControlCell {
                if let presenter = presenter {
                    cell.presenter = presenter
                    cell.configure(presenter.getSegmentedControlCellModel())
                }
                return cell
            }
        } else {
            let cellIdentifier = "LanguageSelector"
            var cell : UITableViewCell!
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
            }
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = (self.language ?? Language.en).getTitle().localized()
            return cell
        }
        return UITableViewCell()
    }
    

}

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            presenter?.languageDidTapped()
        }
    }

}


extension SettingsViewController: SettingsPresenterOutput {
    
    func getNavigationController() -> UINavigationController? {
        return self.navigationController
    }
    
    func setLanguage(_ language: Language) {
        self.language = language
        self.tableView.reloadSections([0,1], with: .none)
        self.navigationItem.title = "Settings".localized()
    }
    
    func setUnit(_ unit: Units) {
        self.unit = unit
        self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .none)
    }
    
}
