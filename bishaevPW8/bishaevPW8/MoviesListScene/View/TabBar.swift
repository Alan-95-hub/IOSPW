import UIKit
class TabBar: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabOne =  UINavigationController(rootViewController: MoviesViewController(isSearch: false))
        tabOne.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        
        let tabTwo = UINavigationController(rootViewController: MoviesViewController(isSearch: true))
        tabTwo.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        
        self.viewControllers = [tabOne, tabTwo]
    }
}
