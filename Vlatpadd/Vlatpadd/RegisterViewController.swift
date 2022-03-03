//
//  RegisterViewController.swift
//  Vlatpadd
//
//  Created by Lukas Tanto on 12/01/22.
//  Copyright © 2022 Lukas Tanto. All rights reserved.
//

import UIKit
import CoreData

class RegisterViewController: UIViewController {
    @IBOutlet var usernameTxtField: UITextField!
    @IBOutlet var emailTxtField: UITextField!
    @IBOutlet var phoneNumberTxtField: UITextField!
    @IBOutlet var passwordTxtField: UITextField!
    @IBOutlet var confirmPasswordTxtField: UITextField!
    
    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func doRegister(_ sender: Any) {
        let username = usernameTxtField.text!
        let email = emailTxtField.text!
        let phoneNumber = phoneNumberTxtField.text!
        let password = passwordTxtField.text!
        let confirmPassword = confirmPasswordTxtField.text!
        
        if username == "" {
            alert(msg: "Username can't be empty", handler: nil, showCancel: false)
        }else if !Helper.haveDigit(str: username) {
            alert(msg: "Username must contains number", handler: nil, showCancel: false)
        }else if !Helper.haveAlphabet(str: username) {
            alert(msg: "Username must contains alphabet", handler: nil, showCancel: false)
        }else if email == "" {
            alert(msg: "Email can't be empty", handler: nil, showCancel: false)
        }else if !Helper.validEmail(str: email) {
            alert(msg: "Wrong Email Format", handler: nil, showCancel: false)
        }else if phoneNumber == "" {
            alert(msg: "Phone Number cannot be empty", handler: nil, showCancel: false)
        }else if !Helper.isNumeric(str: phoneNumber) {
            alert(msg: "Phone Number must be numeric", handler: nil, showCancel: false)
        }else if password == "" {
            alert(msg: "Password cannot be empty", handler: nil, showCancel: false)
        }else if !Helper.haveDigit(str: password) {
            alert(msg: "Password must contains number", handler: nil, showCancel: false)
        }else if !Helper.haveAlphabet(str: password) {
            alert(msg: "Password must contains alphabet", handler: nil, showCancel: false)
        }else if confirmPassword == "" {
            alert(msg: "Confirm password cannot be empty", handler: nil, showCancel: false)
        }else if confirmPassword != password {
            alert(msg: "Confirm password not match with password", handler: nil, showCancel: false)
        }else{
            let req = NSFetchRequest<User>(entityName: "User")
            let pred = NSPredicate(format: "username == %@ OR email == %@", username, email)
            req.predicate = pred
            
            do{
                let res = try context.fetch(req)
                
                if res.count > 0 {
                    if res[0].email == email {
                        alert(msg: "Email already exists", handler: nil, showCancel: false)
                    }else if res[0].username == username {
                        alert(msg: "Username already exists", handler: nil, showCancel: false)
                    }
                }else{
                    let user = User(context: context)
                    user.username = username
                    user.email = email
                    user.phonenumber = phoneNumber
                    user.password = password
                    
                    try context.save()
                    alert(msg: "Register Succesfull", handler: { action in self.performSegue(withIdentifier: "backFromRegisterToLogin", sender: self)
                    }, showCancel: false)
                }
            }catch{
                
            }
        }
    }
    
    @IBAction func backToLogin(_ sender: Any) {
        performSegue(withIdentifier: "backFromRegisterToLogin", sender: self)
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
