
import UIKit

protocol MoviesViewDelegate: AnyObject {
    func update()
}

class MoviesViewController: UIViewController, MoviesViewDelegate, UISearchBarDelegate {
    private let tableView = UITableView()
    private var page = 1
    private var movies = [Movie]()
    private let model: MoviesModel
    private let isSearch: Bool
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.placeholder = "Поиск"
        searchBar.delegate = self
        return searchBar
    }()
    
    init(isSearch: Bool) {
        self.isSearch = isSearch
        model = MoviesModel()
        super.init(nibName: nil, bundle: nil)
        model.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        if !isSearch {
            model.fetch(page: page)
        }
        
        configureUI()
    }
    
    private func configureUI() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MovieView.self, forCellReuseIdentifier: MovieView.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.reloadData()
        if isSearch {
            addSearchBar()
        }
    }
    
    func addSearchBar() {
        navigationItem.titleView = searchBar
    }
    
    func update() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            model.find(text: searchText)
        }
    }
}

extension MoviesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieView.identifier, for: indexPath) as? MovieView else { return UITableViewCell() }
        cell.configure(movie: model.movies[indexPath.row])
        
        if !isSearch && indexPath.row == model.movies.count - 1 {
            page += 1
            model.fetch(page: page)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 256.0
    }
}
