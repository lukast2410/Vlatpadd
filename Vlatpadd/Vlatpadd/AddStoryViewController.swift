//
//  AddStoryViewController.swift
//  Vlatpadd
//
//  Created by Lukas Tanto on 13/01/22.
//  Copyright © 2022 Lukas Tanto. All rights reserved.
//

import UIKit
import CoreData

class AddStoryViewController: UIViewController {
    @IBOutlet var titleTF: UITextField!
    @IBOutlet var contentTV: UITextView!
    let defaults = UserDefaults.standard
    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func addStory(_ sender: Any) {
        let title = titleTF.text!
        let content = contentTV.text!
        
        if title == "" {
            alert(msg: "Title can't be empty", handler: nil, showCancel: false)
        }else if title.count > 30 {
            alert(msg: "Title must be less than 30 characters", handler: nil, showCancel: false)
        }else if content == "" {
            alert(msg: "Content can't be empty", handler: nil, showCancel: false)
        }else{
            let userData = defaults.value(forKey: "user") as! [String:String]
            
            let username = userData["username"]!
            let req = NSFetchRequest<User>(entityName: "User")
            let pred = NSPredicate(format: "username == %@", username)
            req.predicate = pred
            
            var user: User!
            do{
                let res = try context.fetch(req)
                user = res[0]
            }catch{
                
            }
            
            let story = Story(context: context)
            story.username = username
            story.content = content
            story.title = title
            
            user.addToStories(story)
            
            do{
                try context.save()
            }catch{
                
            }
            
            alert(msg: "Success Create a Story", handler: nil, showCancel: false)
            titleTF.text = ""
            contentTV.text = ""
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
