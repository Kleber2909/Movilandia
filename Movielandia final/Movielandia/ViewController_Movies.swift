//
//  ViewController_Movies.swift
//  Movielandia
//
//  Created by posgrad on 23/11/2019.
//  Copyright © 2019 Ronilson. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import UserNotifications

struct cellData  {
    var opened = Bool()
    var title = String()
    var sectionData = [Movie]()
}

class ViewController_Movies: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate  {
    
    var tableViewData = [cellData]()
    var tableViewDataSearch = [cellData]()
    
    var user = ""
    
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    final let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=d64533681aa6c5d4718df88118a3412e&language=pt-BRS&sort_by=popularity.desc&include_adult=false&include_video=false&page=1")
    
    final let urlGeneres = URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=d64533681aa6c5d4718df88118a3412e&language=pt-BR")
    
    var listMovies = [Movie]()
    var listGeneres = [Genere]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.getJsonLisGeneres()
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            self.user = (user?.uid)!
            print(self.user)
        }
        
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = false
    }
    
    func getJsonLisGeneres()
    {
        guard let downloarURL = urlGeneres else { return }
        URLSession.shared.dataTask(with: downloarURL)
        {
            data, urlResponse, error in
            guard let data = data, error == nil, urlResponse != nil else
            {
                print("urlResponse != nil")
                return
            }
            print("GetJson Generes")
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                let generes = json!["genres"] as? [[String: Any]]{
                print(generes)
                for genere in generes{
                  //  print(genere["name"] ?? "")
                    
                    let id = genere["id"] ?? ""
                    let name = genere["name"] ?? ""
                    
                    let g = Genere(id as! Int, name as! String)
                    
                    self.listGeneres.append(g)
                }
                self.getJsonListMovies()
            }
            }.resume()
    }
    
    func getJsonListMovies()
    {
        guard let downloarURL = url else { return }
        URLSession.shared.dataTask(with: downloarURL)
        {
            data, urlResponse, error in
            guard let data = data, error == nil, urlResponse != nil else
            {
                print("urlResponse != nil")
                return
            }
            print("GetJson")
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                let movies = json!["results"] as? [[String: Any]]{
                for movie in movies {
                    let id = movie["id"] ?? ""
                    let title = movie["title"] ?? ""
                    let poster_path = movie["poster_path"] ?? ""
                    let overview = movie["overview"] ?? ""
                    let generes: [Int] = movie["genre_ids"] as! [Int]
                    var genere = ""
                    
                    for g in self.listGeneres {
                        if(g.id == generes[0])
                        {
                            genere = g.name
                            break
                        }
                    }
                    
                    let m = Movie(id as! Int, title as! String, poster_path as! String, overview as! String, genere )
                    
                    self.listMovies.append(m)
                }
                
                self.tableViewData = self.getDataSource(self.listMovies)
                self.tableViewDataSearch = self.tableViewData
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                let m = self.listMovies[self.random(self.listMovies.count-1)]
                
                let notificationType = "Filme: " + m.title
                self.appDelegate?.scheduleNotification(notificationType: notificationType, body: "Novo filme adicionado na categoria " + m.genere + "!")
                
            }
            }.resume()
    }
    
    func random(_ maxNumber: Int) -> Int {
        return Int(arc4random_uniform(UInt32(maxNumber)))
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewDataSearch.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableViewDataSearch[section].opened == true {
            return tableViewDataSearch[section].sectionData.count + 1
        } else {
            return 1
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let dataIndex = indexPath.row - 1;
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") else {
                return UITableViewCell()
            }
            
            cell.textLabel?.text = tableViewDataSearch[indexPath.section].title
            cell.imageView?.image = nil
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") else {
                return UITableViewCell()
            }
            
            cell.textLabel?.text = tableViewDataSearch[indexPath.section].sectionData[dataIndex].title
            
            if let urlImage = URL(string: "https://image.tmdb.org/t/p/w500/"+tableViewDataSearch[indexPath.section].sectionData[dataIndex].poster_path){
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: urlImage)
                    if let data = data {
                        let imagem = UIImage(data: data)
                        DispatchQueue.main.async {
                            cell.imageView?.image = imagem
                            cell.setNeedsLayout()
                        }
                    }
                }
            }
            
            return cell
        }
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            tableViewDataSearch[indexPath.section].opened = !tableViewDataSearch[indexPath.section].opened
            
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
        }
        else{
            let detalhesView = storyboard?.instantiateViewController(withIdentifier: "ViewController_Details") as! ViewController_Details
            
            detalhesView.userId = user
            detalhesView.movie = listMovies[indexPath.row]
            detalhesView.imagem = (UIImage? ((tableView.cellForRow(at: indexPath)?.imageView?.image)!)!)!
            self.navigationController?.pushViewController(detalhesView, animated: true)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            let filteredMovies = getCurrentMovies().filter { $0.title.range(of: searchText, options: .caseInsensitive) != nil || $0.genere.range(of: searchText, options: .caseInsensitive) != nil }
            
            tableViewDataSearch = getDataSource(filteredMovies)
        } else {
            tableViewDataSearch = getDataSource(getCurrentMovies())
        }
        
        tableView.reloadData()
    }
    
    func getCurrentMovies() -> [Movie] {
        var result = [Movie]()
        tableViewData.forEach { cell in
            result += cell.sectionData
        }
        
        return result
    }
    
    func getDataSource(_ movies: [Movie]) -> [cellData] {
        var result = [cellData]()
        
        self.listGeneres.forEach { genere in
            let sectionMovies = movies.filter { $0.genere == genere.name }
            
            if sectionMovies.count > 0 {
                result.append(cellData(opened: false, title: genere.name, sectionData: sectionMovies))
            }
        }
        
        return result
    }
}
