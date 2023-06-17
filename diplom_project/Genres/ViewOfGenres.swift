//
//  ViewOfGenres.swift
//  diplom_project
//
//  Created by Грифон on 27.05.23.
//

import UIKit

import SwiftyJSON
import Alamofire

class ViewOfGenres: UIViewController {
    @IBOutlet var reloadBtn: UIButton!
    @IBOutlet public var tableOfGenres: UITableView!
    
    let data = GenresTableData()
    let api: NetworkManager  = NetworkManager()
    var genresData = GenresTableData()
    var genres:[GenresData] = [] {
        didSet{
            tableOfGenres.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadBtn.isHidden = true
        api.getGenres()
        tuneUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateGenres()
        tableOfGenres.reloadData()
        if genres.count == 0 {
            reloadBtn.isHidden = false
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        genres = []
    }
    
    private func updateGenres() {
        api.jsonGenres.forEach{ genre in
            if genre.1["genre"] == "" {
                return
            }
            genres.append(buildGenre(genre.1))
        }
    }
    
    private func buildGenre(_ genreData: JSON) -> GenresData {
        let genre = GenresData( id: genreData["id"].int , genre: genreData["genre"].string)
        return genre
    }
    
    private func tuneUI () {
        let nibCell = UINib(nibName: "CustomCell", bundle: nil)
        tableOfGenres.register(nibCell, forCellReuseIdentifier: "customCell")
        tableOfGenres.dataSource = self
        tableOfGenres.delegate = self
    }
    
    @IBAction func reloadGenres(_ sender: Any) {
        updateGenres()
        tableOfGenres.reloadData()
        if genres.count == 0 {
            reloadBtn.isHidden = false
        }
        else {
            reloadBtn.isHidden = true
        }
    }
}

extension ViewOfGenres: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomCell
        cell.customCellName.text = "  \(genres[indexPath.row].genre!)"
        return cell
    }
}

extension ViewOfGenres: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let nVC = sb.instantiateViewController(withIdentifier: "GENRES") as? GenresDescriptionView {
            nVC.info = genresData.title(for: genres[indexPath.row].id!)
            nVC.genre = genres[indexPath.row].id!
            navigationController?.pushViewController(nVC, animated: true)
        }
    }
}
