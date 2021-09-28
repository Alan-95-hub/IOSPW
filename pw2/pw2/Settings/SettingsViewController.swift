import Foundation
import UIKit
import CoreLocation

class SettingsViewController: UIViewController {
    
    let manager = CLLocationManager()
    
    let switcher = UISwitch()
    
    let sliderRed = UISlider()
    let sliderGreen = UISlider()
    let sliderBlue = UISlider()
    
    let coordLbl = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.requestWhenInUseAuthorization()
        configure()
    }
}

// UI
extension SettingsViewController {
    func configure() {
        navigationItem.title = "Настройки"
        view.backgroundColor = .white
        switcher.addTarget(self, action: #selector(toggleSwitcher), for: .valueChanged)
        sliderRed.addTarget(self, action: #selector(moveSlider), for: .valueChanged)
        sliderGreen.addTarget(self, action: #selector(moveSlider), for: .valueChanged)
        sliderBlue.addTarget(self, action: #selector(moveSlider), for: .valueChanged)
        
        [sliderRed, sliderGreen, sliderBlue].forEach( { $0.maximumValue = 1.0; $0.value = 1.0 } )
        
        coordLbl.text = ""
        coordLbl.textColor = .black
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        stackView.addArrangedSubview(makeLabel(title: "Turn on Location?"))
        stackView.addArrangedSubview(switcher)
        
        stackView.addArrangedSubview(makeLabel(title: "RED"))
        stackView.addArrangedSubview(sliderRed)
        
        stackView.addArrangedSubview(makeLabel(title: "GREEN"))
        stackView.addArrangedSubview(sliderGreen)
        
        stackView.addArrangedSubview(makeLabel(title: "BLUE"))
        stackView.addArrangedSubview(sliderBlue)
        
        stackView.addArrangedSubview(coordLbl)
        view.addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 64).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -128).isActive = true
    }
    
    func makeLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = .black
        return label
    }
}

// Logic
extension SettingsViewController {
    @objc func toggleSwitcher() {
        if switcher.isOn {
            if CLLocationManager.locationServicesEnabled() {
                manager.delegate = self
                manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                manager.startUpdatingLocation()
            } else {
                switcher.setOn(false, animated: true)
            }
        } else {
            manager.stopUpdatingLocation()
            coordLbl.text = ""
        }
    }
    
    @objc func moveSlider() {
        view.backgroundColor = UIColor(red: CGFloat(sliderRed.value),
                                       green: CGFloat(sliderGreen.value),
                                       blue: CGFloat(sliderBlue.value),
                                       alpha: 1.0)
    }
}

extension SettingsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coord = manager.location?.coordinate else { return }
        
        coordLbl.text = "lat: \(coord.latitude), lon: \(coord.longitude)"
    }
}
