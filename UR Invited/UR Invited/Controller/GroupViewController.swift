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
    
    var testArray = TestVariables.instance.loadGroupArray()

    
    
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
    
    
    // Table view Delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testArray.count
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        // if GroupTableViewCell is created
        if let cell = groupTableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? GroupTableViewCell {
            
            let group = testArray[indexPath.row]
            
            cell.configureCell(group: group)
            
            // Return custom cell
            return cell
       
        } else {
        
            // Return empty cell if GroupTableViewCell could not be created
            return UITableViewCell()
        }
    }

    


}
