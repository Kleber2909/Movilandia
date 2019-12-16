//
//  Genere.swift
//  Movielandia
//
//  Created by posgrad on 07/12/2019.
//  Copyright © 2019 Ronilson. All rights reserved.
//

import Foundation

class Genere{

let id: Int
let name: String

    init(){
        self.id = 0
        self.name = ""
    }
    
    init(_ id: Int, _ name: String)
    {
        self.id = id
        self.name = name
    }

}
