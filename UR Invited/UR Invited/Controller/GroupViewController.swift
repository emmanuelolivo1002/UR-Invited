//
//  GroupViewController.swift
//  UR Invited
//
//  Created by Emmanuel Olivo on 2/02/18.
//  Copyright © 2018 MJ Invited LLC. All rights reserved.
//

import UIKit
import Firebase


class GroupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
    

    // MARK: Variables
    var groupsArray = [Group]()
    
    // Array of groups not checked
    var updatedGroups = [String]()
    
    
    // MARK: Outlets
    @IBOutlet weak var groupTableView: UITableView!
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
        // Set self as tableview delegate and data source
        groupTableView.delegate = self
        groupTableView.dataSource = self
        
        // Register xib file for custom cell
        groupTableView.register(UINib(nibName: "GroupTableViewCell", bundle: nil), forCellReuseIdentifier: "GroupCell")
        
        var initialCount = 0
        var currentCount = 0
        
        // Observe whenever there is a change in the database
        DataService.instance.REF_GROUPS.observe(.value) { (groupSnapshot) in
            
            
            print("Something changed in \(groupSnapshot.key)")
            
            
            guard let groupSnapshot = groupSnapshot.children.allObjects
                as? [DataSnapshot] else { return }
            
            print("Snapshot endIndex: \(groupSnapshot.endIndex)")
            
            for group in groupSnapshot {
            
                currentCount = Int(group.childSnapshot(forPath: "messages").childrenCount)
                
                
                print("Current count: \(currentCount) for group: \(group.key)")
                
            }
            
            
            
            
            
//            if currentCount > initialCount && initialCount != 0 {
//                DataService.instance.REF_GROUPS.child(group.key).child("messages").observeSingleEvent(of: .childAdded, with: { (messageSnapshot) in
//
//
//                    print("Message added: \(messageSnapshot.key) in group: \(group.key)")
//
//                    initialCount = currentCount
//                })
//            }
        }
        
//        DataService.instance.REF_GROUPS.child("-L88bp3r2aXd_qlHMwYX").child("messages").observeSingleEvent(of: .value) { (messageSnapshot) in
//            initialCount = Int(messageSnapshot.childrenCount)
//
//            print("Initial count: \(initialCount)")
//
//            DataService.instance.REF_GROUPS.child("-L88bp3r2aXd_qlHMwYX").child("messages").observe(.childAdded) { (messageSnapshot) in
//
//                currentCount += 1
//                print("Current count: \(currentCount)")
//
//
//
//                if currentCount > initialCount {
//
//
//                    print("Message added: \(messageSnapshot.childSnapshot(forPath: "content").value)")
//
//                }
//
//            }
//        }
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Observe every time there is a change in database
        DataService.instance.REF_GROUPS.observeSingleEvent(of: .value) { (snapshot) in
            DataService.instance.getAllGroups { (returnedGroupsArray) in
                // Set local groups array to be equal to the returned array and reload data
                self.groupsArray = returnedGroupsArray.reversed()
                print("Groups in array: \(self.groupsArray.count)")
                
                self.groupTableView.reloadData()
            }
        }
        
        
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.groupTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupTableView.reloadData()

    }
    
    
    // Table view Delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        // if GroupTableViewCell is created
        
        guard let cell = groupTableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? GroupTableViewCell else {return UITableViewCell()}
     
        let group = groupsArray[indexPath.row]
        
        var isNewMessageInGroup = false
        
        if updatedGroups.contains(group.groupTitle) {
            isNewMessageInGroup = true
        }
        
        cell.configureCell(group: group, newMesage: isNewMessageInGroup)
        
        
        // Return custom cell
        return cell
       
       
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? GroupTableViewCell else {return}
        
        // Set color of cell when selected
        let bgColorView = UIView()
        bgColorView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.selectedBackgroundView = bgColorView
        
        
    
        
        // Set a storyboard for groupFeedViewController
        guard let chatViewController = storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController else { return }
        
        // Initialize group in groupFeedViewController by passing the group selected
        chatViewController.initData(forGroup: groupsArray[indexPath.row])
        
        // present groupFeedViewController
        present(chatViewController, animated: true, completion: nil)
    }
    

    


}
