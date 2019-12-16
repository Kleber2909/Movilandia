//
//  ViewController_RecoverPassword.swift
//  Movielandia
//
//  Created by posgrad on 23/11/2019.
//  Copyright © 2019 Ronilson. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ViewController_RecoverPassword: UIViewController {
    
    @IBOutlet weak var edtEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func RecoverPassword(_ sender: Any) {
        
        let email = self.edtEmail.text!

        Auth.auth().sendPasswordReset(withEmail: email) { (Err) in
            if(Err != nil){
                let alert = UIAlertController(title: "Erro", message: "\(Err!.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                
            }else{
                let alert = UIAlertController(title: "Sucesso", message: "Um email de redefinicao foi enviado para voce !", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true)
            }
            
        }
    
    }
}
