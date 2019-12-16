//
//  ViewController_Favorites.swift
//  Movielandia
//
//  Created by posgrad on 23/11/2019.
//  Copyright © 2019 Ronilson. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class ViewController_Favorites: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var user = ""
    
    var listMovies = [Movie]()
    
    @IBOutlet weak var tableView: UITableView!
    // Variavel global
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    override func viewDidAppear(_ animated: Bool) {
        
        ref = Database.database().reference()
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            self.user = (user?.uid)!
            print(self.user)
            self.getFavoritos()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getFavoritos() {
        listMovies = [Movie]()
        ref.child(user).child("favorite").observeSingleEvent(of: .value, with: { (snapshot) in

            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    let movie = snap.value as? NSDictionary

                    let id = movie?["id"] as? Int ?? 0
                    let title = movie?["title"] as? String ?? ""
                    let poster_path = movie?["poster_path"] as? String ?? ""
                    let overview = movie?["overview"] as? String ?? ""
                    let genere = movie?["genere"] as? String ?? ""
                    
                    let m = Movie(id, title, poster_path, overview, genere)
                    
                    self.listMovies.append(m)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print("favoritos", listMovies.count)
        return(listMovies.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        print(listMovies[indexPath.row].title)
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cellId")
        cell.textLabel?.text = listMovies[indexPath.row].title
        
        
        if let urlImage = URL(string: "https://image.tmdb.org/t/p/w500/"+listMovies[indexPath.row].poster_path){
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
        
        return(cell)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detalhesView = storyboard?.instantiateViewController(withIdentifier: "ViewController_Details") as! ViewController_Details
        
        detalhesView.userId = user
        detalhesView.movie = listMovies[indexPath.row]
        detalhesView.imagem = (UIImage? ((tableView.cellForRow(at: indexPath)?.imageView?.image)!)!)!
        detalhesView.descButtom = "Remover Favorito"
        listMovies = [Movie]()
        self.navigationController?.pushViewController(detalhesView, animated: true)
 
    }
    
}
