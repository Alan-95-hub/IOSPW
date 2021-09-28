import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    func configure() {
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear.circle"), style: .plain, target: self, action: #selector(settingsButtonPressed))
        navigationItem.title = "Главная"
    }
    
    @objc func settingsButtonPressed() {
        self.show(SettingsViewController(), sender: nil)
    }
}

