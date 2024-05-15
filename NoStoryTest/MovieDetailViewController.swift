//
//  MovieDetailViewController.swift
//  NoStoryTest
//
//  Created by Baurzhan Kuanyshbayev on 15.05.2024.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var movieId = 0
    let apiKey = "d351d913d674bd98da28dea154905f25"
    let urlImageString = "https://image.tmdb.org/t/p/w500"
    var movieData:MovieDetail?
    
    lazy var scrollMovieDetail:UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = true
        return scroll
    }()
    
    lazy var movieImage:UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var movieLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        return label
    }()
    
    lazy var releaseDateLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textAlignment = .left
        return label
    }()
    
    lazy var genreColletionView:UICollectionView = {
       let collection = UICollectionView()
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "Movie"
        apiRequest()
        setupLayout()
        
    }
    
    func apiRequest() {
        let session = URLSession(configuration: .default)
        lazy var urlComponent:URLComponents = {
            var component = URLComponents()
            component.scheme = "https"
            component.host  = "api.themoviedb.org"
            component.path = "/3/movie/\(movieId)"
            component.queryItems = [
                URLQueryItem(name: "api_key", value: "d351d913d674bd98da28dea154905f25")
            ]
            return component
        }()
        guard let requestUrl = urlComponent.url else {return}
        let task = session.dataTask(with: requestUrl) {
            data,response, error in
            guard let data = data else {return}
            if let movie = try? JSONDecoder().decode(MovieDetail.self, from: data)
            {
                DispatchQueue.main.async {
                    self.movieData = movie
                }
            }
        }
        task.resume()
    }
    
    func setupLayout() {
        view.addSubview(scrollMovieDetail)
        scrollMovieDetail.addSubview(movieImage)
        scrollMovieDetail.addSubview(movieLabel)
        lazy var stackView:UIStackView = {
            let stack = UIStackView()
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.axis = .vertical
            return stack
        }()
        scrollMovieDetail.addSubview(stackView)
        stackView.addSubview(releaseDateLabel)
        stackView.addSubview(genreColletionView)
        NSLayoutConstraint.activate([
            scrollMovieDetail.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollMovieDetail.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollMovieDetail.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollMovieDetail.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension MovieDetailViewController:UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieData?.genres.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        return cell
    }
}
