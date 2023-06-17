//
//  FilmDescription.swift
//  diplom_project
//
//  Created by Грифон on 28.05.23.
//

import UIKit
import Swift

import SwiftyJSON
import CoreData

class FilmDescription: UIViewController {
    @IBOutlet var reloadBtn: UIButton!
    @IBOutlet var filmName: UILabel!
    @IBOutlet var poster: UIImageView!
    @IBOutlet var filmDescription: UILabel!
    @IBOutlet var filmYear: UILabel!
    @IBOutlet var filmGenres: UILabel!
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var filmGenresTitle: UILabel!
    @IBOutlet var filmYearTitle: UILabel!
    
    lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        return session
    } ()
    
    var url = URL(string:"" )
    var id: Int = 0
    var urlPoster = ""
    let api: NetworkManager  = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tuneUI()
        reloadBtn.isHidden = true
        api.getFilm(id: id)
        url = URL(string: urlPoster)
    }
   private func makeHidden() {
        if filmYear.text == "0" {
            reloadBtn.isHidden = false
            filmYearTitle.isHidden = true
            filmGenresTitle.isHidden = true
            filmYear.isHidden = true
            saveBtn.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tuneUI()
        makeHidden()
    }
    
    private func tuneUI(){
        url = URL(string: api.jsonFilm.poster ?? "")
        downloadImage()
        filmDescription.text = api.jsonFilm.description
        filmName.text = api.jsonFilm.title
        filmYear.text = "\(api.jsonFilm.year ?? 0)"
        filmGenres.text = api.jsonFilm.genres?.joined(separator: " ")
    }
    
    private func downloadImage() {
        guard let url = url else {
            return
        }
        session.downloadTask(with: url).resume()
    }
    
    @IBAction func reload(_ sender: Any) {
        tuneUI()
        if filmYear.text == "0" {
            reloadBtn.isHidden = false
        }
        else {
            reloadBtn.isHidden = true
            filmYearTitle.isHidden = false
            filmGenresTitle.isHidden = false
            filmYear.isHidden = false
            saveBtn.isHidden = false
        }
    }
    @IBAction func addToFavorite(_ sender: UIButton) {
        let film = Favorites(context: CoreDataManager.shared.context)
        film.film = filmName.text
        film.id = Int64(id)
        CoreDataManager.shared.save { error in
            guard let _ = error else {
                return
            }
        }
    }
}
extension FilmDescription: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let img = UIImage(contentsOfFile: location.path) else {
            return
        }
        DispatchQueue.main.async {
            self.poster.image = img
        }
    }
}
