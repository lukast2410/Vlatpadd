//
//  EditProfileViewController.swift
//  Vlatpadd
//
//  Created by Lukas Tanto on 12/01/22.
//  Copyright © 2022 Lukas Tanto. All rights reserved.
//

import UIKit
import CoreData

class EditProfileViewController: UIViewController {
    let defaults = UserDefaults.standard
    @IBOutlet var usernameLbl: UILabel!
    @IBOutlet var emailLbl: UILabel!
    @IBOutlet var phoneTF: UITextField!
    @IBOutlet var newPassTF: UITextField!
    @IBOutlet var confirmPassTF: UITextField!
    
    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        let userData = defaults.value(forKey: "user") as! [String:String]
        
        usernameLbl.text = userData["username"]
        emailLbl.text = userData["email"]
        phoneTF.text = userData["phonenumber"]
    }

    @IBAction func saveProfile(_ sender: Any) {
        let phoneNumber = phoneTF.text!
        let password = newPassTF.text!
        let confirmPassword = confirmPassTF.text!
        var userData = defaults.value(forKey: "user") as! [String:String]
        
        if phoneNumber == "" {
            alert(msg: "Phone Number cannot be empty", handler: nil, showCancel: false)
        }else if !Helper.isNumeric(str: phoneNumber) {
            alert(msg: "Phone Number must be numeric", handler: nil, showCancel: false)
        }else if password == "" {
            if phoneNumber != userData["phonenumber"] {
                update(phoneNumber: phoneNumber, password: "")
                alert(msg: "Profile Updated", handler: { (al) in
                    self.performSegue(withIdentifier: "backToProfile", sender: self)
                }, showCancel: false)
            }else{
                alert(msg: "Nothing Changed", handler: nil, showCancel: false)
            }
        }else if !Helper.haveDigit(str: password) {
            alert(msg: "Password must contains number", handler: nil, showCancel: false)
        }else if !Helper.haveAlphabet(str: password) {
            alert(msg: "Password must contains alphabet", handler: nil, showCancel: false)
        }else if confirmPassword == "" {
            alert(msg: "Confirm password cannot be empty", handler: nil, showCancel: false)
        }else if confirmPassword != password {
            alert(msg: "Confirm password not match with password", handler: nil, showCancel: false)
        }else{
            update(phoneNumber: phoneNumber, password: password)
            alert(msg: "Profile Updated", handler: { (al) in
                self.performSegue(withIdentifier: "backToProfile", sender: self)
            }, showCancel: false)
        }
    }
    
    func update(phoneNumber: String, password: String){
        var userData = defaults.value(forKey: "user") as! [String:String]
        userData["phonenumber"] = phoneNumber
        userData["password"] = password
        defaults.set(userData, forKey: "user")
        
        let req = NSFetchRequest<User>(entityName: "User")
        let pred = NSPredicate(format: "username == %@", userData["username"]!)
        req.predicate = pred
        
        do{
            let res = try context.fetch(req)
            
            for data in res {
                data.phonenumber = phoneNumber
                if password != "" {
                    data.password = password
                }
            }
            
            try context.save()
        }catch{
            
        }
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
