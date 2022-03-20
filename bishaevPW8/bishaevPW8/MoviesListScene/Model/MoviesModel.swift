import Foundation

class MoviesModel {
    
    let apiKey = "11fb983d4152001513cdc24307b5e271"
    private var sessions = [URLSessionDataTask]()
    var movies = [Movie]()
    weak var delegate: MoviesViewDelegate?
    
    func find(text: String) {
        guard let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            return  assertionFailure ("some problems with url")
        }
        let query = "&query=\(encodedText)"
        guard let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&language=ruRu\(query)") else
        { return  assertionFailure ("some problems with url") }
        loadMovies(page: 1, url: url)
    }
    
    func fetch(page: Int) {
        guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)&language=ruRu") else
        { return  assertionFailure ("some problems with url") }
        loadMovies(page: page, url: url)
    }
    
    func loadMovies(page: Int, url: URL) {
        
        for session in sessions {
            session.cancel()
        }
        sessions.removeAll()
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            let session = URLSession.shared.dataTask(with: URLRequest (url: url), completionHandler: { [weak self] data, _, _ in
                guard let data = data,
                      let dict = try? JSONSerialization.jsonObject (with: data, options:
                                                                    .allowFragments) as? [String: Any],
                      let results = dict["results"] as? [[String: Any]]
                else {
                    return
                }
                let movies: [Movie] = results.map { params in
                    
                    let title = params["title"] as! String
                    let imagePath = params["poster_path"] as? String
                    return Movie (
                        title: title,
                        posterPath: imagePath)
                }
                                                        
                self?.loadImagesForMovies (movies) { movies in
                    self?.movies = movies
                    self?.delegate?.update()
                }})
            session.resume()
            self?.sessions.append(session)
        }
    }
    
    private func loadImagesForMovies (_ movies: [Movie], completion: @escaping ( [Movie]) ->
                                        Void) {
        let group = DispatchGroup()
        for movie in movies {
            group.enter()
            DispatchQueue.global(qos: .background).async {
                movie.loadPoster {
                    _ in
                    group.leave()
                }
            }
        }
        group.notify (queue: .main) {
            completion (movies)
        }
    }
}
