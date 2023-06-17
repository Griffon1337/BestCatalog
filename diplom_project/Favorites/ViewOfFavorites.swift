//
//  ViewOfFavorites.swift
//  diplom_project
//
//  Created by Грифон on 27.05.23.
//

import UIKit
import CoreData

class ViewOfFavorites: UIViewController {
    
    @IBOutlet var tableOfFavorites: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tuneUI()
        performFetchedRC()
    }
    
    func tuneUI() {
        let nibCell = UINib(nibName: "CustomCell", bundle: nil)
        tableOfFavorites.register(nibCell, forCellReuseIdentifier: "customCell")
        tableOfFavorites.dataSource = self
        tableOfFavorites.delegate = self
    }
    
    func performFetchedRC() {
        do {
            try fetchedRC.performFetch()
        }
        catch{
            print (error)
        }
    }
    
    lazy var fetchedRC: NSFetchedResultsController<Favorites> = {
        let fetchedRequest = Favorites.fetchRequest()
        let nameDescriptor = NSSortDescriptor(key: "film", ascending: true)
        fetchedRequest.sortDescriptors = [nameDescriptor]
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchedRequest, managedObjectContext: CoreDataManager.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        return fetchedResultController
    }()
    
    @IBAction func search(_ sender: Any) {
        let alertController = UIAlertController(title: "Ждите в следующем обновлении))))", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel)
        alertController.addAction(cancelAction)
        self.present(alertController,animated: true)
    }
}

extension ViewOfFavorites: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableOfFavorites.reloadData()
    }
}
extension ViewOfFavorites: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedRC.fetchedObjects?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableOfFavorites.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
        let film = fetchedRC.object(at: indexPath)
        cell.customCellName.text = film.film
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let nVC = storyboard?.instantiateViewController(withIdentifier: "FILM") as? FilmDescription {
            nVC.id = Int(fetchedRC.object(at: indexPath).id)
            navigationController?.pushViewController(nVC, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        let film = fetchedRC.object(at: indexPath)
        CoreDataManager.shared.context.delete(film)
        CoreDataManager.shared.save { error in
            guard let _ = error else {
                return
            }
        }
    }
}

