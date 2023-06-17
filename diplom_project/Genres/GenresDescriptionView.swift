//
//  GenresDescriptionView.swift
//  diplom_project
//
//  Created by Грифон on 27.05.23.
//

import Foundation
import UIKit

import SwiftyJSON

class GenresDescriptionView: UIViewController {
    @IBOutlet var genresDescription: UILabel!
    @IBOutlet var reloadBtn: UIButton!
    @IBOutlet var topInGenre: UITableView!
    
    var genre: Int = 1
    var info = ""
    let api: NetworkManager  = NetworkManager()
    var films:[FilmsData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadBtn.isHidden = true
        genresDescription.text = info
        api.getFilmsWithGenre(genre:genre)
        tuneUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateFilms()
        self.topInGenre.reloadData()
        if films.count == 0 {
            reloadBtn.isHidden = false
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        films = []
    }
    
    private func tuneUI () {
        reloadBtn.isHidden = true
        let nibCell = UINib(nibName: "CustomCell", bundle: nil)
        topInGenre.register(nibCell, forCellReuseIdentifier: "customCell")
        topInGenre.dataSource = self
        topInGenre.delegate = self
    }
    private func updateFilms() {
        api.jsonFilmsByGenres.forEach{ film in
            if film.1["nameRu"].string == nil {
                return
            }
            films.append(buildFilm(film.1))
        }
    }
    
    private func buildFilm(_ filmData: JSON) -> FilmsData {
        let film = FilmsData( title: filmData["nameRu"].string, year: filmData["year"].int, description: nil, poster: filmData["posterUrl"].string, externalId: filmData["kinopoiskId"].int,genres: filmData["genres"].arrayValue.map {$0["genre"].stringValue}, countries: nil)
        return film
        
    }
    
    @IBAction func reloadFilms(_ sender: Any) {
        updateFilms()
        topInGenre.reloadData()
        if films.count == 0 {
            reloadBtn.isHidden = false
        }
        else {
            reloadBtn.isHidden = true
        }
    }
}

extension GenresDescriptionView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomCell
        cell.customCellName.text = films[indexPath.row].title
        return cell
    }
}
extension GenresDescriptionView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let nVC = sb.instantiateViewController(withIdentifier: "FILM") as? FilmDescription {
            nVC.id = films[indexPath.row].externalId!
            navigationController?.pushViewController(nVC, animated: true)
        }
    }
}

