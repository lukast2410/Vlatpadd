//
//  ProfileViewController.swift
//  Vlatpadd
//
//  Created by Lukas Tanto on 12/01/22.
//  Copyright © 2022 Lukas Tanto. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var usernameLbl: UILabel!
    @IBOutlet var emailLbl: UILabel!
    @IBOutlet var storiesLbl: UILabel!
    @IBOutlet var commentsLbl: UILabel!
    @IBOutlet var storyTable: UITableView!
    var context: NSManagedObjectContext!
    var stories = [Story]()
    var user: User!
    var selectedIndex = -1
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        storyTable.estimatedRowHeight = 50.0
        storyTable.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let userData = defaults.value(forKey: "user") as! [String:String]
        
        usernameLbl.text = userData["username"]
        emailLbl.text = userData["email"]
        
        loadData(username: userData["username"]!)
    }
    
    func loadData(username: String){
        let req = NSFetchRequest<User>(entityName: "User")
        let pred = NSPredicate(format: "username == %@", username)
        req.predicate = pred
        
        do{
            let res = try context.fetch(req)
            
            user = res[0]
            let temp = user.stories?.allObjects as! [Story]
            stories.removeAll()
            stories.append(contentsOf: temp)
            
            let storyCount = stories.count
            storiesLbl.text = Helper.formatNumber(number: storyCount)
            
            var commCount = 0
            for s in stories {
                commCount += (s.comments?.count ?? 0)
            }
            commentsLbl.text = Helper.formatNumber(number: commCount)
            
            storyTable.reloadData()
        }catch{
            
        }
    }
    
    @IBAction func goEditProfile(_ sender: Any) {
        performSegue(withIdentifier: "segueEditProfile", sender: self)
    }
    
    @IBAction func logout(_ sender: Any) {
        defaults.set(nil, forKey: "user")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unwindToProfileFromEdit(_ unwindSegue: UIStoryboardSegue) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let storyCell = tableView.dequeueReusableCell(withIdentifier: "storyCellProfile", for: indexPath) as! StoryItemViewCell
        storyCell.usernameLbl.text = stories[indexPath.row].username
        storyCell.titleLbl.text = stories[indexPath.row].title
        storyCell.contentTV.text = stories[indexPath.row].content
        storyCell.commentLbl.text = "\(String(describing: stories[indexPath.row].comments?.count ?? 0)) comment(s)"
        storyCell.contentTV.textContainer.maximumNumberOfLines = 6
        storyCell.contentTV.textContainer.lineBreakMode = .byTruncatingTail
        storyCell.contentTV.translatesAutoresizingMaskIntoConstraints = true
        storyCell.contentTV.sizeToFit()
        storyCell.contentTV.isScrollEnabled = false
        
        return storyCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "segueToDetail", sender: self)
    }
    
    @IBAction func unwindToProfileFromDetail(_ unwindSegue: UIStoryboardSegue) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToDetail" && selectedIndex > -1 {
            let dest = segue.destination as! StoryDetailViewController
            
            dest.story = stories[selectedIndex]
            dest.type = 1
            selectedIndex = -1
        }
    }
}
