//
//  ViewOfFilms.swift
//  diplom_project
//
//  Created by Грифон on 27.05.23.
//

import UIKit

import SwiftyJSON

class ViewOfFilms: UIViewController {
    
    @IBOutlet var tableOfFilms: UITableView!
    @IBOutlet var reloadBtn: UIButton!
    
    let api: NetworkManager  = NetworkManager()
    var films:[FilmsData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api.getTopFilms()
        tuneUI()
    }
    
    private func tuneUI () {
        reloadBtn.isHidden = true
        let nibCell = UINib(nibName: "CustomCell", bundle: nil)
        tableOfFilms.register(nibCell, forCellReuseIdentifier: "customCell")
        tableOfFilms.dataSource = self
        tableOfFilms.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateFilms()
        tableOfFilms.reloadData()
        if films.count == 0 {
            reloadBtn.isHidden = false
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        films = []
    }
    
    private func updateFilms() {
        api.jsonTopFilms.forEach{ film in
            if film.1["nameRu"].string == nil {
                return
            }
            films.append(buildFilm(film.1))
        }
    }
    
    private func buildFilm(_ filmData: JSON) -> FilmsData {
        let film = FilmsData( title: filmData["nameRu"].string, year: filmData["year"].int, description: filmData["description"].string, poster: filmData["posterUrlPreview"].string, externalId: filmData["filmId"].int,genres: filmData["genres"].arrayValue.map {$0["genre"].stringValue}, countries: nil)
        return film
        
    }
    
    @IBAction func reloadFilms(_ sender: Any) {
        updateFilms()
        tableOfFilms.reloadData()
        if films.count == 0 {
            reloadBtn.isHidden = false
        }
        else {
            reloadBtn.isHidden = true
        }
    }
}

extension ViewOfFilms: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomCell
        cell.customCellName.text = "  \(films[indexPath.row].title!)"
        return cell
    }
}

extension ViewOfFilms: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let nVC = sb.instantiateViewController(withIdentifier: "FILM") as? FilmDescription {
            nVC.id = films[indexPath.row].externalId!
            navigationController?.pushViewController(nVC, animated: true)
        }
    }
}
