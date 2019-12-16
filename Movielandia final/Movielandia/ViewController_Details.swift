//
//  ViewController_Details.swift
//  Movielandia
//
//  Created by posgrad on 23/11/2019.
//  Copyright © 2019 Ronilson. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase


class ViewController_Details: UIViewController {
    
    var movie = Movie()
    var userId = ""
    var imagem = UIImage()
    var descButtom = "Favorito"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelTitulo: UILabel!
    @IBOutlet weak var labelDesc: UITextView!
    @IBOutlet weak var Favorito: UIButton!
    
    // Variavel global
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTitulo.text = movie.title
        labelDesc.text = movie.overview
        imageView.image = imagem
        
        // DidLoad
        ref = Database.database().reference()
        
        Favorito.setTitle(descButtom, for: .normal)
        
        
        //self.navigationController?.navigationBar.topItem?.hidesBackButton = true
        //self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Favorito(_ sender: Any) {
        if(Favorito.titleLabel?.text == "Favorito"){
            self.ref.child(userId).child("favorite").child(String(movie.id)).setValue(["id":movie.id, "title":movie.title, "poster_path":movie.poster_path,"overview":movie.overview,"genere":movie.genere])
            Favorito.setTitle("Remover Favorito", for: .normal)
        }else{
            self.ref.child(userId).child("favorite").child(String(movie.id)).removeValue()
            Favorito.setTitle("Favorito", for: .normal)
        }
    }
}
