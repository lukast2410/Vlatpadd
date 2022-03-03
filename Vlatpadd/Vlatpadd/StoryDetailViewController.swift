//
//  StoryDetailViewController.swift
//  Vlatpadd
//
//  Created by Lukas Tanto on 13/01/22.
//  Copyright © 2022 Lukas Tanto. All rights reserved.
//

import UIKit
import CoreData

class StoryDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var usernameLbl: UILabel!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var contentTV: UITextView!
    @IBOutlet var commentsLbl: UILabel!
    @IBOutlet var commentTable: UITableView!
    @IBOutlet var deleteBtn: UIBarButtonItem!
    @IBOutlet var commentTF: UITextField!
    let defaults = UserDefaults.standard
    var story: Story!
    var context: NSManagedObjectContext!
    var comments = [Comment]()
    var type = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userData = defaults.value(forKey: "user") as! [String:String]
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        if story.username == userData["username"] {
            deleteBtn.tintColor = UIColor.red
            deleteBtn.isEnabled = true
        }else{
            deleteBtn.isEnabled = false
            deleteBtn.tintColor = UIColor.clear
        }
        
        usernameLbl.text = story.username
        titleLbl.text = story.title
        contentTV.text = story.content
        commentsLbl.text = "\(story.comments?.count ?? 0) Comment(s)"
        contentTV.translatesAutoresizingMaskIntoConstraints = true
        contentTV.sizeToFit()
        contentTV.isScrollEnabled = false
        
        commentTable.estimatedRowHeight = 50.0
        commentTable.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData() {
        let temp = story.comments?.allObjects as! [Comment]
        comments.removeAll()
        comments.append(contentsOf: temp)
        commentsLbl.text = "\(story.comments?.count ?? 0) Comment(s)"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let header = commentTable.tableHeaderView
        let size = header?.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if header?.frame.size.height != size?.height {
            header!.frame.size.height = size?.height ?? 0
            commentTable.tableHeaderView = header
            commentTable.layoutIfNeeded()
        }
    }
    
    @IBAction func deleteStory(_ sender: Any) {
        do{
            context.delete(story)
            
            try context.save()
        }catch{
        }
        
        if type == 0 {
            performSegue(withIdentifier: "backToHomeFromDetail", sender: self)
        }else{
            type = 0
            performSegue(withIdentifier: "backToProfileFromDetail", sender: self)
        }
    }
    
    @IBAction func back(_ sender: Any) {
        if type == 0 {
            performSegue(withIdentifier: "backToHomeFromDetail", sender: self)
        }else{
            type = 0
            performSegue(withIdentifier: "backToProfileFromDetail", sender: self)
        }
    }
    
    @IBAction func sendComment(_ sender: Any) {
        let userData = defaults.value(forKey: "user") as! [String:String]
        let comment = commentTF.text!
        
        if comment != "" {
            let comm = Comment(context: context)
            comm.username = userData["username"]!
            comm.content = comment
            
            story.addToComments(comm)
            
            do{
                try context.save()
            }catch{
            }
            
            comments.append(comm)
            commentTable.reloadData()
            commentTF.text = ""
            commentsLbl.text = "\(story.comments?.count ?? 0) Comment(s)"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let commentCell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentItemViewCell
        commentCell.usernameLbl.text = comments[indexPath.row].username
        commentCell.contentTV.text = comments[indexPath.row].content
        commentCell.contentTV.translatesAutoresizingMaskIntoConstraints = true
        commentCell.contentTV.sizeToFit()
        commentCell.contentTV.isScrollEnabled = false
        
        return commentCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
