import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var action: UIButton!
    @IBOutlet var views: [UIView]!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onButtonTapped(_ sender: Any) {
        var colors = Set<UIColor>()
        while colors.count != views.count {
            let color = UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: .random(in: 0...1))
            colors.insert(color)
        }
        action.isEnabled = false
        UIView.animate(withDuration: 1.0) {
            for view in self.views {
                view.backgroundColor = colors.popFirst()
                view.layer.cornerRadius = .random(in: 0...5)
            }
        } completion: { _ in
            self.action.isEnabled = true
        }

    }
    
}

