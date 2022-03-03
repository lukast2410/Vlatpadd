//
//  ViewController.swift
//  Vlatpadd
//
//  Created by Lukas Tanto on 12/01/22.
//  Copyright © 2022 Lukas Tanto. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet var usernameLbl: UITextField!
    @IBOutlet var passwordLbl: UITextField!
    var context: NSManagedObjectContext!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
    }
    
    @IBAction func doLogin(_ sender: Any) {
        let username = usernameLbl.text!
        let password = passwordLbl.text!
        
        if username == "" {
            alert(msg: "Username can't be empty", handler: nil, showCancel: false)
        }else if password == "" {
            alert(msg: "Password can't be empty", handler: nil, showCancel: false)
        }else{
            let req = NSFetchRequest<User>(entityName: "User")
            let predicate = NSPredicate(format: "username == %@ AND password == %@", username, password)
            req.predicate = predicate
            
            do{
                let res = try context.fetch(req)
                
                print("user count: \(res.count)")
                if(res.count == 0){
                    alert(msg: "Wrong email or password", handler: nil, showCancel: false)
                    
                }else{
                    let user = res[0]
                    let data = [
                        "username": user.username,
                        "email": user.email,
                        "phonenumber": user.phonenumber,
                        "password": user.password
                    ]
                    
                    defaults.set(data, forKey: "user")
                    
                    performSegue(withIdentifier: "goToHome", sender: self)
                    
                    usernameLbl.text = ""
                    passwordLbl.text = ""
                }
            }catch{
                
            }
        }
    }
    
    @IBAction func goRegister(_ sender: Any) {
        performSegue(withIdentifier: "goToRegister", sender: self)
    
    }
    
    @IBAction func unwindToLoginFromRegister(_ unwindSegue: UIStoryboardSegue) {
    }
    
    func alert (msg: String, handler: ((UIAlertAction)->Void)?, showCancel: Bool){
        let alert = UIAlertController(title: "Alert", message: msg,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: handler)
        let cancelAction  = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        if(showCancel){
            alert.addAction(cancelAction)
        }
        
        present(alert, animated: true, completion: nil)
    }
}

