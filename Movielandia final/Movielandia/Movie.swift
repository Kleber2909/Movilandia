//
//  Movie.swift
//  Movielandia
//
//  Created by posgrad on 23/11/2019.
//  Copyright © 2019 Ronilson. All rights reserved.
//

import Foundation
import UIKit

class Movie {
    
    let id: Int
    let title: String
    let poster_path: String
    let overview: String
    let genere: String

    init(){
        self.id = 0
        self.title = ""
        self.poster_path = ""
        self.overview = ""
        self.genere = ""
    }
    
    init(_ id: Int, _ title: String, _ poster_path: String, _ overview: String, _ genere: String)
    {
        self.id = id
        self.title = title
        self.poster_path = poster_path
        self.overview = overview
        self.genere = genere
    }
    
}
