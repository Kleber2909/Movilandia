//
//  ViewController_CreateUser.swift
//  Movielandia
//
//  Created by posgrad on 23/11/2019.
//  Copyright © 2019 Ronilson. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ViewController_CreateUser: UIViewController {
    
    @IBOutlet weak var edtEmail: UITextField!
    @IBOutlet weak var edtEmailConf: UITextField!
    @IBOutlet weak var edtPass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CreateNewUSer(_ sender: Any) {
        
        let email = self.edtEmail.text!
        let emailCheck = self.edtEmailConf.text!
        let password = self.edtPass.text!
        
        print(email)
        print(password)
        
        if(email != emailCheck){
            
            let alert = UIAlertController(title: "Erro", message: "Os emails nao coincidem !", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            if(error != nil) {
                print("\(error!.localizedDescription)")
                
                let alert = UIAlertController(title: "Erro", message: "\(error!.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                
                return
            }
            
            print("\(email) - Conta Criada !")
            
            let alert = UIAlertController(title: "Messagem", message: "\(email) - Conta Criada !", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true)
            
        }
        
    }
}
