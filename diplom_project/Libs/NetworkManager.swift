//
//  NetworkManager.swift
//  diplom_project
//
//  Created by Грифон on 27.05.23.
//

import Foundation

import SwiftyJSON
import Alamofire

class NetworkManager {
    
    private let host:String = "https://kinopoiskapiunofficial.tech"
    private let pathes = ["films": "/api/v2.2/films","genres": "/api/v2.2/films/filters","top": "/api/v2.2/films/top","film":"/api/v2.2/films/"]
    private let accept = "application/json"
    private let token = "94f63cd2-9859-4960-98b6-bbfe57b67ac0"
    
    var jsonFilm:FilmsData = FilmsData(title: nil, year: nil, description: nil, poster: nil, externalId: nil, genres: nil, countries: nil)
    var jsonTopFilms: JSON = ""
    var jsonFilmsByGenres: JSON = ""
    var jsonGenres: JSON = ""
    
    public func getFilmsWithGenre(genre: Int) -> () {
        let url = getUrl(key: "films")
        let headers: HTTPHeaders = [accept: accept, "X-API-KEY": token]
        AF.request(url + "?genres=\(genre)", method: .get, headers: headers).responseData { response in
            guard let data = response.data else {
                return
            }
            DispatchQueue.main.async {
                self.jsonFilmsByGenres = JSON(data)["items"]
            }
        }
    }
    
    public func getTopFilms() -> () {
        let url = getUrl(key: "top")
        let headers: HTTPHeaders = [accept: accept, "X-API-KEY": token]
        AF.request(url , method: .get, headers: headers).responseData { response in
            guard let data = response.data else {
                return
            }
            self.jsonTopFilms = JSON(data)["films"]
        }
    }
    
    public func getGenres() -> () {
        let url = getUrl(key: "genres")
        let headers: HTTPHeaders = [accept: accept, "X-API-KEY": token]
        AF.request(url, method: .get, headers: headers).responseData { response in
            guard let data = response.data else {
                return
            }
            self.jsonGenres = JSON(data)["genres"]
        }
    }
    
    public func getFilm(id: Int) -> (FilmsData) {
        let url = getUrl(key: "film")
        let headers: HTTPHeaders = [accept: accept, "X-API-KEY": token]
        AF.request(url + "\(id)" , method: .get, headers: headers).responseData { response in
            guard let data = response.data else {
                return
            }
            DispatchQueue.main.async {
                self.jsonFilm = self.buildFilm(JSON(data)[])
            }
        }
        return jsonFilm
    }
    
    private func buildFilm(_ filmData: JSON) -> FilmsData {
        let film = FilmsData( title: filmData["nameRu"].string, year: filmData["year"].int, description: filmData["description"].string, poster: filmData["posterUrl"].string, externalId: filmData["kinopoiskId"].int,genres: filmData["genres"].arrayValue.map {$0["genre"].stringValue}, countries: filmData["countries"].arrayValue.map {$0["country"].stringValue})
        return film
    }
    
    private func getUrl(key:String) -> String{
        let url = host + pathes[key]!
        return(url)
    }
}

