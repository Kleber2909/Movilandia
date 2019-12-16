//
//  ViewController.swift
//  Movielandia
//
//  Created by posgrad on 23/11/2019.
//  Copyright © 2019 Ronilson. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var edtUser: UITextField!
    @IBOutlet weak var edtPass: UITextField!
    @IBOutlet weak var Login: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Login.layer.cornerRadius = 4
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func Logi(_ sender: Any) {
        
        let email = self.edtUser.text!
        let password = self.edtPass.text!
        
        print(email)
        print(password)
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if(error != nil) {
                print("\(error!.localizedDescription)")
                
                let alert = UIAlertController(title: "Erro", message: "\(error!.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self?.present(alert, animated: true)
                
                return
            }
        
            let movies = self?.storyboard?.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
            self?.navigationController?.pushViewController(movies, animated: true)
            
            print("Bem vindo !", authResult?.user.uid as Any)
        }
        
    }
    
}

