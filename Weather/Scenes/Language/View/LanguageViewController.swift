
import UIKit

class LanguageViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var presenter: LanguagePresenterInput?
    var language: Language?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        self.navigationItem.title = "Select language".localized()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        // Do any additional setup after loading the view.
    }

}

extension LanguageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Language.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "LanguageSelector"
        var cell : UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        cell.accessoryType = (self.language == Language.allCases[indexPath.row]) ? .checkmark : .none
        cell.textLabel?.text = Language.allCases[indexPath.row].getTitle().localized()
        return cell
    }
    

}

extension LanguageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.languageSelected(Language.allCases[indexPath.row])
    }

}



extension LanguageViewController: LanguagePresenterOutput {
    func getNavigationController() -> UINavigationController? {
        return self.navigationController
    }
    
    func localize() {
        self.navigationItem.title = "Select language".localized()
    }
    
    func setLanguage(_ language: Language) {
        self.language = language
        self.tableView.reloadData()
    }
    
}
