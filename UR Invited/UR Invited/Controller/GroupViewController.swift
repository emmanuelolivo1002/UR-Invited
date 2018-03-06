//
//  GroupViewController.swift
//  UR Invited
//
//  Created by Emmanuel Olivo on 2/02/18.
//  Copyright © 2018 MJ Invited LLC. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
    

    // MARK: Variables
    var groupsArray = [Group]()
    
    
    
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
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Observe every time there is a change in database
        DataService.instance.REF_GROUPS.observeSingleEvent(of: .value) { (snapshot) in
            DataService.instance.getAllGroups { (returnedGroupsArray) in
                // Set local groups array to be equal to the returned array and reload data
                self.groupsArray = returnedGroupsArray
                print("Groups in array: \(self.groupsArray.count)")
                
                self.groupTableView.reloadData()
            }
        }
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
        if let cell = groupTableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? GroupTableViewCell {
            
            let group = groupsArray[indexPath.row]
            
            cell.configureCell(group: group)
            
            // Return custom cell
            return cell
       
        } else {
        
            // Return empty cell if GroupTableViewCell could not be created
            return UITableViewCell()
        }
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
