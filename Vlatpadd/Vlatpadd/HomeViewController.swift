//
//  HomeViewController.swift
//  Vlatpadd
//
//  Created by Lukas Tanto on 13/01/22.
//  Copyright © 2022 Lukas Tanto. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var storyTable: UITableView!
    var context: NSManagedObjectContext!
    var stories = [Story]()
    var selectedIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        storyTable.estimatedRowHeight = 50.0
        storyTable.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData(){
        let req = NSFetchRequest<Story>(entityName: "Story")
        
        do{
            let res = try context.fetch(req)
            
            stories.removeAll()
            stories.append(contentsOf: res)
            
            storyTable.reloadData()
        }catch{
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let storyCell = tableView.dequeueReusableCell(withIdentifier: "storyCellHome", for: indexPath) as! StoryItemViewCell
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
        performSegue(withIdentifier: "segueToStoryDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToStoryDetail" && selectedIndex > -1 {
            let dest = segue.destination as! StoryDetailViewController
            dest.story = stories[selectedIndex]
            selectedIndex = -1
        }
    }
    
    @IBAction func unwindToHomeFromDetail(_ unwindSegue: UIStoryboardSegue) {
    }
}
