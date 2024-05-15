//
//  ViewController.swift
//  NoStoryTest
//
//  Created by Smagul Negmatov on 27.04.2024.
//

import UIKit

class ViewController: UIViewController {
    lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 500
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "identifier")
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
        return tableView
    }()
    var dataSource:[MovieTitle] = Array(repeating: MovieTitle(title: "Uncharted", imageMovie: UIImage(named: "movie")), count: 10)
    
    var movieData:[Result] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        let topTableViewConstraint = tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let bottomTableViewConstraint = tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        let leftTableViewConstraint = tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        let rightTableViewConstraint = tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        topTableViewConstraint.isActive = true
        bottomTableViewConstraint.isActive = true
        leftTableViewConstraint.isActive = true
        rightTableViewConstraint.isActive = true
        
        apiRequest()
    }
    
    
    func apiRequest() {
        let session = URLSession(configuration: .default)
        lazy var urlComponent:URLComponents = {
            var component = URLComponents()
            component.scheme = "https"
            component.host  = "api.themoviedb.org"
            component.path = "/3/movie/upcoming"
            component.queryItems = [
                URLQueryItem(name: "api_key", value: "d351d913d674bd98da28dea154905f25")
            ]
            return component
        }()
        guard let requestUrl = urlComponent.url else {return}
        let task = session.dataTask(with: requestUrl) {
            data,response, error in
            guard let data = data else {return}
            if let movie = try? JSONDecoder().decode(Movie.self, from: data)
            {
                DispatchQueue.main.async {
                    self.movieData = movie.results
                    self.tableView.reloadData()
                }
            }
        }
        task.resume()
    }

}
extension ViewController:UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
//        let movie = dataSource[indexPath.row]
        let title = movieData[indexPath.row].title
        let urlImageString = "https://image.tmdb.org/t/p/w500" + movieData[indexPath.row].posterPath
        if  let url = URL(string: urlImageString) {
            DispatchQueue.global(qos: .userInitiated).async {
                if let data = try? Data(contentsOf: url)
                {
                    DispatchQueue.main.async {
                        let movie = MovieTitle(title: title, imageMovie: UIImage(data: data))
                        cell.conf(movie: movie)
                    }
                }
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieId = movieData[indexPath.row].id
        let movieDetailViewController = MovieDetailViewController()
        movieDetailViewController.movieId = movieId
        self.navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
    
}
